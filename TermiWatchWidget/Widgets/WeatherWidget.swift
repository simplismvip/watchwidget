//
//  WeatherWidget.swift
//  TermiWatchWidgetExtension
//
//  Created by JunMing on 2023/12/7.
//

import SwiftUI
import WidgetKit

struct WeatherProvider: TimelineProvider {
    var widgetLocationManager = WidgetLocationManager()
    
    func placeholder(in context: Context) -> WeatherEntry {
        return WeatherEntry(weather: WeatherViewInfo(current: WeatherInfo.QWeather(date: Date(), condition: "局部小雨", symbol: "cloud.rain", temperature: "20℃"), after1Hours: WeatherInfo.QWeather(date: Date()+3600,condition: "局部大雪", symbol: "snow", temperature: "-5℃"),alert: ""))
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        let entry = WeatherEntry(weather: WeatherViewInfo(current: WeatherInfo.QWeather(date: Date(), condition: "局部小雨", symbol: "cloud.rain", temperature: "20℃"), after1Hours: WeatherInfo.QWeather(date: Date()+3600,condition: "局部大雪", symbol: "snow", temperature: "-5℃"),alert: ""))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> ()) {
        widgetLocationManager.fetchLocation(handler: { location in
            Task {
                var currentDate = Date()
                let oneHour: TimeInterval = 30*60
                let weather = try await getWeather(location: location, afterHours: 3)
                var entries = [WeatherEntry]()
                for i in 0..<2 {
                    let info = WeatherViewInfo(current: weather.weathers[i], after1Hours: weather.weathers[i+1],alert: weather.alerts[0])
                    
                    let entry = WeatherEntry(date: currentDate, weather: info)
                    entries.append(entry)
                    currentDate += oneHour
                }

                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
            WidgetCenter.shared.reloadTimelines(ofKind: "HealthWidget")
        })
    }
}

struct WeatherWidgetEntryView : View {
    var entry: WeatherEntry
    @Environment(\.widgetFamily) var family
    let font = Font.system(size: 13)
    
    var body: some View {
        switch family {
        case .accessoryRectangular:
            VStack(alignment: .leading) {
                HStack {
                    MyText("user@\(terminalName):~ $ now")
                }.frame(height: 10)
                
                HStack {
                    MyText("[ALER.]")
                    Image(systemName: "exclamationmark.triangle").frame(width: 16).imageScale(.small).foregroundStyle(colorAlert1).minimumScaleFactor(0.8)
                    Text(entry.weather.alert).font(font).foregroundStyle(colorAlert1)
                }.frame(height: 10)
                
                HStack {
                    MyText("[TEMP]")
                    let temp = entry.weather.current.temperature
                    let temp2 = entry.weather.current.temperature
                    HStack(spacing: 0){
                        MyText(temp.value)
                        MyText(temp.unit)
                    }.foregroundColor(colorTemp1)
                    MyText("→")
                    HStack(spacing: 0){
                        MyText(temp2.value)
                        MyText(temp2.unit)
                    }.foregroundColor(colorTemp2)
                }.frame(height: 10)
                
                HStack {
                    MyText("[CuRR]")
                    Image(systemName: entry.weather.current.symbol).frame(width: 15).imageScale(.small)
                    Text(entry.weather.current.condition).font(font).frame( maxWidth: .infinity,alignment: .leading).foregroundColor(colorCurr).minimumScaleFactor(0.8)
                }.frame(height: 10)

                HStack {
                    MyText("[NEXT]")
                    Image(systemName: entry.weather.after1Hours.symbol).frame(width: 15).imageScale(.small)
                    Text(entry.weather.after1Hours.condition).font(font).frame( maxWidth: .infinity,alignment: .leading).foregroundColor(colorNext).minimumScaleFactor(0.8)
                }.frame(height: 10)

            }
        default:
            VStack { }
        }
    }
}

struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeatherProvider()) { entry in
            WeatherWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Weather")
        .supportedFamilies([.accessoryRectangular])
    }
}

//#Preview {
//    WeatherWidget()
//}
