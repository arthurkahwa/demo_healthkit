//
//  HealthMetrcContext.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/16/24.
//

import Foundation

enum HealthMetrcContext: CaseIterable, Identifiable {
    var id: Self { self }
    
    case steps
    case weight
//    case pressure
//    case sugar
    
    
    var title: String {
        switch self {
            
        case .steps:
            return "Steps"
            
        case .weight:
            return "Weight"
            
//        case .pressure:
//            return "blood Pressure"
//            
//        case .sugar:
//            return "Glucose Level"
        }
    }
}
