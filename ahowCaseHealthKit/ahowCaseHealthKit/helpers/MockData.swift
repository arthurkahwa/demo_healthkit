//
//  MockData.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/21/24.
//

import Foundation

struct MockData {
    static var steps: [HealthMetric] {
        var array: [HealthMetric] = []
        
        for j in 0..<28 {
            let metric = HealthMetric(date: Calendar.current.date(byAdding: .day, value: -j, to: .now)!,
                                      value: .random(in: 4000...16000))
            
            array.append(metric)
        }
        
        return array
    }
    
    static var weight: [HealthMetric] {
        var array: [HealthMetric] = []
        
        for j in 0..<28 {
            let metric = HealthMetric(date: Calendar.current.date(byAdding: .day, value: -j, to: .now)!,
                                      value: .random(in: 160 + Double(j/3)...160 + Double(j/3)))
            
            array.append(metric)
        }
        
        return array
    }
    
    static var weightDiffs: [DateValueChartData] {
        var array: [DateValueChartData] = []
        
        for j in 0..<7 {
            let diff = DateValueChartData(date: Calendar.current.date(byAdding: .day, value: -j, to: .now)!,
                                          value: .random(in: -3...3))
            
            array.append(diff)
        }
        
        return array
    }
}
