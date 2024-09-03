//
//  ChartDataTypes.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/20/24.
//

import Foundation

struct WeekDayChartData: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let value: Double
}
