//
//  WeightDiffBarChart.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/28/24.
//

import SwiftUI
import Charts

struct WeightDiffBarChart: View {
    var chartData: [DateValueChartData]
    
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?
    
    var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedData(from: chartData, in: rawSelectedDate)
    }
    
    var body: some View {
        ChartContainer(chartType: .weightDiffBar) {
            Chart {
                if let selectedData {
                    RuleMark(x: .value("Selected Data", selectedData.date, unit: .day))
                        .foregroundStyle(Color.secondary.opacity(0.4))
                        .offset(y: -12)
                        .annotation(position: .top,
                                    spacing: 0,
                                    overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                            ChartAnnotationView(data: selectedData, context: .weight)
                        }
                }
                
                ForEach(chartData) { weightDiff in
                    Plot {
                        BarMark(x: .value("Date", weightDiff.date, unit: .day),
                                y: .value("Steps", weightDiff.value)
                        )
                        .foregroundStyle(weightDiff.value >= 0 ? Color.indigo.gradient : Color.mint.gradient)
                    }
                    .accessibilityLabel(weightDiff.date.weekdayTitle)
                    .accessibilityValue("\(weightDiff.value) kilos")
                }
            }
            .frame(height: 150)
            .chartXSelection(value: $rawSelectedDate.animation(.easeIn))
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisValueLabel(format: .dateTime.weekday(), centered: true)
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.secondary.opacity(0.4))
                    
                    AxisValueLabel()
                }
            }
            .overlay {
                if chartData.isEmpty {
                    ChartEmptyView(systemImageName: "chart.bar",
                                   title: "No Data",
                                   description: "There is no weight data available at this time.")
                }
            }
        }
       .sensoryFeedback(.selection, trigger: selectedDay)
       .onChange(of: rawSelectedDate) { oldValue, newValue in
           if oldValue?.weekDayInt != newValue?.weekDayInt {
               selectedDay = newValue
           }
       }
    }
}

#Preview {
    VStack {
        WeightDiffBarChart(chartData: MockData.weightDiffs)
        WeightDiffBarChart(chartData: [])
    }
}
