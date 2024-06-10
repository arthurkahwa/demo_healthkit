//
//  HealthDetailListView.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/16/24.
//

import SwiftUI

struct HealthDetailListView: View {
    @Environment(HealthKitManager.self) private var hkManager
    
    @State private var isShowingAddData: Bool = false
    @State private var addDataDate: Date = .now
    @State private var valueToAdd: String = ""
    
    @Binding var isShowingPermissionPriming: Bool
    
    var metric: HealthMetricContext
    
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
            Button("Add Data", systemImage: "plus") {
                Task {
                    if metric == .steps {
                        do {
                            try await hkManager.addStepData(for: addDataDate,
                                                            value: Double(valueToAdd) ?? 0)
                            try await hkManager.fetchStepCount()
                            isShowingAddData = false
                        }
                        catch StepTrackerError.authNotDetermined {
                            isShowingPermissionPriming = true
                        }
                        catch StepTrackerError.sharingDenied(let quantityType) {
                            print("❌ sharing denied for \(quantityType)")
                        }
                        catch {
                            print("❌ data view unable to complete request.")
                        }                    }
                    else {
                        do {
                            try await hkManager.addWeightData(for: addDataDate,
                                                              value: Double(valueToAdd) ?? 0)
                            try await hkManager.fetchWeightData()
                            try await hkManager.fetchWeightDataForDifferencials()
                            isShowingAddData = false
                        }
                        catch StepTrackerError.authNotDetermined {
                            isShowingPermissionPriming = true
                        }
                        catch StepTrackerError.sharingDenied(let quantityType) {
                            print("❌ sharing denied for \(quantityType)")
                        }
                        catch {
                            print("❌ data view unable to complete request.")
                        } 
                    }
                }
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
        HealthDetailListView(isShowingPermissionPriming: .constant(false), metric: .steps)
            .environment(HealthKitManager())
    }
}
