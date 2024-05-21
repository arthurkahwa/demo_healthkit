//
//  StepPieChart.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/21/24.
//

import SwiftUI
import Charts

struct StepPieChart: View {
    var body: some View {
        VStack(alignment: .leading) { // Overall chart card
            VStack(alignment: .leading) {
                Label("Averages", systemImage: "calendar")
                    .font(.title3.bold())
                    .foregroundStyle(.pink)
                
                Text("last 28 days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
            }
            .padding(.bottom, 12)
            
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.secondary)
                .frame(height: 240)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    StepPieChart()
}
