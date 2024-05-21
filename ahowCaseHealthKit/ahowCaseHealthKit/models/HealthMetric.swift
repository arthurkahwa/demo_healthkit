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
    
    static var mockData: [HealthMetric] {
        var array: [HealthMetric] = []
        
        for j in 0..<28 {
            let metric = HealthMetric(date: Calendar.current.date(byAdding: .day, value: -j, to: .now)!,
                                      value: .random(in: 4000...16000))
            
            array.append(metric)
        }
        
        return array
    }
}
