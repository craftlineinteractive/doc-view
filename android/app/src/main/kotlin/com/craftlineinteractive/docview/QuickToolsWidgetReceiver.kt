package com.craftlineinteractive.docview

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class QuickToolsWidgetReceiver : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_quick_tools)

            views.setOnClickPendingIntent(
                R.id.tool_scan,
                HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("docview://tools/scan")
                )
            )

            views.setOnClickPendingIntent(
                R.id.tool_image_to_pdf,
                HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("docview://tools/image-to-pdf")
                )
            )

            views.setOnClickPendingIntent(
                R.id.tool_search,
                HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("docview://search")
                )
            )

            views.setOnClickPendingIntent(
                R.id.tool_import,
                HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("docview://tools/import")
                )
            )

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
