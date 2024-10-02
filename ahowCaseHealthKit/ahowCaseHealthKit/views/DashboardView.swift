//
//  DashboardView.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/16/24.
//

import SwiftUI
import Charts

struct DashboardView: View {
    @Environment(HealthKitManager.self) private var hkManager
    
    @State private var isShowingPermissionPrimingSheet = false
    @State private var selectedStat: HealthMetricContext = .steps
    @State private var isShowingAlert = false
    @State private var fetchError: StepTrackerError = .noData
    
    var isSteps: Bool { selectedStat == .steps }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 20) {
                    Picker("Selected stat", selection: $selectedStat) {
                        ForEach(HealthMetricContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    switch selectedStat {
                    case .steps:
                        StepBarChart(chartData: ChartHelper.convert(data: hkManager.stepData))
                        StepPieChart(chartData: ChartMath.averageWeekdayCount(for: hkManager.stepData))
                        
                    case .weight:
                        WeightLineChart(chartData: ChartHelper.convert(data: hkManager.weightData))
                        WeightDiffBarChart(chartData: ChartMath.averageDailyWeightDifferences(for: hkManager.weightDiffData))
                    }
                }
            }
            .padding()
            .task {
                do {
                    try await hkManager.fetchStepCount()
                    try await hkManager.fetchWeightData()
                    try await hkManager.fetchWeightDataForDifferencials()
                    
//                    ChartMath.averageDailyWeightDifferences(for: hkManager.weightDiffData)
//                    await hkManager.addSimulatorData()
                }
                catch StepTrackerError.authNotDetermined {
                    isShowingPermissionPrimingSheet = true
                }
                catch StepTrackerError.noData {
                    fetchError = .noData
                    
                    isShowingAlert = true
                }
                catch {
                    fetchError = .unableToCompleteRequest

                    isShowingAlert = true
                }
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDetailListView(isShowingPermissionPriming: $isShowingPermissionPrimingSheet, metric: metric)
            }
            .sheet(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                // ToDo fetch health data
            }, content: {
                HealthKitPermissionPrimingView()
            })
            .alert(isPresented: $isShowingAlert, error: fetchError) { fetchError in
                // Action buttons
            } message: { fetchError in
                Text(fetchError.failureReason)
            }

        }
        .tint( isSteps ? .pink : .indigo)
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
