//
//  WeightLineChart.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/21/24.
//

import SwiftUI
import Charts

struct WeightLineChart: View {
    var selectedStat: HealthMetricContext
    var chartData: [HealthMetric]
    
    @State private var rawSelectedDate: Date?
    @State private var selectedDay: Date?
    
    var isSteps: Bool { selectedStat == .steps }
    
    var minChartDataValue: Double {
        chartData.map { $0.value }.min() ?? 0
    }
    
    var selectedHealthMetric: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        
        return chartData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    var body: some View {
        ChartContainer(title: "Avereage Weight",
                       symbol: "scalemass.fill",
                       subTitle: "Avereage Weight",
                       context: .weight,
                       isNavigation: true) {
            if chartData.isEmpty {
               ChartEmptyView(systemImageName: "chart.line.downtrend.xyaxis",
                              title: "No Data",
                              description: "There is no weight data available at this time.")
            }
            else {
                Chart {
                    if let selectedHealthMetric {
                        RuleMark(x: .value("Selected Metric", selectedHealthMetric.date, unit: .day))
                            .foregroundStyle(Color.secondary.opacity(0.4))
                            .offset(y: -12)
                            .annotation(position: .top,
                                        spacing: 0,
                                        overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                                annotationView
                            }
                    }
                    
                    RuleMark(y: .value("Goal", 162))
                        .foregroundStyle(.mint)
                        .lineStyle(.init(lineWidth: 1, dash: [4]))
                    
                    ForEach(chartData) { weight in
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
            Text(selectedHealthMetric?.date ?? .now, format: .dateTime.weekday(.abbreviated).day().month(.abbreviated))
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(selectedHealthMetric?.value ?? 0, format: .number.precision(.fractionLength(1)))
                .fontWeight(.heavy)
                .foregroundStyle(.indigo)
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
        WeightLineChart(selectedStat: .weight, chartData: MockData.weight)
        WeightLineChart(selectedStat: .weight, chartData: [])
    }
}
