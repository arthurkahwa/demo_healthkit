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
    var weightDiffData: [HealthMetric] = []
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
    
    func fetchStepCount() async throws {
        guard store.authorizationStatus(for: HKQuantityType(.stepCount)) != .notDetermined
        else {
            throw StepTrackerError.authNotDetermined
        }
        
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
        catch HKError.errorNoData {
            throw StepTrackerError.noData
        }
        catch {
            throw StepTrackerError.unableToCompleteRequest
        }
    }
    
    func fetchWeightData() async throws {
        guard store.authorizationStatus(for: HKQuantityType(.bodyMass)) != .notDetermined
        else {
            throw StepTrackerError.authNotDetermined
        }
        
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
        catch HKError.errorNoData {
            throw StepTrackerError.noData
        }
        catch {
            throw StepTrackerError.unableToCompleteRequest
        }
    }
    
    func fetchWeightDataForDifferencials() async throws {
        guard store.authorizationStatus(for: HKQuantityType(.bodyMass)) != .notDetermined
        else {
            throw StepTrackerError.authNotDetermined
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)!
        let startDate = calendar.date(byAdding: .day, value: -29, to: endDate)
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.bodyMass), predicate: queryPredicate)
        let weightQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate,
                                                               options: .mostRecent,
                                                               anchorDate: endDate,
                                                               intervalComponents: .init(day: 1))
        
        do {
            let weights = try await weightQuery.result(for: store)
            
            weightDiffData = weights.statistics().map {
                .init(date: $0.startDate, value: $0.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)
            }
        }
        catch HKError.errorNoData {
            throw StepTrackerError.noData
        }
        catch {
            throw StepTrackerError.unableToCompleteRequest
        }
    }
    
    func addStepData(for date: Date, value: Double) async throws {
        let status = store.authorizationStatus(for: HKQuantityType(.stepCount))
        switch status {
        case .notDetermined:
            throw StepTrackerError.authNotDetermined
        case .sharingDenied:
            throw StepTrackerError.sharingDenied(quantityType: "Step Count")
        case .sharingAuthorized:
            break
        @unknown default:
            break
        }
        
        let stepQuantity = HKQuantity(unit: .count(), doubleValue: value)
        
        let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount),
                                          quantity: stepQuantity,
                                          start: date,
                                          end: date)
        
        do {
            try await store.save(stepSample)
        }
        catch {
            throw StepTrackerError.unableToCompleteRequest
        }
    }
    
    func addWeightData(for date: Date, value: Double) async throws {
        let status = store.authorizationStatus(for: HKQuantityType(.bodyMass))
        switch status {
        case .notDetermined:
            throw StepTrackerError.authNotDetermined
        case .sharingDenied:
            throw StepTrackerError.sharingDenied(quantityType: "Weight")
        case .sharingAuthorized:
            break
        @unknown default:
            break
        }
        
        let weightQuantity = HKQuantity(unit: .pound(), doubleValue: value)
        
        let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass),
                                          quantity: weightQuantity,
                                          start: date,
                                          end: date)
        
        do {
            try await store.save(weightSample)
        }
        catch {
            throw StepTrackerError.unableToCompleteRequest
        }
    }
    
    func addData(for date: Date, stepValue: Double) async {
        let stepQuantity = HKQuantity(unit: .count(), doubleValue: stepValue)
        let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: date, end: date)
        
        try! await store.save(stepSample)
    }
    
    func addData(for date: Date, weightValue: Double) async {
        let weightQuantity = HKQuantity(unit: .pound(), doubleValue: weightValue)
        let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass), quantity: weightQuantity, start: date, end: date)
        
        try! await store.save(weightSample)
    }
    
    func addSimulatorData() async {
        var hkSamples: [HKQuantitySample] = []
        
        for j in 0..<28 {
            let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4_000...20_000))
            let weightQuantity = HKQuantity(unit: .pound(), doubleValue: .random(in: 160 + Double(j/3)...164 + Double(j/4)))
            
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
