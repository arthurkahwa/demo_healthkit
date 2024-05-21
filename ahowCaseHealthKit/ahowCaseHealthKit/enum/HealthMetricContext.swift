//
//  HealthMetricContext.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/16/24.
//

import Foundation

enum HealthMetricContext: CaseIterable, Identifiable {
    var id: Self { self }
    
    case steps
    case weight
    
    
    var title: String {
        switch self {
            
        case .steps:
            return "Steps"
            
        case .weight:
            return "Weight"
        }
    }
}
