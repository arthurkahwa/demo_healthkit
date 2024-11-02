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
    
    fileprivate func fetchHealthData() {
        Task {
            do {
                async let steps = hkManager.fetchStepCount()
                async let weightsForLineChart = hkManager.fetchWeightData(daysBack: 28)
                async let weightsForDiffBarChart = hkManager.fetchWeightData(daysBack: 29)
                
                hkManager.stepData = try await steps
                hkManager.weightData = try await weightsForLineChart
                hkManager.weightDiffData = try await weightsForDiffBarChart
                
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
    }
    
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
                        StepPieChart(chartData: ChartHelper.averageWeekdayCount(for: hkManager.stepData))
                        
                    case .weight:
                        WeightLineChart(chartData: ChartHelper.convert(data: hkManager.weightData))
                        WeightDiffBarChart(chartData: ChartHelper.averageDailyWeightDifferences(for: hkManager.weightDiffData))
                    }
                }
            }
            .padding()
            .task { fetchHealthData() }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDetailListView(isShowingPermissionPriming: $isShowingPermissionPrimingSheet, metric: metric)
            }
            .fullScreenCover(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                fetchHealthData()
            }, content: {
                HealthKitPermissionPrimingView()
            })
            .alert(isPresented: $isShowingAlert, error: fetchError) { fetchError in
                // Action buttons
            } message: { fetchError in
                Text(fetchError.failureReason)
            }
        }
        .tint( selectedStat == .steps ? .pink : .indigo)
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
