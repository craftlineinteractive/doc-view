package com.craftlineinteractive.docview

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class RecentFilesWidgetReceiver : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_recent_files)

            val headerIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse("docview://home")
            )
            views.setOnClickPendingIntent(R.id.widget_header, headerIntent)
            views.setOnClickPendingIntent(R.id.widget_empty_view, headerIntent)

            val rawJson = widgetData.getString("recent_files_json", null)
            val filesList = try {
                if (rawJson != null) JSONArray(rawJson) else JSONArray()
            } catch (e: Exception) {
                JSONArray()
            }

            val rowIds = intArrayOf(
                R.id.widget_row_1,
                R.id.widget_row_2,
                R.id.widget_row_3,
                R.id.widget_row_4,
                R.id.widget_row_5
            )
            val tagIds = intArrayOf(
                R.id.widget_row_tag_1,
                R.id.widget_row_tag_2,
                R.id.widget_row_tag_3,
                R.id.widget_row_tag_4,
                R.id.widget_row_tag_5
            )
            val titleIds = intArrayOf(
                R.id.widget_row_title_1,
                R.id.widget_row_title_2,
                R.id.widget_row_title_3,
                R.id.widget_row_title_4,
                R.id.widget_row_title_5
            )
            val timeIds = intArrayOf(
                R.id.widget_row_time_1,
                R.id.widget_row_time_2,
                R.id.widget_row_time_3,
                R.id.widget_row_time_4,
                R.id.widget_row_time_5
            )

            val count = Math.min(filesList.length(), 5)
            if (count == 0) {
                views.setViewVisibility(R.id.widget_empty_view, View.VISIBLE)
                for (i in 0 until 5) {
                    views.setViewVisibility(rowIds[i], View.GONE)
                }
            } else {
                views.setViewVisibility(R.id.widget_empty_view, View.GONE)
                for (i in 0 until 5) {
                    if (i < count) {
                        val item = filesList.getJSONObject(i)
                        val id = item.optString("id", "")
                        val name = item.optString("name", "Document")
                        val type = item.optString("type", "PDF").uppercase(Locale.ROOT)
                        val modifiedMillis = item.optLong("modified", 0L)

                        views.setViewVisibility(rowIds[i], View.VISIBLE)
                        views.setTextViewText(tagIds[i], type)
                        views.setTextViewText(titleIds[i], name)
                        views.setTextViewText(timeIds[i], formatTime(modifiedMillis))

                        val itemIntent = HomeWidgetLaunchIntent.getActivity(
                            context,
                            MainActivity::class.java,
                            Uri.parse("docview://open?id=$id")
                        )
                        views.setOnClickPendingIntent(rowIds[i], itemIntent)
                    } else {
                        views.setViewVisibility(rowIds[i], View.GONE)
                    }
                }
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun formatTime(millis: Long): String {
        if (millis <= 0L) return ""
        val diff = System.currentTimeMillis() - millis
        val minutes = diff / 60000
        val hours = diff / 3600000
        val days = diff / 86400000

        return when {
            minutes < 1 -> "now"
            minutes < 60 -> "${minutes}m"
            hours < 24 -> "${hours}h"
            days < 7 -> "${days}d"
            else -> SimpleDateFormat("MMM d", Locale.getDefault()).format(Date(millis))
        }
    }
}
