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
    
    var isSteps: Bool { selectedStat == .steps }
    
    var minChartDataValue: Double {
        chartData.map { $0.value }.min() ?? 0
    }
    
    var body: some View {
        VStack { // Overall chart card
            NavigationLink(value: selectedStat){
                HStack {
                    VStack(alignment: .leading) {
                        Label(selectedStat.title, systemImage: isSteps ?  "figure.walk" : "scalemass.fill")
                            .font(.title3.bold())
                            .foregroundStyle(.indigo)
                        
                        Text("Avereage Weight")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
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
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    WeightLineChart(selectedStat: .weight, chartData: MockData.weight)
}
