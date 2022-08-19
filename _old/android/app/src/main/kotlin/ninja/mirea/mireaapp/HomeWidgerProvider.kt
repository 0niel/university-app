package ninja.mirea.mireaapp

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
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
import java.text.SimpleDateFormat
import java.util.*


class HomeWidgetProvider : AbstractHomeWidgetProvider() {

    val ACTION_AUTO_UPDATE_WIDGET = "ACTION_AUTO_UPDATE_WIDGET"

    override fun onEnabled(context: Context) {
        super.onEnabled(context)

        // Reload widget every midnight
        val intent = Intent(context, HomeWidgetProvider::class.java)
        intent.action = ACTION_AUTO_UPDATE_WIDGET
        val pIntent = PendingIntent.getBroadcast(context, 0, intent, 0)
        val alarmManager = context
            .getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val c = Calendar.getInstance()
        c[Calendar.HOUR_OF_DAY] = 0
        c[Calendar.MINUTE] = 1
        c[Calendar.SECOND] = 0
        c[Calendar.MILLISECOND] = 1
        c.add(Calendar.MINUTE, 3)
       alarmManager.setRepeating(
           AlarmManager.RTC, c.timeInMillis,
           AlarmManager.INTERVAL_DAY, pIntent
       )
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val scheduleData = widgetData.getString("schedule", "")!!
            val weekData = widgetData.getString("daysStuff", "")!!

            // Get current week num or placeholder
            var week = "-228"
            if (weekData.isNotEmpty()) {
                val jsonObjWeek = Json.parseToJsonElement(weekData).jsonObject
                week = jsonObjWeek[Calendar.getInstance().get(Calendar.DAY_OF_YEAR)
                    .toString()].toString()
            }

            val views = RemoteViews(context.packageName, R.layout.timetable_layout).apply {
                // if semester is going now
                if (week.matches("\\d+".toRegex()) && week.toInt() > 0) {
                    // set onClick action
                    val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                        context,
                        MainActivity::class.java
                    )
                    setOnClickPendingIntent(R.id.widget_container, pendingIntent)
                    setOnClickPendingIntent(R.id.widget_placeHolder, pendingIntent)

                    // set Header
                    if (scheduleData.isNotEmpty()) {
                        val scheduleModel =
                            Json.decodeFromString(ScheduleModel.serializer(), scheduleData)

                        // val date: String = SimpleDateFormat("dd-MM HH:mm:ss").format(Date())

                        setTextViewText(
                            R.id.widget_title,
                            "Группа: ${scheduleModel.group} | Неделя: $week"
                        )

                        setViewVisibility(R.id.widget_main, View.VISIBLE)
                        setViewVisibility(R.id.widget_no_lessons, View.GONE)
                        setViewVisibility(R.id.widget_placeHolder, View.GONE)
                    } else {
                        // set loading placeholder
                        setViewVisibility(R.id.widget_main, View.GONE)
                        setViewVisibility(R.id.widget_no_lessons, View.GONE)
                        setViewVisibility(R.id.widget_placeHolder, View.VISIBLE)
                    }
                }else{
                    // set no lessons placeholder
                    setViewVisibility(R.id.widget_no_lessons, View.VISIBLE)
                    setViewVisibility(R.id.widget_main, View.GONE)
                    setViewVisibility(R.id.widget_placeHolder, View.GONE)
                }

                val b = 1 + 1
            }

            // set lessons list
            if (week.matches("\\d+".toRegex()) && week.toInt() > 0) {
                setList(views, context, widgetId, scheduleData, week)
            }

            // update widget
            appWidgetManager.updateAppWidget(widgetId, views)

            // update lessons list
            appWidgetManager.notifyAppWidgetViewDataChanged(
                widgetId,
                R.id.lvList
            )
        }
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        val intent = Intent(ACTION_AUTO_UPDATE_WIDGET)
        val alarmMgr = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmMgr.cancel(PendingIntent.getBroadcast(context, 0, intent, 0))
    }

    override fun onReceive(context: Context?, intent: Intent) {
        super.onReceive(context, intent)

       if (intent.action.equals(ACTION_AUTO_UPDATE_WIDGET)) {
           val thisAppWidget = ComponentName(
               context!!.packageName, javaClass.name
           )

           val appWidgetManager = AppWidgetManager
               .getInstance(context)
           val ids = appWidgetManager.getAppWidgetIds(thisAppWidget)

           onUpdate(context, AppWidgetManager.getInstance(context), ids)
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
        val random = Random()
        adapter.type = (random.nextInt(2281337)).toString()

        rv.setRemoteAdapter(R.id.lvList, adapter)
    }
}
