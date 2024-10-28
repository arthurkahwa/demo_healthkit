//
//  WeightLineChart.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/21/24.
//

import SwiftUI
import Charts

struct WeightLineChart: View {
    var chartData: [DateValueChartData]
    
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?
    
    var minChartDataValue: Double {
        chartData.map { $0.value }.min() ?? 0
    }
    
    var averageWeight: Double {
        chartData.map { $0.value }.average
    }
    
    var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedData(from: chartData, in: rawSelectedDate)
    }
    
    var body: some View {
        ChartContainer(chartType: .weightLine(average: averageWeight)) {
            Chart {
                if let selectedData {
                    RuleMark(x: .value("Selected Metric", selectedData.date, unit: .day))
                        .foregroundStyle(Color.secondary.opacity(0.4))
                        .offset(y: -12)
                        .annotation(position: .top,
                                    spacing: 0,
                                    overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                            ChartAnnotationView(data: selectedData, context: .weight)
                        }
                }
                
                if !chartData.isEmpty {
                    RuleMark(y: .value("Goal", 162))
                        .foregroundStyle(.mint)
                        .lineStyle(.init(lineWidth: 1, dash: [4]))
                        .accessibilityHidden(true)
                }
                
                ForEach(chartData) { weight in
                    Plot {
                        AreaMark(x: .value("Date", weight.date, unit: .day),
                                 yStart: .value("Value", weight.value),
                                 yEnd: .value("Min Value", minChartDataValue))
                        .foregroundStyle(Gradient(colors: [.indigo.opacity(0.5), .clear]))
                        
                        LineMark(x: .value("Date", weight.date, unit: .day),
                                 y: .value("Value", weight.value)
                        )
                        .foregroundStyle(.indigo)
                        .symbol(.circle)
                    }
                    .accessibilityLabel(weight.date.weekdayTitle)
                    .accessibilityValue("\(weight.value) kilos")

                }
                .interpolationMethod(.catmullRom)
            }
            .frame(height: 150)
            .chartXSelection(value: $rawSelectedDate)
            .chartYScale(domain: .automatic(includesZero: false))
            .chartXAxis {
                AxisMarks {
                    AxisValueLabel(format: .dateTime.day().month(.defaultDigits))
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
                    ChartEmptyView(systemImageName: "chart.line.downtrend.xyaxis",
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
        WeightLineChart(chartData: ChartHelper.convert(data: MockData.weight))
        WeightLineChart(chartData: [])
    }
}
