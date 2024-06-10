//
//  StepTrackerError.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 6/5/24.
//

import Foundation

enum StepTrackerError: Error {
    case authNotDetermined
    case sharingDenied(quantityType: String)
    case noData
    case unableToCompleteRequest
}
