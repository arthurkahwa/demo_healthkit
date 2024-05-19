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
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
    
    func addSimulatorData() async {
        var hkSamples: [HKQuantitySample] = []
        
        for j in 0..<28 {
            let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4000...20000))
            let weightQuantity = HKQuantity(unit: .pound(), doubleValue: .random(in: 160 + Double(j/3)...160 + Double(j/3)))
            
            let startDate = Calendar.current.date(byAdding: .day, value: -j, to: .now)!
            let endDate = Calendar.current.date(byAdding: .second, value: 1, to: startDate)!
            
            let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: startDate, end: endDate)
            let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass), quantity: weightQuantity, start: startDate, end: endDate)
            
            hkSamples.append(stepSample)
            hkSamples.append(weightSample)
        }
        
        try! await store.save(hkSamples)
        
        print("✅ Dummy data sent out")
    }
}
