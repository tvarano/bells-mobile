//
//  Period.swift
//  bells
//
//  Created by Thomas Varano on 10/25/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import Foundation

class Period {
    var startTime, endTime: Time!
    var name: String!
    
    init(named name: String, from start: Time, to end: Time) {
        self.name = name; self.startTime = start; self.endTime = end
    }
    
    func contains(time: Time) -> Bool {
        return time > startTime && time < endTime
    }
    
    static func getPeriodName(at period: Int) -> String {
        if showPeriod(slot: period) {
            return "Period \(period)"
        }
        switch period {
        case lunch:
            return "Lunch"
        case pascack:
            return "Pascack Period"
        case noSchoolSlot:
            return "No School"
        case pascackStudy:
            return "Pascack Study Period"
        case specialOfflineIndex:
            return "Error. Offline"
        case parcc:
            return "Parcc Testing"
        default:
            return "Unnamed Period"
        }
    }
    
    static func showPeriod(slot: Int) -> Bool {
        return slot >= 0 && slot <= 8
    }
}
