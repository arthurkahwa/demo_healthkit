//
//  WeightDiffBarChart.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/28/24.
//

import SwiftUI
import Charts

struct WeightDiffBarChart: View {
    var chartData: [WeekDayChartData]
    
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?
    
    var selectedData: WeekDayChartData? {
        guard let rawSelectedDate else { return nil }
        
        return chartData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    var body: some View {
        ChartContainer(title: "Weight Change",
                       symbol: "scalemass.fill",
                       subTitle: "Avereage for last 28 days",
                       context: .weight,
                       isNavigation: false) {
            if chartData.isEmpty {
               ChartEmptyView(systemImageName: "chart.bar",
                              title: "No Data",
                              description: "There is no weight data available at this time.")
            }
            else {
                Chart {
                    if let selectedData {
                        RuleMark(x: .value("Selected Data", selectedData.date, unit: .day))
                            .foregroundStyle(Color.secondary.opacity(0.4))
                            .offset(y: -12)
                            .annotation(position: .top,
                                        spacing: 0,
                                        overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                                annotationView
                            }
                    }
                    
                    ForEach(chartData) { weightDiff in
                        BarMark(x: .value("Date", weightDiff.date, unit: .day),
                                y: .value("Steps", weightDiff.value)
                        )
                        .foregroundStyle(weightDiff.value >= 0 ? Color.indigo.gradient : Color.mint.gradient)                }
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
            }
        }
        .sensoryFeedback(.selection, trigger: selectedDay)
        .onChange(of: rawSelectedDate) { oldValue, newValue in
            if oldValue?.weekDayInt != newValue?.weekDayInt {
                selectedDay = newValue
            }
        }
    }
    
    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedData?.date ?? .now, format: .dateTime.weekday(.abbreviated).day().month(.abbreviated))
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(selectedData?.value ?? 0, format: .number.precision(.fractionLength(2)))
                .fontWeight(.heavy)
                .foregroundStyle((selectedData?.value ?? 0) >= 0 ? .indigo : .mint)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}

#Preview {
    VStack {
        WeightDiffBarChart(chartData: MockData.weightDiffs)
        WeightDiffBarChart(chartData: [])
    }
}
