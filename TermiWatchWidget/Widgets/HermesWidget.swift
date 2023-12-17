//
//  HermesWidget.swift
//  TermiWatchWidgetExtension
//
//  Created by JunMing on 2023/12/16.
//

import SwiftUI
import WidgetKit

struct HermesTopProvider: TimelineProvider {
    func placeholder(in context: Context) -> HermesEntry {
        HermesEntry(loc: .top("hermes-top-2"))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HermesEntry) -> Void) {
        completion(HermesEntry(loc: .top("hermes-top-2")))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HermesEntry>) -> Void) {
        var entries = [HermesEntry]()
        entries.append(HermesEntry(loc: .top("hermes-top-2")))
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct HermesLeftProvider: TimelineProvider {
    func placeholder(in context: Context) -> HermesEntry {
        HermesEntry(loc: .left("hermes-left-3"))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HermesEntry) -> Void) {
        completion(HermesEntry(loc: .left("hermes-left-3")))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HermesEntry>) -> Void) {
        var entries = [HermesEntry]()
        entries.append(HermesEntry(loc: .left("hermes-left-3")))
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct HermesBottomProvider: TimelineProvider {
    func placeholder(in context: Context) -> HermesEntry {
        HermesEntry(loc: .bottom("hermes-bottom-3"))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HermesEntry) -> Void) {
        completion(HermesEntry(loc: .bottom("hermes-bottom-3")))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HermesEntry>) -> Void) {
        var entries = [HermesEntry]()
        entries.append(HermesEntry(loc: .bottom("hermes-bottom-3")))
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct HermesRightProvider: TimelineProvider {
    func placeholder(in context: Context) -> HermesEntry {
        HermesEntry(loc: .right("hermes-right-3"))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HermesEntry) -> Void) {
        completion(HermesEntry(loc: .right("hermes-right-3")))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HermesEntry>) -> Void) {
        var entries = [HermesEntry]()
        entries.append(HermesEntry(loc: .right("hermes-right-3")))
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

/** Hermes */
enum Location {
    case top(String), bottom(String), left(String), right(String)
}

struct HermesEntry: TimelineEntry {
    var date = Date()
    let loc: Location
}

struct HermesWidgetEntryView: View {
    var entry: HermesEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            switch entry.loc {
            case .top(let name):
                Image(name)
            case .bottom(let name):
                Image(name)
            case .left(let name):
                Image(name)
            case .right(let name):
                Image(name)
            }
        default:
            Text("-")
        }
    }
}

/** Hermes */
struct HermesTopWidget: Widget {
    let kind: String = "HermesTopWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HermesTopProvider()) { entry in
            HermesWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Top")
        .supportedFamilies([.accessoryCircular])
    }
}

struct HermesBottomWidget: Widget {
    let kind: String = "HermesBottomWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HermesBottomProvider()) { entry in
            HermesWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Bottom")
        .supportedFamilies([.accessoryCircular])
    }
}


struct HermesLeftWidget: Widget {
    let kind: String = "HermesLeftWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HermesLeftProvider()) { entry in
            HermesWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Left")
        .supportedFamilies([.accessoryCircular])
    }
}

struct HermesRightWidget: Widget {
    let kind: String = "HermesRightWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HermesRightProvider()) { entry in
            HermesWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Right")
        .supportedFamilies([.accessoryCircular])
    }
}


//#Preview {
//    HermesWidgetEntryView()
//}
