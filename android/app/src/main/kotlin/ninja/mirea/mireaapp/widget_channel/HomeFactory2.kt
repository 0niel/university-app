package ninja.mirea.mireaapp.widget_channel

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import kotlinx.serialization.json.Json
import ninja.mirea.mireaapp.R
import java.util.*

class HomeFactory2 internal constructor(val context: Context, val intent: Intent) :
    RemoteViewsService.RemoteViewsFactory {
    var data: ArrayList<Lesson> = ArrayList()

    override fun onCreate() {}

    override fun getCount(): Int {
        return data.size
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun getLoadingView(): RemoteViews {
        return RemoteViews(context.packageName, R.layout.timetable_item)
    }

    private  val maxLen = 50;
    override fun getViewAt(position: Int): RemoteViews {
        val rView = RemoteViews(
            context.packageName,
            R.layout.timetable_item
        )
        if (data[position].name.isNotEmpty()) {
            var main = data[position].name
            if (main.length > maxLen)
                main = main.substring(0, maxLen-3) + "..."
            if (data[position].rooms.isNotEmpty()) {
                main += if (main.length >= maxLen)
                    " " + data[position].rooms[0]
                else
                    ", " + data[position].rooms[0]
            }
            rView.setTextViewText(R.id.ti_main_text, main)
            rView.setTextViewText(R.id.ti_item, (position + 1).toString())
            rView.setTextViewText(R.id.ti_start_time, data[position].time_start)
            rView.setTextViewText(R.id.ti_finish_time, data[position].time_end)
        } else {
            rView.setTextViewText(R.id.ti_main_text, "Нет пары")
            rView.setTextViewText(R.id.ti_item, (position + 1).toString())
            rView.setTextViewText(R.id.ti_start_time, getStartTime(position))
            rView.setTextViewText(R.id.ti_finish_time, getFinishTime(position))
        }
        return rView
    }

    private fun getStartTime(position: Int): String {
        return when (position) {
            0 -> "9:00"
            1 -> "10:40"
            2 -> "12:40"
            3 -> "14:20"
            4 -> "16:20"
            5 -> "18:00"
            else -> "error"
        }
    }

    private fun getFinishTime(position: Int): String {
        return when (position) {
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
        data.clear()

        val scheduleData =
            intent.getStringExtra("schedule")
        val weekData = intent.getStringExtra("week")

//        print(scheduleData);
//        print(weekData);

        if (scheduleData != null &&
            scheduleData.isNotEmpty() &&
            weekData != null &&
            weekData.isNotEmpty() &&
            scheduleData!="null" &&
            weekData.matches("\\d+".toRegex())
        ) {
            val scheduleModel = Json.decodeFromString(ScheduleModel.serializer(), scheduleData)
            var week = weekData.toInt()

            val calendar: Calendar = Calendar.getInstance()
            var day: Int = calendar.get(Calendar.DAY_OF_WEEK) - 1
            if (day == 0) {
                day = 6
                week -= 1
            }

            for (timeslot in scheduleModel.schedule[day.toString()]!!.lessons) {
                var flag = false
                for (lesson in timeslot) {
                    if (lesson.weeks.contains(week)) {
                        data.add(lesson)
                        flag = true
                    }
                }
                if (!flag) {
                    data.add(Lesson("", listOf(), "", "", "", listOf(), listOf()))
                }
            }
            val b = 1 + 1
        }
    }

    override fun onDestroy() {}

}
