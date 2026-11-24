package com.craftlineinteractive.docview

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val openWithChannelName = "com.craftlineinteractive.docview/open_with"
    private val fileManagerChannelName = "com.craftlineinteractive.docview/file_manager"
    private val widgetChannelName = "com.craftlineinteractive.docview/widgets"
    private var initialFilePath: String? = null
    private var methodChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            splashScreen.setOnExitAnimationListener { splashScreenView ->
                splashScreenView.remove()
            }
        }
        super.onCreate(savedInstanceState)
        intent?.let { handleIntent(it, isInitial = true) }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntent(intent, isInitial = false)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, openWithChannelName).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialFile" -> {
                        val path = initialFilePath
                        initialFilePath = null
                        result.success(path)
                    }
                    else -> result.notImplemented()
                }
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, fileManagerChannelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "openSystemFileManager" -> result.success(openSystemFileManager())
                else -> result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, widgetChannelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "isPinSupported" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val appWidgetManager = getSystemService(AppWidgetManager::class.java)
                        result.success(appWidgetManager?.isRequestPinAppWidgetSupported == true)
                    } else {
                        result.success(false)
                    }
                }
                "requestPinWidget" -> {
                    val widgetName = call.argument<String>("widget")
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val appWidgetManager = getSystemService(AppWidgetManager::class.java)
                        if (appWidgetManager?.isRequestPinAppWidgetSupported == true) {
                            val provider = when (widgetName) {
                                "recent_files" -> ComponentName(this, RecentFilesWidgetReceiver::class.java)
                                "quick_tools" -> ComponentName(this, QuickToolsWidgetReceiver::class.java)
                                else -> null
                            }
                            if (provider != null) {
                                val success = appWidgetManager.requestPinAppWidget(provider, null, null)
                                result.success(success)
                            } else {
                                result.error("INVALID_WIDGET", "Unknown widget name: $widgetName", null)
                            }
                        } else {
                            result.success(false)
                        }
                    } else {
                        result.success(false)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun openSystemFileManager(): Boolean {
        val downloadDocsUri = Uri.parse(
            "content://com.android.externalstorage.documents/document/primary%3ADownload"
        )
        val primaryIntent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(downloadDocsUri, "vnd.android.document/directory")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        try {
            if (primaryIntent.resolveActivity(packageManager) != null) {
                startActivity(primaryIntent)
                return true
            }
        } catch (_: Exception) {
            // Fall through to plain ACTION_VIEW without explicit MIME type
        }

        val uriOnlyIntent = Intent(Intent.ACTION_VIEW, downloadDocsUri).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        try {
            if (uriOnlyIntent.resolveActivity(packageManager) != null) {
                startActivity(uriOnlyIntent)
                return true
            }
        } catch (_: Exception) {
            // Fall through to ACTION_VIEW_DOWNLOADS
        }

        val downloadsIntent = Intent("android.intent.action.VIEW_DOWNLOADS").apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        try {
            if (downloadsIntent.resolveActivity(packageManager) != null) {
                startActivity(downloadsIntent)
                return true
            }
        } catch (_: Exception) {
            // No handler available; caller falls back to in-app Directories screen
        }
        return false
    }

    private fun handleIntent(intent: Intent, isInitial: Boolean) {
        val action = intent.action
        val uri = intent.data
        if (Intent.ACTION_VIEW == action && uri != null) {
            if (uri.scheme == "docview") {
                // Do not intercept or clear widget / deep link URIs
                return
            }
            val copiedPath = copyUriToInternalStorage(uri)
            // Prevent Flutter's deep linking engine from attempting to parse file:// or content:// as an app route
            intent.data = null
            if (copiedPath != null) {
                if (isInitial) {
                    initialFilePath = copiedPath
                } else {
                    methodChannel?.invokeMethod("onFileReceived", copiedPath)
                }
            }
        }
    }

    private fun copyUriToInternalStorage(uri: Uri): String? {
        return try {
            val fileName = queryFileName(uri) ?: "opened_file"
            val tempDir = File(cacheDir, "opened_with")
            if (!tempDir.exists()) tempDir.mkdirs()
            val targetFile = File(tempDir, fileName)

            contentResolver.openInputStream(uri)?.use { inputStream ->
                FileOutputStream(targetFile).use { outputStream ->
                    inputStream.copyTo(outputStream)
                }
            }
            targetFile.absolutePath
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun queryFileName(uri: Uri): String? {
        if (uri.scheme == "content") {
            contentResolver.query(uri, null, null, null, null)?.use { cursor ->
                val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                if (nameIndex != -1 && cursor.moveToFirst()) {
                    return cursor.getString(nameIndex)
                }
            }
        }
        return uri.lastPathSegment
    }
}

