//
//  EnergyObserver.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import HealthKit


// MARK: - HealthObserver
class HealthObserver {
    /// - Tag: Health Store
    let healthStore: HKHealthStore
    
    init() {
        self.healthStore = HKHealthStore()
    }
    
    func fetchSample(quantityType: HKQuantityType, unit: HKUnit, completion: @escaping (Int) -> ()) {
        let predicate = HKQuery.predicateForSamples(
          withStart: .distantPast,
          end: Date(),
          options: .strictEndDate
        )

        let sortDescriptors: [NSSortDescriptor]? = [NSSortDescriptor(
          key: HKSampleSortIdentifierStartDate,
          ascending: false
        )]
        
        let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: 1, sortDescriptors: sortDescriptors) {
            (query, results, error) in
            if error != nil {
                print(error.debugDescription)
                   // 处理错误
            } else if let results = results {
                if let quantitySample = results.first as? HKQuantitySample {
                    let value = quantitySample.quantity.doubleValue(for: unit)
                    print("\(quantityType.identifier),\(quantityType.description), \(value) \(unit.unitString)")
                    completion(Int(value))
                }
            }
        }
        healthStore.execute(query)
    }
    
    func fetchActivitySummary( completion: @escaping (HKActivitySummary) -> ()){
        let predicate = HKQuery.predicateForActivitySummary(
            with: DateComponents(components: [.year, .month, .day], date: Date())
        )
        
        let query = HKActivitySummaryQuery(predicate: predicate) { query, results, error in
            if error != nil {
                // 处理错误
            } else if let results = results {
                completion(results.first ?? HKActivitySummary())
            }
        }
        healthStore.execute(query)
    }
    
    func subscribeToActivitySummary(sampleType: HKSampleType,completion: @escaping (_ summary: HKActivitySummary) -> Void){
        let query = HKObserverQuery(
            sampleType: sampleType,
            predicate: nil
        ) { _, _, error in
            guard error == nil else { return }
            self.fetchActivitySummary { summary in
                completion(summary)
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchStatistics(
        quantityType: HKQuantityType,
        options: HKStatisticsOptions,
        startDate: Date,
        endDate: Date,
        interval: DateComponents,
        completion: @escaping (HKStatistics) -> () ) {
            let query = HKStatisticsCollectionQuery(
                quantityType: quantityType,
                quantitySamplePredicate: nil,
                options: options,
                anchorDate: startDate,
                intervalComponents: interval
            )
            
            query.initialResultsHandler = { query, collection, error in
                guard let statsCollection = collection else { return }
                statsCollection.enumerateStatistics(from: startDate, to: endDate) { stats, stop in
                    completion(stats)
                }
            }
            healthStore.execute(query)
        }
    
    func subscribeToStatisticsForToday(forQuantityType quantityType: HKQuantityType, unit: HKUnit, options: HKStatisticsOptions,healthStore: HKHealthStore = .init(), completion: @escaping (Int) -> Void) {
          let query = HKObserverQuery(sampleType: quantityType, predicate: nil) { _, _, error in
              guard error == nil else { return }
              self.fetchStatistics(quantityType: quantityType, options: options, startDate: Calendar.current.startOfDay(for: Date()) , endDate: Date(), interval: DateComponents(day: 1)) { stats in
                  let value = stats.sumQuantity()?.doubleValue(for: unit) ?? 0
                  completion(Int(value))
              }
          }

          healthStore.execute(query)
    }
}

// MARK: - HealthObserver extension : Keep
extension HealthObserver {
    
    func getHealthInfo() async  -> HealthInfo {
       
        let steps = await getCurrentSteps()
        
        let excercise = await getActiveEnergyBurned()
        let excerciseTime = await getExerciseTime()
        let standHours = await getStandHours()
        
        let heartRate = await getHeartRate()

        let health = HealthInfo(steps: steps, excercise: excercise, excerciseTime: excerciseTime, standHours: standHours, heartRate: heartRate)
        
        return health
    }
    
    func getCurrentSteps()async -> Int {
        await withCheckedContinuation({ continuation in
            getCurrentSteps() { value in
                continuation.resume(returning: value)
            }
        })
    }
    
    func getActiveEnergyBurned()async -> Int {
        await withCheckedContinuation({ continuation in
            getActiveEnergyBurned() { value in
                continuation.resume(returning: value)
            }
        })
    }
    
    func getExerciseTime()async -> Int {
        await withCheckedContinuation({ continuation in
            getExerciseTime() { value in
                continuation.resume(returning: value)
            }
        })
    }
    
    func getStandHours()async -> Int {
        await withCheckedContinuation({ continuation in
            getStandHours() { value in
                continuation.resume(returning: value)
            }
        })
    }
    
    func getHeartRate()async -> Int {
        await withCheckedContinuation({ continuation in
            getHeartRate() { value in
                continuation.resume(returning: value)
            }
        })
    }
    
    func getCurrentSteps(completion: @escaping (Int) -> ()) {
        let type: HKQuantityType = HKQuantityType(HKQuantityTypeIdentifier.stepCount)
        
        subscribeToStatisticsForToday(forQuantityType: type, unit: HKUnit.count(), options: .cumulativeSum, completion: completion)
        
    }
    
    func getActiveEnergyBurned(compltion: @escaping(Int) -> ()){
        subscribeToActivitySummary(sampleType: HKQuantityType(HKQuantityTypeIdentifier.activeEnergyBurned)) { summary in
            
            let excerciseValue = summary.activeEnergyBurned.doubleValue(
              for: HKUnit.kilocalorie()
            )
            compltion(Int(excerciseValue))
        }
    }
    
    func getExerciseTime(compltion: @escaping(Int) -> ()){
        subscribeToActivitySummary(sampleType: HKQuantityType(HKQuantityTypeIdentifier.appleExerciseTime)) { summary in
            
            let time = summary.appleExerciseTime.doubleValue(
              for: HKUnit.minute()
            )
            compltion(Int(time))
        }
    }
    
    func getStandHours(compltion: @escaping(Int) -> ()){
        subscribeToActivitySummary(sampleType:HKCategoryType(.appleStandHour)) { summary in
            
            let stamd = summary.appleStandHours.doubleValue(
              for: HKUnit.count()
            )
            compltion(Int(stamd))
        }
    }

    func getHeartRate(compltion: @escaping(Int) -> ()){
        fetchSample(quantityType: HKQuantityType(.heartRate), unit: HKUnit(from: "count/min"), completion: compltion)
    }

}

extension DateComponents {
  init(
    calendar: Calendar = .autoupdatingCurrent,
    components: Set<Calendar.Component>,
    date: Date
  ) {
    self = calendar.dateComponents(components, from: date)
    self.calendar = calendar
  }
}
