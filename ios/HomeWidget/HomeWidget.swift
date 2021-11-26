//
//  HomeWidget.swift
//  HomeWidget
//
//  Created by null on 20.11.2021.
//

import WidgetKit
import SwiftUI
import Intents

private let widgetGroupId = "group.com.MireaNinja.rtuMireaApp"

extension Date {
    var dayOfYear: Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: self)!
    }
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}

struct LessonInfo : Codable{
    let name:String ;
    let weeks: Array<Int> ;
    let time_start: String ;
    let time_end: String ;
    let types: String ;
    let teachers: Array<String> ;
    let rooms: Array<String>;
    
}

//struct TimeSlot:Codable{
//    let infos:[LessonInfo]
//}

struct ScheduleWeekdayValue: Codable{
    let lessons:[[LessonInfo]];
    
}

struct ScheduleModel: Codable {
    let schedule: [String:ScheduleWeekdayValue];
    let group:String;
    
    init() {
        schedule = [:];
        group = "IKBO-228-1337";
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ExampleEntry {
        ExampleEntry(date: Date(), data: ScheduleModel(), week: 1)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ExampleEntry) -> ()) {
        let data = UserDefaults.init(suiteName:widgetGroupId)
        let entry = ExampleEntry(date: Date(), data:ScheduleModel(), week: 1)
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ExampleEntry] = []
        var date = Date();
        var weekday = Calendar.current.component(.weekday, from: date)
        if (weekday == 1){
            date = Date.yesterday;
            weekday = 7;
        }
        let sharedDefaults = UserDefaults.init(suiteName: widgetGroupId)
        var flutterData: ScheduleModel? = nil
        var week: Int = -1;
        //        var msg:String? =  nil
        //        print("sharedDefaults == nil", sharedDefaults == nil)
        if(sharedDefaults != nil) {
            do {
                let schedule = sharedDefaults?.string(forKey: "schedule")
                let daysStuff = sharedDefaults?.string(forKey: "daysStuff")
                let decoder = JSONDecoder()
                
                if(schedule != nil){
                    
                    flutterData = try decoder.decode(ScheduleModel.self, from: schedule!.data(using: .utf8)!)
                    dump (flutterData)
                }
                
                if (daysStuff != nil){
                    let weeks = try decoder.decode(Dictionary<String, Int>.self, from: daysStuff!.data(using: .utf8)!)
                    week = weeks[String(date.dayOfYear)]!;
                }
                
            } catch {
                print(error)
            }
        }
        //        let msg2:String = msg != nil ? msg! : "dasdadsad"
        
        let a:ScheduleModel = flutterData == nil ? ScheduleModel() : flutterData!
        let entry = ExampleEntry(date: date, data: a, week: week)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ExampleEntry: TimelineEntry {
    let date: Date
    let data: ScheduleModel;
    let week: Int;
}

struct HomeWidgetExampleEntryView : View {
    var entry: Provider.Entry
    let data = UserDefaults.init(suiteName:widgetGroupId)
    
    let a = [UILabel()]
    
    func getEmpty() -> some View{
        return VStack.init(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content:{
            Text("Виджет расписания").bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Text("Пожалуйста, откройте приложение, чтобы автоматически обновить данные")
                .font(.body)
                .widgetURL(URL(string: "homeWidgetExample://message?message=\(entry.data.group)&homeWidget"))
        }
        )
    }
    
    func getSmall()-> some View{
        VStack.init(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content:{
            
            Text("small").bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
            Text(entry.data.group)
                .font(.body)
                .widgetURL(URL(string: "homeWidgetExample://message?message=\(entry.data.group)&homeWidget"))
        }
        )
    }
    
    func getMedium() -> some View{
        VStack.init(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text("medium").bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Text(entry.data.group)
                .font(.body)
                .widgetURL(URL(string: "homeWidgetExample://message?message=\(entry.data.group)&homeWidget"))
        }
        )
    }
    
    func lessonCard(lesson:LessonInfo) -> some View{
        let text_time = lesson.time_start+"-"+lesson.time_end;
        var text_lesson = " "+lesson.name;
        //        print(text_lesson, text_lesson.count);
        
        if (lesson.name.count > 20){
            text_lesson = " "+lesson.name.prefix(17)+"..."
        }
        
        let room_text = ", "+lesson.rooms[0]
        return HStack{
            Text(text_time+text_lesson+room_text)
        }
    }
    
    func getLessonInfoForTimeSlot(lessonInfos: Array<LessonInfo>) -> LessonInfo?{
        for info in lessonInfos{
            if (info.weeks.contains(entry.week)){
                return info;
            }
        }
        return nil;
    }
    
    func getScheduleForRightDay(){
        var weekday = Calendar.current.component(.weekday, from: entry.date)-1
        if (weekday == 1){
            weekday = 7;
        }
        let today = entry.data.schedule[String(weekday)]!
    }
    
    func getCurrentDaySchedule() -> ScheduleWeekdayValue{
        let weekday = Calendar.current.component(.weekday, from: entry.date)-1
        
        return entry.data.schedule[String(weekday)]!
    }
    
    func getDateStr()->String{
        let dateFormatter = DateFormatter()
        
        // Set Date Format
        dateFormatter.dateFormat = "dd.MM.YY"
        
        // Convert Date to String
        let str_date = dateFormatter.string(from: entry.date)
        return str_date;
    }
    
    func getBig()-> some View{
        let today = getCurrentDaySchedule();
        let str_date = getDateStr();
        
        return VStack(alignment: .leading){
            Text("Группа: "+entry.data.group).font(.title3)
            Text("Дата: "+str_date+" | Неделя: "+String(entry.week)).font(.title3)
//            Text(String(weekday)).font(.title3)
            VStack(
                alignment: .leading,
                spacing: 10
            ) {
                ForEach(
                    0..<today.lessons.count
                    //                            id: \.self
                ) { i in
                    if (today.lessons[i].isEmpty){
                        HStack{
                            Text("Нет пары")
                        }
                    }else{
                        let lesson: LessonInfo? = getLessonInfoForTimeSlot(lessonInfos: today.lessons[i]);
                        if (lesson == nil){
                            HStack{
                                Text("Нет пары")
                            }
                        }else{
                            lessonCard(lesson: lesson!)
                        }
                    }
                }
                
            }
        }
    }
    
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        if (entry.data.schedule.isEmpty){
            getEmpty();
        }else{
            
            
            switch family {
            case .systemSmall:
                getSmall();
            case .systemMedium:
                getMedium();
            default:
                getBig();
            }
        }
    }
}

@main
struct HomeWidget: Widget {
    let kind: String = "HomeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HomeWidgetExampleEntryView(entry: entry)
        }
        .configurationDisplayName("Timetable Widget")
        .description("Это виджет расписания на день")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct HomeWidget_Previews: PreviewProvider {
    static var previews: some View {
        HomeWidgetExampleEntryView(entry: ExampleEntry(date: Date(), data: ScheduleModel(), week: 1))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
