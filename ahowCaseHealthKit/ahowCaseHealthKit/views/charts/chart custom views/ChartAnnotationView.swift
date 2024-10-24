//
//  ChartAnnotationView.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 10/2/24.
//

import SwiftUI

struct ChartAnnotationView: View {
    let data: DateValueChartData
    let context: HealthMetricContext
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(data.date, format: .dateTime.weekday(.abbreviated).day().month(.abbreviated))
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(data.value, format: .number.precision(.fractionLength(context == .steps ? 0 : 1)))
                .fontWeight(.heavy)
                .foregroundStyle(context == .steps ? .pink : .indigo)
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
        ChartAnnotationView(data: .init(date: .now, value: 1000), context: .steps)
        ChartAnnotationView(data: .init(date: .now, value: 100), context: .weight)
    }
}
