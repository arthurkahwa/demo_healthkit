//
//  ChartHelper.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 10/2/24.
//

import Foundation

struct ChartHelper {
    static func convert(data: [HealthMetric]) -> [DateValueChartData] {
        data.map { .init(date: $0.date, value: $0.value)}
    }
    
    static func average(for data: [DateValueChartData]) -> Double {
        guard !data.isEmpty else { return 0 }
        
        let totalSteps = data.reduce(0) { $0 + $1.value }
        
        return totalSteps / Double(data.count)
    }
    
    static func parseSelectedData(from data: [DateValueChartData], in selectedDate: Date?) -> DateValueChartData? {
        guard let selectedDate else { return nil }
        
        return data.first {
            Calendar.current.isDate(selectedDate, inSameDayAs: $0.date)
        }
    }
}
