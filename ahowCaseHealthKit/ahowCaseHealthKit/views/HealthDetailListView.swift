//
//  HealthDetailListView.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/16/24.
//

import SwiftUI

struct HealthDetailListView: View {
    @Environment(HealthKitManager.self) private var hkManager
    
    @State private var isShowingAddData = false
    @State private var isShowingAlert = false
    @State private var addDataDate: Date = .now
    @State private var writeError: StepTrackerError = .noData
    @State private var valueToAdd = ""
    
    @Binding var isShowingPermissionPriming: Bool
    
    var metric: HealthMetricContext
    
    var listData: [HealthMetric] {
        metric == .steps ? hkManager.stepData : hkManager.weightData
    }
    
    var body: some View {
        List(listData.reversed()) { data in
            LabeledContent {
                Text(data.value, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
            } label: {
                Text(data.date, format: .dateTime.day().month().year())
                    .accessibilityLabel(data.date.accessibilityDate)
            }
            .accessibilityElement(children: .combine)
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingAddData) {
            addDataView
        }
        .toolbar {
            Button("Add Data", systemImage: "plus") {
                isShowingAddData = true
            }
        }
    }
    
    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                
                LabeledContent(metric.title) {
                    TextField("Vallue", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 160)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.title)
            .alert(isPresented: $isShowingAlert, error: writeError, actions: { writeError in
                switch writeError {
                case .authNotDetermined,
                        .noData,
                        .unableToCompleteRequest,
                        .invalidValue :
                    EmptyView()
                case .sharingDenied(let quantityType):
                    Button("Settings") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    
                    Button("Cancel", role: .cancel) {}
                }
            }, message: { writeError in
                Text(writeError.failureReason)
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        addDataToHealhKit()
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
    
    private func addDataToHealhKit() {
        guard let value = Double(valueToAdd)
        else {
            writeError = .invalidValue
            isShowingAlert = true
            
            return
        }
        
        Task {
            do {
                if metric == .steps {
                    try await hkManager.addStepData(for: addDataDate,
                                                    value: value)
                    
                    hkManager.stepData = try await hkManager.fetchStepCount()
                }
                else {
                    try await hkManager.addWeightData(for: addDataDate,
                                                      value: value)
                    
                    async let weightsForLineChart = hkManager.fetchWeightData(daysBack: 28)
                    async let weightsForDiffBarChart = hkManager.fetchWeightData(daysBack: 29)
                    
                    hkManager.weightData = try await weightsForLineChart
                    hkManager.weightDiffData = try await weightsForDiffBarChart
                }
            }
            catch StepTrackerError.authNotDetermined {
                writeError = .authNotDetermined
                isShowingPermissionPriming = true
            }
            catch StepTrackerError.sharingDenied(let quantityType) {
                writeError = .sharingDenied(quantityType: quantityType)
                isShowingAlert = true
            }
            catch {
                writeError = .unableToCompleteRequest
                isShowingAlert = true
            }
            
            isShowingAddData = false
        }
    }
}

#Preview {
    NavigationStack {
        HealthDetailListView(isShowingPermissionPriming: .constant(false), metric: .steps)
            .environment(HealthKitManager())
    }
}
