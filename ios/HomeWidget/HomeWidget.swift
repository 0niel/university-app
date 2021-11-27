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
    var weekDay: Int{
        return Calendar.current.component(.weekday, from: self);
    }
    var year: Int{
        return Calendar.current.component(.year, from: self);
    }
    var month: Int{
        return Calendar.current.component(.month, from: self);
    }
    var day: Int{
        return Calendar.current.component(.day, from: self);
    }
    var hour: Int{
        return Calendar.current.component(.hour, from: self);
    }
    var min: Int{
        return Calendar.current.component(.minute, from: self);
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
        let entry = getEntry()
        completion(entry)
    }
    
    
    /// The date of update is every next class start
    func getDateOfNextUpdate()->Date{
        return Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        let now = Date();
        let dates:Array<Date> = [
            makeDate(now: now, hr: 9, min: 0),
            makeDate(now: now, hr: 10, min: 40),
            makeDate(now: now, hr: 12, min: 40),
            makeDate(now: now, hr: 14, min: 20),
            makeDate(now: now, hr: 16, min: 20),
            makeDate(now: now, hr: 18, min: 00),
        ];
        
        for date in dates{
            if (now.distance(to: date) > 0){
                return date;
            }
        }
        
        // if lessons finished, update at midnight
        let wangan = Calendar.current.startOfDay(for: now)
        let midnight = Calendar.current.date(byAdding: .day, value: 1, to: wangan)!
        
        return midnight;
    }
    
    func getFlutterData(sharedDefaults: UserDefaults?)->ScheduleModel?{
        let sharedDefaults = UserDefaults.init(suiteName: widgetGroupId)
        var flutterData: ScheduleModel? = nil
        if(sharedDefaults != nil) {
            do {
                let schedule = sharedDefaults?.string(forKey: "schedule")
//                let daysStuff = sharedDefaults?.string(forKey: "daysStuff")
                let decoder = JSONDecoder()
                if(schedule != nil){
                    flutterData = try decoder.decode(ScheduleModel.self, from: schedule!.data(using: .utf8)!)
                    //                    dump (flutterData)
                }
                
            } catch {
                print(error)
            }
        }
        
        return flutterData;
    }
    
    func getWeek(sharedDefaults: UserDefaults?, date:Date)->Int{
        var week: Int = -1;
        //        var msg:String? =  nil
        //        print("sharedDefaults == nil", sharedDefaults == nil)
        if(sharedDefaults != nil) {
            do {
//                let schedule = sharedDefaults?.string(forKey: "schedule")
                let daysStuff = sharedDefaults?.string(forKey: "daysStuff")
                let decoder = JSONDecoder()
                
                
                if (daysStuff != nil){
                    let weeks = try decoder.decode(Dictionary<String, Int>.self, from: daysStuff!.data(using: .utf8)!)
                    week = weeks[String(date.dayOfYear)]!;
                }
                
            } catch {
                print(error)
            }
        }
        return week;
    }
    
    func getEntry()->ExampleEntry{
        var date = Date();
        
        let sharedDefaults = UserDefaults.init(suiteName: widgetGroupId)
        
        var flutterData: ScheduleModel? = getFlutterData(sharedDefaults: sharedDefaults);
        if (flutterData == nil){
            flutterData = ScheduleModel()
        }
        
        var week: Int = getWeek(sharedDefaults: sharedDefaults, date: date);
        
        let weekday = date.weekDay;
        // Если воскресение, то дату и номер недели отматываем назад
        if (weekday == 1){
            date = Date.yesterday
            week -= 1
        }
        
        let entry = ExampleEntry(date: date, data: flutterData!, week: week)
        return entry;
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ExampleEntry] = []
        
        let entry = getEntry()
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .after(getDateOfNextUpdate()));
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
            Text("Ninja widget").bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(Color.white)
            Text("Тут будет расписание")
                .font(.body)
                .foregroundColor(Color.white)
