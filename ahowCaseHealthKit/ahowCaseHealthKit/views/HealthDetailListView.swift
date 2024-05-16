//
//  HealthDetailListView.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/16/24.
//

import SwiftUI

struct HealthDetailListView: View {
    @State private var isShowingAddData: Bool = false
    @State private var addDataDate: Date = .now
    @State private var valueToAdd: String = ""
    
    var metric: HealthMetrcContext
    
    var body: some View {
        List(0..<28) { identifiable in
            HStack {
                Text(Date(), format: .dateTime.day().month().year())
                
                Text(10000, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
            }
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingAddData) {
            addDataView
        }
        .toolbar {
            Button("Adddata", systemImage: "plus") {
                isShowingAddData = true
            }
        }
    }
    
    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                
                HStack {
                    Text(metric.title)
                    
                    Spacer()
                    
                    TextField("Vallue", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 160)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        //                        <#code#>
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isShowingAddData = false
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDetailListView(metric: .steps)
    }
}
