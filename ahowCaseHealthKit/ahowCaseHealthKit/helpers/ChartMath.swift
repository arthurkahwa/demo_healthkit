//
//  ChartMath.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/20/24.
//

import Foundation
import Algorithms

struct ChartMath {
    static func averageWeekdayCount(for metric: [HealthMetric]) -> [WeekDayChartData] {
        let sortedByWeekDay = metric.sorted { $0.date.weekDayInt < $1.date.weekDayInt }
        
        let weekdayArray = sortedByWeekDay.chunked { $0.date.weekDayInt == $1.date.weekDayInt }
        
        var weekDayChartData: [WeekDayChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            
            let total = array.reduce(0) { $0 + $1.value }
            let averageSteps = total/Double(array.count)
            
            weekDayChartData.append(.init(date: firstValue.date, value: averageSteps))
        }
        
        return weekDayChartData
    }
}
