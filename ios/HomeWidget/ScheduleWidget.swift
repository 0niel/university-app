import WidgetKit
import SwiftUI
import Intents

struct ScheduleModel: Codable {
    let schedule: [ScheduleEntry]
    let group: String

    init() {
        schedule = []
        group = ""
    }

    struct ScheduleEntry: Codable, Identifiable {
        let id = UUID()
        let subject: String
        let lessonType: Int
        let classroom: String
        let startTime: String
        let endTime: String
        let dates: [String]

        enum CodingKeys: String, CodingKey {
            case subject, lessonType, classroom, startTime, endTime, dates
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            subject = try container.decode(String.self, forKey: .subject)
            lessonType = try container.decode(Int.self, forKey: .lessonType)
            classroom = try container.decode(String.self, forKey: .classroom)
            startTime = try container.decode(String.self, forKey: .startTime)
            endTime = try container.decode(String.self, forKey: .endTime)
            dates = try container.decode([String].self, forKey: .dates)
        }
    }
}

struct Provider: TimelineProvider {
    let widgetGroupId = "group.ninja.mirea.mireaapp"

    func placeholder(in context: Context) -> ScheduleTimelineEntry {
        ScheduleTimelineEntry(date: Date(), data: ScheduleModel())
    }

    func getSnapshot(in context: Context, completion: @escaping (ScheduleTimelineEntry) -> ()) {
        let entry = getEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleTimelineEntry>) -> ()) {
        let entry = getEntry()

        let nextUpdateDate = getNextUpdateDate()

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }

    func getNextUpdateDate() -> Date {
        let now = Date()
        let midnight = Calendar.current.startOfDay(for: now)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        return tomorrow
    }

    func getEntry() -> ScheduleTimelineEntry {
        let today = Date()
        let sharedDefaults = UserDefaults(suiteName: widgetGroupId)

        var scheduleModel = ScheduleModel()

        if let sharedDefaults = sharedDefaults,
           let scheduleJsonString = sharedDefaults.string(forKey: "schedule") {
            do {
                let decoder = JSONDecoder()
                scheduleModel = try decoder.decode(ScheduleModel.self, from: scheduleJsonString.data(using: .utf8)!)
            } catch {
                print("Error decoding schedule: \(error)")
            }
        }

        return ScheduleTimelineEntry(date: today, data: scheduleModel)
    }
}

struct ScheduleTimelineEntry: TimelineEntry {
    let date: Date
    let data: ScheduleModel
}

