//
//  HealthWidget.swift
//  TermiWatchWidgetExtension
//
//  Created by JunMing on 2023/12/7.
//

import SwiftUI
import WidgetKit

struct HealthProvider: TimelineProvider {
    var healthObserver = HealthObserver()
    func placeholder(in context: Context) -> HealthEntry {
        return HealthEntry(health: HealthInfo(steps: 9999, excercise: 99, excerciseTime: 99, standHours: 99, heartRate: 60))
    }

    func getSnapshot(in context: Context, completion: @escaping (HealthEntry) -> ()) {
        let entry = HealthEntry(health: HealthInfo(steps: 9999, excercise: 99, excerciseTime: 99, standHours: 99, heartRate: 60))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<HealthEntry>) -> ()) {
        Task {
            let health = await healthObserver.getHealthInfo()
            let entry = HealthEntry( health: health )
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
        }
    }
}

struct HealthWidgetEntryView : View {
    var entry: HealthEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryRectangular:
            VStack(alignment: .leading) {
                HStack{
                    MyText("[KEEP]")
                    Image(systemName: "figure.run").imageScale(.small)
                    MyText("\(entry.health.excerciseTime)").foregroundStyle(colorKeep1)
                    Image(systemName: "figure.stand").imageScale(.small)
                    MyText("\(entry.health.standHours)").foregroundStyle(colorKeep2)
                    MyText("                               ")
                }.frame(height: 10)
                
                HStack {
                    MyText("[STEP]")
                    Image(systemName: "figure.walk").imageScale(.small)
                    MyText("\(entry.health.steps)").foregroundStyle(colorStep)
                }.frame(height: 10)
                
                HStack {
                    MyText("[KCAL]")
                    Image(systemName: "flame").imageScale(.small)
                    MyText("\(entry.health.excercise)").foregroundStyle(colorKcal)
                }.frame(height: 10)
                
                HStack {
                    MyText("[L_HR]")
                    Image(systemName: "heart.circle").imageScale(.small)
                    MyText("\(entry.health.heartRate)").foregroundStyle(colorHR)
                }.frame(height: 10)
                
                HStack {
                    MyText("user@\(terminalName):~ $ ")
                }.frame(height: 10.5)
            }
        default:
            VStack{}
        }
    }
}

struct HealthWidget: Widget {
    let kind: String = "HealthWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HealthProvider()) { entry in
            HealthWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Health")
        .supportedFamilies([.accessoryRectangular])
    }
}

//#Preview {
//    HealthWidget()
//}
