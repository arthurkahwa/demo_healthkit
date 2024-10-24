//
//  ChartHelper.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 10/2/24.
//

import Foundation
import Algorithms

struct ChartHelper {
    static func convert(data: [HealthMetric]) -> [DateValueChartData] {
        data.map { .init(date: $0.date, value: $0.value)}
    }
    
    static func parseSelectedData(from data: [DateValueChartData], in selectedDate: Date?) -> DateValueChartData? {
        guard let selectedDate else { return nil }
        
        return data.first {
            Calendar.current.isDate(selectedDate, inSameDayAs: $0.date)
        }
    }
    
    static func averageWeekdayCount(for metric: [HealthMetric]) -> [DateValueChartData] {
        let sortedByWeekDay = metric.sorted(using: KeyPathComparator(\.date.weekDayInt))
        let weekdayArray = sortedByWeekDay.chunked { $0.date.weekDayInt == $1.date.weekDayInt }
        
        var weekDayChartData: [DateValueChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            
            let total = array.reduce(0) { $0 + $1.value }
            let averageSteps = total/Double(array.count)
            
            weekDayChartData.append(.init(date: firstValue.date, value: averageSteps))
        }
        
        return weekDayChartData
    }
    
    static func averageDailyWeightDifferences(for weights: [HealthMetric]) -> [DateValueChartData] {
        guard (weights.count > 1) else { return [] }
        
        var diffValues: [(date: Date, value: Double)] = []
        
        for j in 1..<weights.count {
            let date = weights[j].date
            let diff = weights[j].value - weights[j - 1].value
            
            diffValues.append((date: date, value: diff))
        }
        
        let sortedByWeekDay = diffValues.sorted(using: KeyPathComparator(\.date.weekDayInt))
        let weekdayArray = sortedByWeekDay.chunked { $0.date.weekDayInt == $1.date.weekDayInt }
        
        var weekDayChartData: [DateValueChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            
            let total = array.reduce(0) { $0 + $1.value }
            let avereageWeightDiff = total/Double(array.count)
            
            weekDayChartData.append(.init(date: firstValue.date, value: avereageWeightDiff))
        }
        
        return weekDayChartData
    }
}
