//
//  WeatherViewInfo.swift
//  TermiWatchWidgetExtension
//
//  Created by JunMing on 2023/12/7.
//

import SwiftUI
import WidgetKit
import WeatherKit

struct MyText: View {
    let font = Font.system(size: 13)
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text).font(font).frame(alignment: .leading)
    }
}

// TimeLineEntry
struct WeatherEntry: TimelineEntry {
    var date: Date = Date()
    let weather: WeatherViewInfo
}

struct WeatherViewInfo {
    let current: WeatherInfo.QWeather
    let after1Hours: WeatherInfo.QWeather
    let alert: String
    
    init(current: WeatherInfo.QWeather, after1Hours: WeatherInfo.QWeather, alert: String) {
        self.current = current
        self.after1Hours = after1Hours
        self.alert = alert
    }
    
    init() {
        self.init(current: WeatherInfo.QWeather(), after1Hours: WeatherInfo.QWeather(), alert: "" )
    }
}

struct WeatherInfo {
    let current: QWeather
    let weathers: [QWeather] // 0为当前
    let alerts: [String]
    
    init(current: QWeather, weathers: [QWeather], alerts: [String]) {
        self.current = current
        self.weathers = weathers
        self.alerts = alerts
    }
    
    init() {
        self.init(current: QWeather(), weathers: [QWeather()], alerts: [String()] )
    }
    
    struct QWeather {
        let date: Date
        let symbol: String
        let condition: String
        let temperature: QTemperature
        
        init(date: Date, condition: String, symbol: String, temperature: String) {
            self.date = date
            self.condition = condition
            self.symbol = symbol
            self.temperature = QTemperature(temperature)
        }
        
        init() {
            self.init(date: Date() , condition: "", symbol: "", temperature: "")
        }
        
        init(currentWeather: CurrentWeather, tempMF: MeasurementFormatter) {
            let condition = currentWeather.condition
            let symbol = currentWeather.symbolName
            let temperature = currentWeather.temperature
            let temp = tempMF.string(from: temperature)
            self.init(date: currentWeather.date, condition: condition.description, symbol: symbol, temperature: temp)
        }
        
        init(hourWeather: HourWeather, tempMF: MeasurementFormatter) {
            let condition = hourWeather.condition
            let symbol = hourWeather.symbolName
            let temperature = hourWeather.temperature
            let temp = tempMF.string(from: temperature)
            self.init(date: hourWeather.date, condition: condition.accessibilityDescription, symbol: symbol, temperature: temp)
        }
        
        struct QTemperature {
            let value: String
            let unit: String
            
            init(value: String, unit: String) {
                self.value = value
                self.unit = unit
            }
            
            init(_ str: String){
                if str.count == 0 {
                    self.init()
                } else {
                    let unitIndex = str.index(str.endIndex, offsetBy: -1)
                    let unit = String(str[unitIndex])
                    let temp = str.replacingOccurrences(of: unit, with: "")
                    self.init(value: temp, unit: unit)
                }
            }
            init() {
                self.init(value: "0", unit: "℃")
            }
        }
    }
}
