//
//  HealthKitManager.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/18/24.
//

import Foundation
import HealthKit

@Observable
class HealthKitManager {
    let store = HKHealthStore()
    
    var stepData: [HealthMetric] = []
    var weightData: [HealthMetric] = []
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
    
    func fetchStepCount() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -28, to: endDate)
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.stepCount), predicate: queryPredicate)
        let stepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate,
                                                               options: .cumulativeSum,
                                                               anchorDate: endDate,
                                                               intervalComponents: .init(day: 1))
        
        do {
            let stepCounts = try await stepsQuery.result(for: store)
            
            stepData = stepCounts.statistics().map {
                .init(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            }
        }
        catch {}
    }
    
    func fetchWeightData() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -28, to: endDate)
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.bodyMass), predicate: queryPredicate)
        let weightQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate,
                                                               options: .mostRecent,
                                                               anchorDate: endDate,
                                                               intervalComponents: .init(day: 1))
        
        do {
            let weights = try await weightQuery.result(for: store)
            
            weightData = weights.statistics().map {
                .init(date: $0.startDate, value: $0.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)
            }
        }
        catch {}
    }
    
//    func addSimulatorData() async {
//        var hkSamples: [HKQuantitySample] = []
//        
//        for j in 0..<28 {
//            let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4000...20000))
//            let weightQuantity = HKQuantity(unit: .pound(), doubleValue: .random(in: 160 + Double(j/3)...160 + Double(j/3)))
//            
//            let startDate = Calendar.current.date(byAdding: .day, value: -j, to: .now)!
//            let endDate = Calendar.current.date(byAdding: .second, value: 1, to: startDate)!
//            
//            let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: startDate, end: endDate)
//            let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass), quantity: weightQuantity, start: startDate, end: endDate)
//            
//            hkSamples.append(stepSample)
//            hkSamples.append(weightSample)
//        }
//        
//        try! await store.save(hkSamples)
//        
//        print("✅ Dummy data sent out")
//    }
}
