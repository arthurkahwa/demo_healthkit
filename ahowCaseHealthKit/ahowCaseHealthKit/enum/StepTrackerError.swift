//
//  StepTrackerError.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 6/5/24.
//

import Foundation

enum StepTrackerError: LocalizedError {
    case authNotDetermined
    case sharingDenied(quantityType: String)
    case noData
    case unableToCompleteRequest
    case invalidValue
    
    var errorDescription: String? {
        switch self {
        case .authNotDetermined:
            "Need access to health data"
        case .sharingDenied(quantityType: let quantityType):
            "No write access"
        case .noData:
            "No data available"
        case .unableToCompleteRequest:
            "Unable to complete request"
        case .invalidValue:
            "Invalid value"
        }
    }
    
    var failureReason: String {
        switch self {
        case .authNotDetermined:
            "Give access to health data"
        case .sharingDenied(quantityType: let quantityType):
            "Access denied to to \(quantityType) data"
        case .noData:
            "No data for this health tatistic"
        case .unableToCompleteRequest:
            "Cannot complete request. Try again later."
        case .invalidValue:
            "Must be a numeric value with a maximum of 1 decimal place"
        }
    }
}
