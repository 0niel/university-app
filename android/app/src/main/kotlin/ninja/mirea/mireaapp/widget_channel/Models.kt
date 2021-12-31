package ninja.mirea.mireaapp.widget_channel

import kotlinx.serialization.Serializable


@Serializable
data class Lesson(
    val name: String,
    val weeks: List<Int>,
    val time_start: String,
    val time_end: String,
    val types: String,
    val teachers: List<String>,
    val rooms: List<String>
)

@Serializable
data class ScheduleWeekdayValue(val lessons: List<List<Lesson>>)

@Serializable
data class ScheduleModel(val schedule: Map<String, ScheduleWeekdayValue>, val group: String)
