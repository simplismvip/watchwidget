//
//  ChristmasWidget.swift
//  TermiWatchWidgetExtension
//
//  Created by JunMing on 2023/12/17.
//

import SwiftUI
import WidgetKit

struct ChristmasProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> ChristmasEntry {
        return ChristmasEntry()
    }

    func getSnapshot(in context: Context, completion: @escaping (ChristmasEntry) -> ()) {
        let entry = ChristmasEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ChristmasEntry>) -> ()) {
        let timeline = Timeline(entries: [ChristmasEntry()], policy: .atEnd)
        completion(timeline)
    }
}

struct ChristmasView: View {
    var entry: ChristmasEntry
    @Environment(\.widgetFamily) var family
    @Environment(\.widgetRenderingMode) var widgetRenderingMode 
    let font = Font.system(size: 13)
    
    var body: some View {
        switch family {
        case .accessoryRectangular:
            HStack {
                Image("chrimas-tree")
                        .widgetAccentable()
                Spacer()
                VStack {
                    Image(systemName: "figure.walk")
                        .font(.body)
                        .foregroundStyle(.cyan)
                    Text("36ms")
                        .font(.body.weight(.medium))
                        .foregroundStyle(.cyan)
                }
            }
        default:
            VStack { }
        }
    }
}


struct ChristmasWidget: Widget {
    let kind: String = "ChristmasWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ChristmasProvider()) { entry in
            ChristmasView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Christmas")
        .supportedFamilies([.accessoryRectangular])
    }
}


//enum {
//    case
//}
//

struct Modul: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "")
                Spacer()
                Text("36ms")
            }
            Image(systemName: "")
        }
    }
}

//#Preview {
//    ChristmasWidget()
//}
