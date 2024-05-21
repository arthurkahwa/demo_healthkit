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
    
    @AppStorage("HasSeenPermissionPriming") private var hasSeenPermissionPriming = false
    
    @State private var isShowingPermissionPrimingSheet = false
    @State private var selectedStat: HealthMetricContext = .steps
//    @State private var rawSelectedDate: Date?
    
    var isSteps: Bool { selectedStat == .steps }
    
//    var averageStepCount: Double {
//        guard !hkManager.stepData .isEmpty else { return 0 }
//        
//        let totalSteps = hkManager.stepData.reduce(0) { $0 + $1.value }
//        
//        return totalSteps / Double(hkManager.stepData.count)
//    }
//    
//    var selectedHealthMetric: HealthMetric? {
//        guard let rawSelectedDate else { return nil }
//        
//        return hkManager.stepData.first {
//            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
//        }
//    }
    
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
                    
                    StepBarChart(selectedStat: selectedStat, chartData: hkManager.stepData)
                    
                    StepPieChart(chartData: ChartMath.averageWeekdayCount(for: hkManager.stepData))
                }
            }
            .padding()
            .onAppear(perform: {
                isShowingPermissionPrimingSheet = !hasSeenPermissionPriming
            })
            .task {
                await hkManager.fetchStepCount()
//                await hkManager.addSimulatorData()
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDetailListView(metric: metric)
            }
            .sheet(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                // ToDo fetch health data
            }, content: {
                HealthKitPermissionPrimingView(hasSeen: $hasSeenPermissionPriming)
            })
        }
        .tint( isSteps ? .pink : .indigo)
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
