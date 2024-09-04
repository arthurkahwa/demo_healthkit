//
//  ChartContainer.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 9/4/24.
//

import SwiftUI

struct ChartContainer<Content: View>: View {
    
    let title: String
    let symbol: String
    let subTitle: String
    let context: HealthMetricContext
    let isNavigation: Bool
    
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
    }
    
    var titleView: some View {
        VStack(alignment: .leading) {
            Label(title, systemImage: symbol)
                .font(.title3.bold())
                .foregroundStyle(context == .steps ? .pink : .indigo)
            
            Text(subTitle)
                .font(.caption)
        }
    }
}

#Preview {
    ChartContainer(title: "Test Title",
                   symbol: "figure.walk",
                   subTitle: "Step title",
                   context: .steps,
                   isNavigation: true) {
        
        Text("Content goes here")
            .frame(minHeight: 150)
    }
}
