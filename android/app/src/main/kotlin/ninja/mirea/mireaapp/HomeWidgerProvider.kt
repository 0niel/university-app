package ninja.mirea.mireaapp

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonObject
import ninja.mirea.mireaapp.widget_channel.AbstractHomeWidgetProvider
import ninja.mirea.mireaapp.widget_channel.HomeWidgetLaunchIntent
import ninja.mirea.mireaapp.widget_channel.ScheduleModel
import ninja.mirea.mireaapp.widget_channel.UpdateWidgetService
import java.util.*


class HomeWidgetProvider : AbstractHomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val scheduleData = widgetData.getString("schedule", "")!!
            val weekData = widgetData.getString("daysStuff", "")!!

            var week = ""
            if (weekData.isNotEmpty()) {
                val jsonObjWeek = Json.parseToJsonElement(weekData).jsonObject
                week = jsonObjWeek[Calendar.getInstance().get(Calendar.DAY_OF_YEAR)
                    .toString()].toString()
            }

            val views = RemoteViews(context.packageName, R.layout.timetable_layout).apply {
                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)
//                setOnClickPendingIntent(R.id.lvList, pendingIntent)


                if (scheduleData.isNotEmpty() && weekData.isNotEmpty()) {
                    val scheduleModel =
                        Json.decodeFromString(ScheduleModel.serializer(), scheduleData)

                    setTextViewText(
                        R.id.widget_title,
                        "Группа: ${scheduleModel.group} | Неделя: $week"
                    )

                    setViewVisibility(R.id.widget_main, View.VISIBLE)
                    setViewVisibility(R.id.widget_placeHolder, View.GONE)
                } else {
//                    setTextViewText(R.id.widget_title, "NUll data ")
                    setViewVisibility(R.id.widget_main, View.GONE)
                    setViewVisibility(R.id.widget_placeHolder, View.VISIBLE)
                }


                val b = 1 + 1
            }

            setList(views, context, widgetId, scheduleData, week)

            appWidgetManager.updateAppWidget(widgetId, views)

            appWidgetManager.notifyAppWidgetViewDataChanged(
                widgetId,
                R.id.lvList
            )
        }
    }

    private fun setList(
        rv: RemoteViews,
        context: Context?,
        appWidgetId: Int,
        schedule: String,
        week: String
    ) {
        val adapter = Intent(context, UpdateWidgetService::class.java)
        adapter.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        adapter.putExtra("schedule", schedule)
        adapter.putExtra("week", week)
        rv.setRemoteAdapter(R.id.lvList, adapter)
    }
}
