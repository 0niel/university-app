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

//@Serializable
//data class TimeSlot(val lessons:List<Lesson>){
//
//}

@Serializable
data class ScheduleWeekdayValue(val lessons: List<List<Lesson>>)

@Serializable
data class ScheduleModel(val schedule: Map<String, ScheduleWeekdayValue>, val group: String)

/*
/// Entity of lesson
struct LessonInfo : Codable{
    let name:String ;
    let weeks: Array<Int> ;
    let time_start: String ;
    let time_end: String ;
    let types: String ;
    let teachers: Array<String> ;
    let rooms: Array<String>;

}

/// Entity of possible lessons for every time slot for every day
struct ScheduleWeekdayValue: Codable{
    let lessons:[[LessonInfo]];

}

/// Storage of schedule data
struct ScheduleModel: Codable {
    let schedule: [String:ScheduleWeekdayValue];
    let group:String;

    init() {
        schedule = [:];
        group = "IKBO-228-1337"; // Lmao group name
    }
}
 */