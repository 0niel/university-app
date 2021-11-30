package ninja.mirea.mireaapp;

import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent
import android.content.SharedPreferences;
import android.widget.RemoteViews;
import ninja.mirea.mireaapp.widget_channel.AbstractHomeWidgetProvider
import ninja.mirea.mireaapp.widget_channel.HomeWidgetLaunchIntent

import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonObject
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
                week = jsonObjWeek[Calendar.getInstance().get(Calendar.DAY_OF_YEAR).toString()].toString()
            }

            val views = RemoteViews(context.packageName, R.layout.timetable_layout).apply {
                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)


                if (scheduleData!!.isNotEmpty() && weekData.isNotEmpty()){
                    val scheduleModel = Json.decodeFromString(ScheduleModel.serializer(),scheduleData);

                    setTextViewText(R.id.widget_title, "Группа: ${scheduleModel.group} | Неделя: $week")
                }else{
                    setTextViewText(R.id.widget_title, "NUll data ")
                }


//                removeAllViews(R.id.lvList)
//                val newView = RemoteViews(context.packageName, R.layout.timetable_layout)
//                newView.setTextViewText(R.id.widget_title, "1")
////                set
//                var e1:Exception? = null
//                try {
//                    addView(R.id.lvList, newView)
//                }catch (e:Exception){
//                    e1 = e;
//                    print(e)
//                }
                val b = 1+1;
//                try {
//                    for (i in 1..6) {
//                        print("add view");
//                        val newView = RemoteViews(context.packageName, R.layout.timetable_item)
//                        newView.setTextViewText(R.id.ti_main_text, "$i")
//
//                        addView(R.id.lvList, newView)
//                    }
//                }catch (e: Exception) {
//                    print(e.message);
//                }

//                setRemoteAdapter()

                // Swap Title Text by calling Dart Code in the Background
//                setTextViewText(
//                    R.id.widget_title, widgetData.getString("title", null)
//                        ?: "No Title Set"
//                )
//                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
//                    context,
//                    Uri.parse("homeWidgetExample://titleClicked")
//                )
//                setOnClickPendingIntent(R.id.widget_title, backgroundIntent)

//                val message = widgetData.getString("testString", null)
//                setTextViewText(
//                    R.id.widget_message, message
//                        ?: "No Message Set"
//                )
                // Detect App opened via Click inside Flutter
//                val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
//                    context,
//                    MainActivity::class.java,
//                    Uri.parse("homeWidgetExample://message?message=$message")
//                )
//                setOnClickPendingIntent(R.id.widget_message, pendingIntentWithData)
            }
            setList(views, context, widgetId, scheduleData, week)
            appWidgetManager.updateAppWidget(widgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId,
                R.id.lvList);
        }
    }

    private fun setList(rv: RemoteViews, context: Context?, appWidgetId: Int, schedule:String, week:String) {
        val adapter = Intent(context, UpdateWidgetService::class.java)
        adapter.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        adapter.putExtra("schedule", schedule)
        adapter.putExtra("week", week)
        rv.setRemoteAdapter(R.id.lvList, adapter)
    }
}
