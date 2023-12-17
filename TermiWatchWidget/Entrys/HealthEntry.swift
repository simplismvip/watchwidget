//
//  HealthEntry.swift
//  TermiWatchWidgetExtension
//
//  Created by JunMing on 2023/12/17.
//

import SwiftUI
import WidgetKit

struct HealthEntry: TimelineEntry {
    var date: Date = Date()
    let health: HealthInfo
}

struct HealthInfo {
    let steps: Int
    let excercise: Int
    let excerciseTime: Int
    let standHours: Int
    let heartRate: Int
    
    init(steps: Int, excercise: Int, excerciseTime: Int, standHours: Int, heartRate: Int) {
        self.steps = steps
        self.excercise = excercise
        self.excerciseTime = excerciseTime
        self.standHours = standHours
        self.heartRate = heartRate
    }
    
    init() {
        self.init(steps: 0, excercise: 0, excerciseTime: 0, standHours: 0, heartRate: 0)
    }
  
    func description() -> String {
        return "Steps:  \t\(steps)\n"
            +  "excercise:  \t\(excercise)\n"
            +  "excerciseTime:  \t\(excerciseTime)\n"
            +  "standHours:  \t\(standHours)\n"
            +  "heartRate:  \t\(heartRate)\n"
    }
}
