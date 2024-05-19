//
//  HealthMetric.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/19/24.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
