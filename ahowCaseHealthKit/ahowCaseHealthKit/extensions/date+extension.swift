//
//  date+extension.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/20/24.
//

import Foundation

extension Date {
    var weekDayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    var weekdayTitle: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    
    var accessibilityDate: String {
        self.formatted(.dateTime.month(.wide).day())
    }
}
