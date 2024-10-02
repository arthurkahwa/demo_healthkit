//
//  StepBarChart.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/20/24.
//

import SwiftUI
import Charts

struct StepBarChart: View {
    var chartData: [DateValueChartData]
    
    var selectedData: DateValueChartData? {
        ChartHelper.parseSelectedData(from: chartData, in: rawSelectedDate)
    }
    
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?
        
    var body: some View {
        ChartContainer(title: "Steps",
                       symbol: "figure.walk",
                       subTitle: "Avereage \(Int(ChartHelper.average(for: chartData))) Steps",
                       context: .steps,
                       isNavigation: true) {
            
            if chartData.isEmpty {
               ChartEmptyView(systemImageName: "chart.bar",
                              title: "No Data",
                              description: "There is no step data available at this time.")
            }
            else {
                Chart {
                    if let selectedData {
                        RuleMark(x: .value("Selected Metric", selectedData.date, unit: .day))
                            .foregroundStyle(Color.secondary.opacity(0.4))
                            .offset(y: -12)
                            .annotation(position: .top,
                                        spacing: 0,
                                        overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                                ChartAnnotationView(data: selectedData, context: .steps)
                            }
                    }
                    
                    RuleMark(y: .value("Average", ChartHelper.average(for: chartData)))
                        .foregroundStyle(Color.secondary)
                        .lineStyle(.init(lineWidth: 1, dash: [4]))
                    
                    ForEach(chartData) { steps in
                        BarMark(x: .value("Date", steps.date, unit: .day),
                                y: .value("Steps", steps.value)
                        )
                        .foregroundStyle(Color.pink.gradient)
                        .opacity(rawSelectedDate == nil || steps.date == selectedData?.date ? 1.0 : 0.4)
                    }
                }
                .frame(height: 150)
                .chartXSelection(value: $rawSelectedDate.animation(.easeIn))
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel(format: .dateTime.day().month(.defaultDigits))
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                            .foregroundStyle(Color.secondary.opacity(0.4))
                        
                        AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
                    }
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
        StepBarChart(chartData: ChartHelper.convert(data: MockData.steps))
        StepBarChart(chartData: [])
    }
}
