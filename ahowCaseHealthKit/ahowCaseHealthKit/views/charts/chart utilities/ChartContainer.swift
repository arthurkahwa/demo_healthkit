//
//  ChartContainer.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 9/4/24.
//

import SwiftUI

enum ChartType {
    case stepBar(average: Int)
    case stepWeeklyPie
    case weightLine(average: Double)
    case weightDiffBar
}

struct ChartContainer<Content: View>: View {
    
//    let title: String
//    let symbol: String
//    let subTitle: String
//    let context: HealthMetricContext
//    let isNavigation: Bool
    
    let chartType: ChartType
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) { // Overall chart card
            if isNavigation {
                navigationLinkView
            }
            else {
                titleView
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)
            }
            
            content()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
    
    var isNavigation: Bool {
        switch chartType{
        case .stepBar(_), .weightLine(_):
            return true
        case .stepWeeklyPie, .weightDiffBar:
            return false
        }
    }
    
    var context: HealthMetricContext {
        switch chartType {
        case .stepBar(_), .stepWeeklyPie:
            return .steps
        case .weightLine(_), .weightDiffBar:
            return .weight
        }
    }
    
    var title: String {
        switch chartType {
        case .stepBar(_):
            "Steps"
        case .stepWeeklyPie:
            "Average"
        case .weightLine(_):
            "Weight"
        case .weightDiffBar:
            "Average Weight Change"
        }
    }
    
    var subTitle: String {
        switch chartType {
        case .stepBar(average: let average):
            "Avereage \(average.formatted())) Steps"
        case .stepWeeklyPie:
            "last 28 days"
        case .weightLine(average: let average):
            "\(average)kg Avereage Weight"
        case .weightDiffBar:
            "Avereage for last 28 days"
        }
    }
    
    var symbol: String {
        switch chartType {
        case .stepBar(_):
            "figure.walk"
        case .stepWeeklyPie:
            "calendar"
        case .weightLine(_), .weightDiffBar:
            "figure"
        }
    }
    
    var navigationLinkView: some View {
        NavigationLink(value: context){
            HStack {
               titleView
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(.secondary)
        .padding(.bottom, 12)
        .accessibilityHint("Tap for data in list view")
    }
    
    var titleView: some View {
        VStack(alignment: .leading) {
            Label(title, systemImage: symbol)
                .font(.title3.bold())
                .foregroundStyle(context == .steps ? .pink : .indigo)
            
            Text(subTitle)
                .font(.caption)
        }
        .accessibilityAddTraits(.isHeader)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityElement(children: .ignore)
    }
    
    var accessibilityLabel: String {
        switch chartType {
        case .stepBar(average: let average):
            return "Bar chart, step count, last 28 days, averge steps per day \(average) steps"
        case .stepWeeklyPie:
           return  "pie chart, aversge steps per weekday"
        case .weightLine(average: let average):
            return "Line chart, weight, average \(average) kilos"
            
        case .weightDiffBar:
            return "Weight difference"
        }
    }
}

#Preview {
    ChartContainer(chartType: .stepWeeklyPie) {
        Text("Content goes here")
            .frame(minHeight: 150)
    }
}
