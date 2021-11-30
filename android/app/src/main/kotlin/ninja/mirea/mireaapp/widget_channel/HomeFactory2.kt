package ninja.mirea.mireaapp.widget_channel

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import android.widget.TextView
import kotlinx.serialization.json.Json
import ninja.mirea.mireaapp.R
import java.lang.Exception
import java.util.*

class HomeFactory2 internal constructor(val context: Context, val intent: Intent) :
    RemoteViewsService.RemoteViewsFactory {
    var data: ArrayList<Lesson> = ArrayList()

    //    SimpleDateFormat sdf;
//    var widgetID: Int = intent.getIntExtra(
//        AppWidgetManager.EXTRA_APPWIDGET_ID,
//        AppWidgetManager.INVALID_APPWIDGET_ID
//    )

    override fun onCreate() {
//        data = ArrayList()
    }

    override fun getCount(): Int {
        return data.size
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun getLoadingView(): RemoteViews {
        return RemoteViews(context.packageName, R.layout.timetable_item)
    }

    override fun getViewAt(position: Int): RemoteViews {
        val rView = RemoteViews(
            context.packageName,
            R.layout.timetable_item
        )
        if (data[position].name.isNotEmpty()) {
            rView.setTextViewText(R.id.ti_main_text, data[position].name)
            rView.setTextViewText(R.id.ti_item, (position+1).toString())
            rView.setTextViewText(R.id.ti_start_time, data[position].time_start)
            rView.setTextViewText(R.id.ti_finish_time, data[position].time_end)
        }else{
            rView.setTextViewText(R.id.ti_main_text, "Нет пары")
            rView.setTextViewText(R.id.ti_item, (position+1).toString())
            rView.setTextViewText(R.id.ti_start_time, getStartTime(position))
            rView.setTextViewText(R.id.ti_finish_time, getFinishTime(position))
        }
        return rView
    }

    private fun getStartTime(position: Int):String{
        return when (position){
            0 -> "9:00"
            1 -> "10:40"
            2 -> "12:40"
            3 -> "14:20"
            4 -> "16:20"
            5 -> "18:00"
            else -> "error"
        }
    }

    private fun getFinishTime(position: Int):String{
        return when (position){
            0 -> "10:30"
            1 -> "12:10"
            2 -> "14:10"
            3 -> "15:50"
            4 -> "17:50"
            5 -> "19:30"
            else -> "error"
        }
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun hasStableIds(): Boolean {
        return true
    }

    override fun onDataSetChanged() {
        data!!.clear()
        //        data.add(sdf.format(new Date(System.currentTimeMillis())));
//        data.add(String.valueOf(hashCode()));
//        data.add(String.valueOf(widgetID));
//        for (int i = 3; i < 15; i++) {
//            data.add("Item " + i);
//        }
        val scheduleData = intent.getStringExtra("schedule") //GenericUtility.getStringFromSharedPrefsForKey("schedule", context) // widgetData.getString("schedule", "")
        val weekData = intent.getStringExtra("week")
//        val scheduleData = GenericUtility.getStringFromSharedPrefsForKey("schedule", context)

        if (scheduleData !=null && scheduleData!!.isNotEmpty() && weekData!=null && weekData.isNotEmpty()){
            val scheduleModel = Json.decodeFromString(ScheduleModel.serializer(),scheduleData);
            var week = weekData.toInt()

            val calendar: Calendar = Calendar.getInstance()
            var day: Int = calendar.get(Calendar.DAY_OF_WEEK)-1
            if (day == 0){
                day = 6
                week -= 1
            }
//            setTextViewText(R.id.widget_title, "Группа: ${scheduleModel.group} | Неделя: ")
//            var i = 0
            for(timeslot in scheduleModel.schedule[day.toString()]!!.lessons){
                var flag = false;
                for (lesson in timeslot){
                    if (lesson.weeks.contains(week)){
                        data.add(lesson)
                        flag = true
                    }
                }
                if (!flag) {
                    data.add(Lesson("", listOf(), "", "", "", listOf(), listOf()))
                }
//                i += 1;
            }
            val b = 1+1;
        }
    }

    override fun onDestroy() {}

}


//object GenericUtility {
//    fun getIntFromSharedPrefsForKey(key: String?, context: Context): Int {
//        var selectedValue = 0
//        val prefs = context.getSharedPreferences(context.packageName, Context.MODE_PRIVATE)
//        selectedValue = prefs.getInt(key, 0)
//        return selectedValue
//    }
//
//    fun setIntToSharedPrefsForKey(key: String?, value: Int, context: Context): Boolean {
//        var savedSuccessfully = false
//        val prefs = context.getSharedPreferences(context.packageName, Context.MODE_PRIVATE)
//        val editor = prefs.edit()
//        savedSuccessfully = try {
//            editor.putInt(key, value)
//            editor.apply()
//            true
//        } catch (e: Exception) {
//            false
//        }
//        return savedSuccessfully
//    }
//
//    fun getStringFromSharedPrefsForKey(key: String?, context: Context): String? {
//        var selectedValue:String? = ""
//        val prefs = context.getSharedPreferences(context.packageName, Context.MODE_PRIVATE)
//        selectedValue = prefs.getString(key, "")
//        return selectedValue
//    }
//
//    fun setStringToSharedPrefsForKey(key: String?, value: String?, context: Context): Boolean {
//        var savedSuccessfully = false
//        val prefs = context.getSharedPreferences(context.packageName, Context.MODE_PRIVATE)
//        val editor = prefs.edit()
//        savedSuccessfully = try {
//            editor.putString(key, value)
//            editor.apply()
//            true
//        } catch (e: Exception) {
//            false
//        }
//        return savedSuccessfully
//    }
//}