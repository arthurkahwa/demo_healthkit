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
                ForEach(chartData) { weight in
                    AreaMark(x: .value("Date", weight.date, unit: .day),
                             y: .value("Value", weight.value))
                    .foregroundStyle(Gradient(colors: [.indigo.opacity(0.5), .clear]))
                    
                    LineMark(x: .value("Date", weight.date, unit: .day),
                             y: .value("Value", weight.value))
                }
            }
            .frame(height: 150)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    WeightLineChart(selectedStat: .weight, chartData: MockData.weight)
}
