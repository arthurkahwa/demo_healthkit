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
    @State private var selectedStat: HealthMetrcContext = .steps
    var isSteps: Bool { selectedStat == .steps }
    
    var averageStepCount: Double {
        guard !hkManager.stepData .isEmpty else { return 0 }
        
        let totalSteps = hkManager.stepData.reduce(0) { $0 + $1.value }
        
        return totalSteps / Double(hkManager.stepData.count)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 20) {
                    Picker("Selected stat", selection: $selectedStat) {
                        ForEach(HealthMetrcContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    VStack { // Overall chart card
                        NavigationLink(value: selectedStat){
                            HStack {
                                VStack(alignment: .leading) {
                                    Label(selectedStat.title, systemImage: isSteps ?  "figure.walk" : "scalemass.fill")
                                        .font(.title3.bold())
                                        .foregroundStyle(.pink)
                                    
                                    Text("Avereage \(Int(averageStepCount)) Steps")
                                        .font(.caption)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                        }
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                        
                        Chart {
                            RuleMark(y: .value("Average", averageStepCount))
                                .foregroundStyle(Color.secondary)
                                .lineStyle(.init(lineWidth: 1, dash: [4]))
                            
                            ForEach(hkManager.stepData) { steps in
                                BarMark(x: .value("Date", steps.date, unit: .day),
                                        y: .value("Steps", steps.value)
                                )
                                .foregroundStyle(Color.pink.gradient)
                            }
                        }
                        .frame(height: 150)
                        .chartXAxis {
                            AxisMarks {
                                AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                            }
                        }
                        .chartYAxis {
                            AxisMarks { value in
                                AxisGridLine()
                                    .foregroundStyle(Color.secondary.opacity(0.4))
                                
                                AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                    
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
            .padding()
            .onAppear(perform: {
                isShowingPermissionPrimingSheet = !hasSeenPermissionPriming
            })
            .task {
                await hkManager.fetchStepCount()
//                await hkManager.addSimulatorData()
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetrcContext.self) { metric in
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
