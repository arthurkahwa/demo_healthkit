//
//  StepPieChart.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/21/24.
//

import SwiftUI
import Charts

struct StepPieChart: View {
    var chartData: [DateValueChartData]
    
    @State private var rawSelectedChartValue: Double? = 0
    @State private var selectedDay: Date?
    @State private var lastSelectedValue: Double = 0
    
    var selectedWeekDay: DateValueChartData? {
        var total = 0.0
        
        return chartData.first {
            total += $0.value
            
            return lastSelectedValue <= total
        }
    }
    
    var body: some View {
        ChartContainer(title: "Averages",
                       symbol: "calendar",
                       subTitle: "last 28 days",
                       context: .steps,
                       isNavigation: false) {
            
            
            Chart {
                ForEach(chartData) { weekday in
                    SectorMark(angle: .value("Average Steps", weekday.value),
                               innerRadius: .ratio(0.618),
                               outerRadius: selectedWeekDay?.date.weekDayInt == weekday.date.weekDayInt ? 120 : 110,
                               angularInset: 1)
                    .foregroundStyle(.pink.gradient)
                    .cornerRadius(4)
                    .opacity(selectedWeekDay?.date.weekDayInt == weekday.date.weekDayInt ? 1.0 : 0.4)
                }
            }
            .chartAngleSelection(value: $rawSelectedChartValue)
            .onChange(of: rawSelectedChartValue) { oldValue, newValue in
                withAnimation(.easeInOut) {
                    guard let newValue
                    else {
                        lastSelectedValue = oldValue ?? 0
                        
                        return
                    }
                    
                    lastSelectedValue = newValue
                }
            }
            .frame(height: 240)
            .chartBackground { proxy in
                GeometryReader { geometry in
                    if let plotFrame = proxy.plotFrame {
                        let frame = geometry[plotFrame]
                        
                        if let selectedWeekDay {
                            VStack {
                                Text(selectedWeekDay.date.weekdayTitle)
                                    .font(.title3.bold())
                                    .animation(.none)
                                
                                Text(selectedWeekDay.value, format: .number.precision(.fractionLength(0)))
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                    .contentTransition(.numericText())
                            }
                            .position(x: frame.midX, y: frame.midY)
                        }
                    }
                    
                }
            }
            .overlay {
                if chartData.isEmpty {
                    ChartEmptyView(systemImageName: "chart.pie",
                                   title: "No Data",
                                   description: "There is no step data available at this time.")
                }
            }
        }
       .sensoryFeedback(.selection, trigger: selectedDay)
       .onChange(of: selectedWeekDay) { oldValue, newValue in
           guard let oldValue, let newValue else { return }
           if oldValue.date.weekDayInt != newValue.date.weekDayInt {
               selectedDay = newValue.date
           }
       }
    }
}

#Preview {
    VStack {
        StepPieChart(chartData: ChartMath.averageWeekdayCount(for: MockData.steps))
        StepPieChart(chartData: ChartMath.averageWeekdayCount(for: []))
    }
}