struct ScheduleWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    @Environment(\.colorScheme) var colorScheme

    var todayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: entry.date)
    }

    var tomorrowString: String {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: entry.date)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: tomorrow)
    }

    var todayLessons: [ScheduleModel.ScheduleEntry] {
        return entry.data.schedule.filter { lesson in
            lesson.dates.contains { date in
                date.starts(with: todayString)
            }
        }.sorted { $0.startTime < $1.startTime }
    }

    var tomorrowLessons: [ScheduleModel.ScheduleEntry] {
        return entry.data.schedule.filter { lesson in
            lesson.dates.contains { date in
                date.starts(with: tomorrowString)
            }
        }.sorted { $0.startTime < $1.startTime }
    }

    func isCurrentLesson(_ lesson: ScheduleModel.ScheduleEntry) -> Bool {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        guard let startTime = formatter.date(from: lesson.startTime),
              let endTime = formatter.date(from: lesson.endTime) else {
            return false
        }

        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        let nowComponents = calendar.dateComponents([.hour, .minute], from: now)

        let currentStartTime = calendar.date(bySettingHour: startComponents.hour!, minute: startComponents.minute!, second: 0, of: now)!
        let currentEndTime = calendar.date(bySettingHour: endComponents.hour!, minute: endComponents.minute!, second: 0, of: now)!

        return now >= currentStartTime && now <= currentEndTime
    }

    func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM"
        outputFormatter.locale = Locale(identifier: "ru_RU")

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString
    }

    func getLessonTypeColor(_ lessonType: Int) -> Color {
        switch lessonType {
        case 0: return Color(red: 160/255, green: 106/255, blue: 249/255) // Lecture
        case 1: return Color(red: 251/255, green: 163/255, blue: 255/255) // Lab
        case 2: return Color(red: 142/255, green: 150/255, blue: 255/255) // Practice
        case 3: return Color(red: 255/255, green: 171/255, blue: 145/255) // Individual
        case 4: return Color(red: 255/255, green: 245/255, blue: 157/255) // Exam
        case 5: return Color(red: 255/255, green: 171/255, blue: 145/255) // Credit
        case 6: return Color(red: 128/255, green: 203/255, blue: 196/255) // Consultation
        case 7: return Color(red: 165/255, green: 214/255, blue: 167/255) // Course work
        case 8: return Color(red: 165/255, green: 214/255, blue: 167/255) // Course project
        default: return Color(red: 160/255, green: 106/255, blue: 249/255)
        }
    }

    func getLessonTypeName(_ lessonType: Int) -> String {
        switch lessonType {
        case 0: return "Лекция"
        case 1: return "Лабораторная"
        case 2: return "Практика"
        case 3: return "Сам. работа"
        case 4: return "Экзамен"
        case 5: return "Зачет"
        case 6: return "Консультация"
        case 7: return "Курс. раб."
        case 8: return "Курс. проект"
        default: return "Неизвестно"
        }
    }

    var bgColor: Color {
        colorScheme == .dark ? Color(red: 18/255, green: 18/255, blue: 18/255) : Color.white
    }

    var cardBgColor: Color {
        colorScheme == .dark ? Color(red: 28/255, green: 28/255, blue: 28/255) : Color(red: 249/255, green: 249/255, blue: 249/255)
    }

    var headerBgColor: Color {
        Color(red: 74/255, green: 144/255, blue: 226/255)
    }

    var textColor: Color {
        colorScheme == .dark ? Color.white : Color(red: 51/255, green: 51/255, blue: 51/255)
    }

    var deactiveTextColor: Color {
        colorScheme == .dark ? Color(red: 170/255, green: 170/255, blue: 170/255) : Color(red: 94/255, green: 98/255, blue: 114/255)
    }

    var dividerColor: Color {
        colorScheme == .dark ? Color(red: 51/255, green: 51/255, blue: 51/255) : Color(red: 224/255, green: 224/255, blue: 224/255)
    }

    var body: some View {
        ZStack {
            bgColor

            if entry.data.schedule.isEmpty {
                VStack(spacing: 10) {
                    Text("Нет доступного расписания")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(deactiveTextColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else {
                VStack(spacing: 8) {
                    if !todayLessons.isEmpty {
                        header(title: "Сегодня, \(formatDate(todayString))")
                    } else if !tomorrowLessons.isEmpty {
                        header(title: "Завтра, \(formatDate(tomorrowString))")
                    } else {
                        header(title: "Расписание")
                    }

                    ScrollView {
                        VStack(spacing: 6) {
                            if !todayLessons.isEmpty {
                                ForEach(Array(todayLessons.prefix(4))) { lesson in
                                    lessonCard(lesson: lesson, isCurrent: isCurrentLesson(lesson))
                                }

                                if todayLessons.count > 4 {
                                    Text("Ещё \(todayLessons.count - 4) \(pluralize(count: todayLessons.count - 4))")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(red: 74/255, green: 144/255, blue: 226/255))
                                        .frame(maxWidth: .infinity)
                                        .padding(6)
                                        .background(cardBgColor)
                                        .cornerRadius(8)
                                }
                            } else if !tomorrowLessons.isEmpty {
                                ForEach(Array(tomorrowLessons.prefix(4))) { lesson in
                                    lessonCard(lesson: lesson, isCurrent: false)
                                }

                                if tomorrowLessons.count > 4 {
                                    Text("Ещё \(tomorrowLessons.count - 4) \(pluralize(count: tomorrowLessons.count - 4))")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(red: 74/255, green: 144/255, blue: 226/255))
                                        .frame(maxWidth: .infinity)
                                        .padding(6)
                                        .background(cardBgColor)
                                        .cornerRadius(8)
                                }
                            } else {
                                Text("Нет занятий на ближайшие дни")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(deactiveTextColor)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(cardBgColor)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.bottom, 12)
                    }
                }
            }
        }
    }

    func header(title: String) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(headerBgColor)
            .cornerRadius(8)
            .padding(.horizontal, 12)
            .padding(.top, 12)
    }

    func lessonCard(lesson: ScheduleModel.ScheduleEntry, isCurrent: Bool) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Rectangle()
                .fill(getLessonTypeColor(lesson.lessonType))
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(lesson.subject)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(textColor)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Label {
                        Text("\(lesson.startTime) - \(lesson.endTime)")
                            .font(.system(size: 12))
                            .foregroundColor(isCurrent ? getLessonTypeColor(lesson.lessonType) : deactiveTextColor)
                    } icon: {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                            .foregroundColor(isCurrent ? getLessonTypeColor(lesson.lessonType) : deactiveTextColor)
                    }

                    Label {
                        Text(getLessonTypeName(lesson.lessonType))
                            .font(.system(size: 12))
                            .foregroundColor(deactiveTextColor)
                    } icon: {
                        Image(systemName: "doc.text")
                            .font(.system(size: 10))
                            .foregroundColor(deactiveTextColor)
                    }
                }

                Label {
                    Text(lesson.classroom)
                        .font(.system(size: 12))
                        .foregroundColor(deactiveTextColor)
                        .lineLimit(1)
                } icon: {
                    Image(systemName: "mappin.circle")
                        .font(.system(size: 10))
                        .foregroundColor(deactiveTextColor)
                }
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBgColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isCurrent ? getLessonTypeColor(lesson.lessonType).opacity(0.3) : dividerColor, lineWidth: 1)
        )
    }

    func pluralize(count: Int) -> String {
        let mod10 = count % 10
        let mod100 = count % 100

        if mod10 == 1 && mod100 != 11 {
            return "пара"
        } else if (mod10 >= 2 && mod10 <= 4) && !(mod100 >= 12 && mod100 <= 14) {
            return "пары"
        } else {
            return "пар"
        }
    }
}

@main
struct ScheduleWidget: Widget {
    let kind: String = "ScheduleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ScheduleWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(entry.data.schedule.isEmpty ? Color.clear : Color(UIColor.systemBackground))
        }
        .configurationDisplayName("Расписание")
        .description("Отображает ближайшее расписание занятий")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct ScheduleWidget_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleWidgetEntryView(entry: ScheduleTimelineEntry(date: Date(), data: ScheduleModel()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
