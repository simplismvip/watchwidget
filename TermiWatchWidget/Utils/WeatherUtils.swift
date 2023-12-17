//
//  WeatherUtils.swift
//  TermiWatch
//
//  Created by Qianlishun on 2023/10/10.
//  Copyright © 2023 Librecz Gábor. All rights reserved.
//
import Foundation
import WeatherKit
import CoreLocation

// 获取天气
func getWeather(location: CLLocation, afterHours: Int) async throws -> WeatherInfo {
    let weatherService = WeatherService()
    var result = WeatherInfo()
    do {
        let formatter = MeasurementFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0
        
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .hour, value: afterHours, to: Date.now)

        let weather = try await weatherService.weather(for: location,including: .current, .hourly(startDate: Date.now, endDate: endDate!), .alerts)
                
        let current = WeatherInfo.QWeather(currentWeather: weather.0, tempMF: formatter )

        var afters = [WeatherInfo.QWeather]()
        for i in 0..<afterHours {
            let after = WeatherInfo.QWeather(hourWeather: weather.1.forecast[i], tempMF: formatter )
            afters.append(after)
        }
        
        var alerts = [String]()
        for i in 0..<afterHours {
            let alert = weather.2?[i].summary ?? ""
            alerts.append(alert)
        }
        
        result = WeatherInfo(current: current, weathers: afters, alerts: alerts)
    } catch {
        print("WatchWeatherCall error: \(error.localizedDescription)")
    }
        
    return result
}

// 请求位置
class WidgetLocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    private var handler: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.locationManager!.delegate = self
            if self.locationManager!.authorizationStatus == .notDetermined {
                self.locationManager!.requestWhenInUseAuthorization()
            }
        }
    }
    
    func fetchLocation(handler: @escaping (CLLocation) -> Void) {
        self.handler = handler
        self.locationManager?.requestLocation()
        print("requestLocation")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        self.handler!(locations.last!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
