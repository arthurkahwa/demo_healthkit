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
}
