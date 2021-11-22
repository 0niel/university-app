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

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ExampleEntry {
        ExampleEntry(date: Date(), title: "Placeholder Title", message: "Placeholder Message")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ExampleEntry) -> ()) {
        let data = UserDefaults.init(suiteName:widgetGroupId)
        let entry = ExampleEntry(date: Date(), title: data?.string(forKey: "title") ?? "No Title 1", message: data?.string(forKey: "message") ?? "No Message 1")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct ExampleEntry: TimelineEntry {
    let date: Date
    let title: String
    let message: String
}

struct HomeWidgetExampleEntryView : View {
    var entry: Provider.Entry
    let data = UserDefaults.init(suiteName:widgetGroupId)
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            VStack.init(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                Text("small").bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text(entry.message)
                    .font(.body)
                    .widgetURL(URL(string: "homeWidgetExample://message?message=\(entry.message)&homeWidget"))
                }
            )
        case .systemMedium:
            VStack.init(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                Text("medium").bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text(entry.message)
                    .font(.body)
                    .widgetURL(URL(string: "homeWidgetExample://message?message=\(entry.message)&homeWidget"))
                }
            )
        default:
            VStack.init(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                Text("large").bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text(entry.message)
                    .font(.body)
                    .widgetURL(URL(string: "homeWidgetExample://message?message=\(entry.message)&homeWidget"))
                }
            )
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
        .description("Это виджет для расписания на день")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct HomeWidget_Previews: PreviewProvider {
    static var previews: some View {
        HomeWidgetExampleEntryView(entry: ExampleEntry(date: Date(), title: "Example Title", message: "Example Message"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
