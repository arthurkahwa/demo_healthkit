//
//  DashboardView.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/16/24.
//

import SwiftUI

struct DashboardView: View {
    @Environment(HealthKitManager.self) private var hkManager
    @AppStorage("HasSeenPermissionPriming") private var hasSeenPermissionPriming = false
    @State private var isShowingPermissionPrimingSheet = false
    @State private var selectedStat: HealthMetrcContext = .steps
    var isSteps: Bool { selectedStat == .steps }
    
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
                                    
                                    Text("Avereage 10k Steps")
                                        .font(.caption)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                        }
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                        
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.secondary)
                            .frame(height: 160)
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
//            .task {
//                await hkManager.addSimulatorData()
//            }
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
