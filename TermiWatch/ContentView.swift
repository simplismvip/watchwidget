//
//  ContentView.swift
//  TermiWatch
//
//  Created by JunMing on 2023/12/7.
//

import SwiftUI
import CoreLocation
import HealthKit

struct ContentView: View {
    
    let healthStore = HKHealthStore()
    let hkDataTypesOfInterest = Set([
        HKObjectType.activitySummaryType(),
        HKCategoryType.categoryType(forIdentifier: .appleStandHour)!,
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
    ])
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
            healthStore.requestAuthorization(toShare: nil, read: hkDataTypesOfInterest) { result,error in
                print(result.description + " \n " + (error?.localizedDescription ?? ""))
            }
        }
    }
}

#Preview {
    ContentView()
}
