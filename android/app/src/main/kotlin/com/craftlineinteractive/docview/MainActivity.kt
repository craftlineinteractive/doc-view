package com.craftlineinteractive.docview

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val channelName = "com.craftlineinteractive.docview/open_with"
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
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).apply {
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
    }

    private fun handleIntent(intent: Intent, isInitial: Boolean) {
        val action = intent.action
        val uri = intent.data
        if (Intent.ACTION_VIEW == action && uri != null) {
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

