//
//  DateManager.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 05/08/2020.
//  Copyright © 2020 Appiskey. All rights reserved.
//

import Foundation


class DateManager {
    
    private init(){
        
    }
    static let shared = DateManager()
    private let formatter = DateFormatter()
    
    func getDate(from string: String, format: String, needsZone: Bool = true) -> Date? {
        formatter.dateFormat = format
        if needsZone {
            formatter.timeZone = TimeZone.current
        }
        return formatter.date(from: string)
    }
    
    func getString(from date: Date, format: String, needsZone: Bool = true) -> String {
        formatter.dateFormat = format
        if needsZone {
            formatter.timeZone = TimeZone.current
        }
        return formatter.string(from: date)
    }

    func compareDate(date1:Date, date2:Date) -> Bool {
        let order = Calendar.current.compare(date1, to: date2,
                                             toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    func isCurrentDate(between registerStartDate : Date, and registerEndDate: Date) -> Bool{
        
        if self.compareDate(date1: registerStartDate, date2: Date()) || self.compareDate(date1: Date(), date2: registerEndDate) {
            return true
        } else if Date() >= registerStartDate || Date() <= registerEndDate {
            return true
        } else {
            return false
        }
    }
}