//                .widgetURL(URL(string: "homeWidgetExample://message?message=\(entry.data.group)&homeWidget"))
        }
        ).frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(darkbg)
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
        VStack{
            getHeader()
        }
    }
    
    func getTimeSlot(){
        let now = entry.date
        if (now.compare(makeDate(now: now, hr: 9, min: 0)).rawValue > 0){
            
        }
    }
    
    
    func getStartTimeForLesson(i:Int)->String{
        switch i {
        case 0:
            return "9:00"
        case 1:
            return  "10:40"
        case 2:
            return  "12:40"
        case 3:
            return  "14:20"
        case 4:
            return  "16:20"
        case 5:
            return   "18:00"
        default:
            return   "error"
        }
    }
    func getFinishTimeForLesson(i:Int)->String{
        switch i {
        case 0:
            return "10:30"
        case 1:
            return "12:10"
        case 2:
            return "14:10"
        case 3:
            return  "15:50"
        case 4:
            return "17:50"
        case 5:
            return "19:30"
        default:
            return   "error"
        }
    }
    
    func noLesson(i:Int) -> some View{
        let num = String(i+1)+" ";
        return ZStack(alignment:.leading){
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(midbg)
            HStack{
                Text(num).font(font12sb).foregroundColor(deactivefg).padding(Edge.Set.leading, 10)
                VStack{
                    Text(getStartTimeForLesson(i:i)).font(font12sb).foregroundColor(deactivefg)
                    Text(getFinishTimeForLesson(i:i)).font(font12sb).foregroundColor(deactivefg)
                }
                Text(" Нет пары").font(font14sb).foregroundColor(Color.white)
            }
            
        }.padding(Edge.Set.horizontal,5)
    }
    
    func lessonCard(lesson:LessonInfo, i:Int) -> some View{
        //        let text_time = lesson.time_start+"-"+lesson.time_end;
        var text_lesson = " "+lesson.name;
        let num = String(i+1)+" ";
        //        print(text_lesson, text_lesson.count);
        
        if (lesson.name.count > 22){
            text_lesson = " "+lesson.name.prefix(19)+"..."
        }
        
        let room_text = ", "+lesson.rooms[0]
        return ZStack(alignment:.leading){
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(midbg)
            HStack{
                Text(num).font(font12sb).foregroundColor(deactivefg).padding(Edge.Set.leading, 10)
                VStack{
                    Text(lesson.time_start).font(font12sb).foregroundColor(deactivefg)
                    Text(lesson.time_end).font(font12sb).foregroundColor(deactivefg)
                }
                Text(text_lesson+room_text).font(font14sb).foregroundColor(Color.white)
            }
            
        }.padding(Edge.Set.horizontal,5)
    }
    
    func getLessonInfoForTimeSlot(lessonInfos: Array<LessonInfo>) -> LessonInfo?{
        for info in lessonInfos{
            if (info.weeks.contains(entry.week)){
                return info;
            }
        }
        return nil;
    }
    
    //    func getScheduleForRightDay(){
    //        var weekday = Calendar.current.component(.weekday, from: entry.date)-1
    //        if (weekday == 1){
    //            weekday = 7;
    //        }
    //        let today = entry.data.schedule[String(weekday)]!
    //    }
    
    func getCurrentDaySchedule() -> ScheduleWeekdayValue{
        var weekday = Calendar.current.component(.weekday, from: entry.date)-1
        if (weekday == 0){
            weekday = 6;
        }
        return entry.data.schedule[String(weekday)]!
    }
    
    //    func needHighLight
    
    func getDateStr()->String{
        let dateFormatter = DateFormatter()
        
        // Set Date Format
        dateFormatter.dateFormat = "dd.MM.YY"
        
        // Convert Date to String
        let str_date = dateFormatter.string(from: entry.date)
        return str_date;
    }
    

    
    //    func mLabel(text:String, size:CGFloat)-> UILabel{
    //        let lbl = UILabel();
    //        lbl.text = text;
    //        lbl.font = UIFont.systemFont(ofSize: size)
    //        lbl.textColor = UIColor.white
    //        return lbl;
    //    }
    
    func getHeader()-> some View{
        let header = "Группа: "+entry.data.group+" | Неделя: "+String(entry.week)
        return ZStack{
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(midbg).frame(height:30)//.padding(Edge.Set.top, 4)
        Text(header).font(font14).foregroundColor(Color.white)//.padding(Edge.Set.top, 5)
        }.padding(Edge.Set.horizontal, 10).padding(Edge.Set.top, 5)
    }
    
    func getBig()-> some View{
        let today = getCurrentDaySchedule();
        var weekday = Calendar.current.component(.weekday, from: entry.date)-1
//        let str_date = getDateStr();
        
        return VStack(alignment: .center){
//            Text(getDateStr()+String(weekday)).foregroundColor(Color.white)
            getHeader()
            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                ForEach(
                    0..<today.lessons.count
                    //                            id: \.self
                ) { i in
                    //                    let lesson: LessonInfo? = getLessonInfoForTimeSlot(lessonInfos: today.lessons[0]);
                    //                    lessonCard(lesson: lesson!, i: i)
                    if (today.lessons[i].isEmpty){
                        noLesson(i: i)
                    }else{
                        let lesson: LessonInfo? = getLessonInfoForTimeSlot(lessonInfos: today.lessons[i]);
                        if (lesson == nil){
                            noLesson(i: i)
                        }else{
                            lessonCard(lesson: lesson!, i: i)
                        }
                    }
                    
                }.padding(Edge.Set.bottom, 5)
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .background(darkbg)
            
        }
    }
        
        
        @Environment(\.widgetFamily) var family
        
        var body: some View {
            if (entry.data.schedule.isEmpty || entry.week == -1){
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
                HomeWidgetExampleEntryView(entry: entry).background(darkbg)
            }
            .configurationDisplayName("Ninja Widget")
            .description("Это виджет расписания на день")
            .supportedFamilies([.systemLarge])
        }
    }
    
//    struct HomeWidget_Previews: PreviewProvider {
//        static var previews: some View {
//            HomeWidgetExampleEntryView(entry: ExampleEntry(date: Date(), data: ScheduleModel(), week: 1))
//                .previewContext(WidgetPreviewContext(family: .systemSmall))
//        }
//    }

func makeDate(now:Date, hr: Int, min: Int) -> Date {
    let calendar = Calendar(identifier: .gregorian)
    let components = DateComponents(year: now.year, month: now.month, day: now.day, hour: hr, minute: min, second: 0);
    return calendar.date(from: components)!
}

let darkbg: Color = Color(red: 24/255, green: 26/255, blue: 32/255, opacity: 1)
let midbg: Color = Color(red: 31/255, green:34/255, blue: 42/255, opacity: 1)

let deactivefg: Color = Color(red: 94/255, green:98/255, blue: 114/255, opacity: 1)

let whiteFont: UIFont = UIFont.systemFont(ofSize: 12)
let font12: Font = Font.system(size: 12).weight(Font.Weight.regular)
let font12sb: Font = Font.system(size: 12).weight(Font.Weight.semibold)
let font14: Font = Font.system(size: 14).weight(Font.Weight.regular)
let font14sb: Font = Font.system(size: 14).weight(Font.Weight.semibold)
let font16sb: Font = Font.system(size: 16).weight(Font.Weight.semibold)
