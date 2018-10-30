//
//  File.swift
//  bells
//
//  Created by Thomas Varano on 10/25/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import Foundation

struct DayType {
    let ordinal: Int!
    let name: String!
    let startTimes, endTimes: [Time]!
    let labSwitch: Time?
    
    init(ordinal: Int, name: String, starts: [Time], ends: [Time], labSwitch: Time?) {
        self.ordinal = ordinal; self.name = name
        self.startTimes = starts; self.endTimes = ends; self.labSwitch = labSwitch
    }
    
    func labCapable() -> Bool {
        return !(labSwitch != nil)
    }
    
    func getDayLength() -> Time {
        return startTimes[0].timeUntil(other: endTimes[endTimes.endIndex - 1])
    }
    
    func count() -> Int {
        return startTimes.count
    }
}

class DayTypeManager {
    var vals: [DayType]
    let names: [String] = ["normal", "block", "half_day", "delayed_open", "delay_odd", "delay_even", "no_school", "test_day", "delay_arr", "special"]
    
    static let normal = 0, block = 1, halfDay = 2, delayOpen = 3, delayOdd = 4, delayEven = 5, noSchool = 6, testDay = 7, delayArr = 8, special = 9
    
    // create all types
    init() {
        vals = []
        //online init
        //catch for offline
        offlineInit()
    }
    
    private func offlineInit() {
        // Initialize all start times manually, in case of a lack of internet connection
        let allStarts: [[Time]] = [
            // Normal
            [Time(8, 0), Time(8,52), Time(9,46), Time(10,38), Time(11,30), Time(12,21), Time(13,13), Time(14,05)],
            // Block
             [Time(8,0), Time(9,31), Time(11,04), Time(11,55), Time(13,26)],
            // Half Day
             [Time(8,00), Time(8,35), Time(9,12), Time(9,47), Time(10,22), Time(10,56), Time(11,30)],
            // Delayed Opening Normal
             [Time(9, 30), Time(10, 9), Time(10, 50), Time(11, 29), Time(12, 8), Time(12, 59),Time(13, 38), Time(14, 17)],
            // Delay Odd
             [Time(9,30), Time(10,39), Time(11,48), Time(12,39), Time(13,48)],
            // Delay Even
             [Time(9,30), Time(11,2), Time(12,34), Time(13,25)],
            // No School
             [Time.midnight()],
            // Test Day
             [Time(8,0), Time(9,29), Time(11,01), Time(11,57), Time(13,26)],
            // Delay Arr
             [Time(10,00), Time(11,22), Time(12,13), Time(13,35)],
            // Special
             [Time.midnight()]
        ]
        
        let allEnds: [[Time]] = [
            // Normal
            [Time(8,48), Time(9,42), Time(10,34), Time(11,26), Time(12,17), Time(13,9), Time(14,1), Time(14,53)],
            // Block
            [Time(9,27), Time(11,00), Time(11,51), Time(13,22), Time(14,53)],
            // Half Day
            [Time(8,31), Time(9,8), Time(9,43), Time(10,18), Time(10,52), Time(11,26), Time(12,00)],
            // Delayed Opening Normal
            [Time(10, 5), Time(10, 46), Time(11, 25), Time(12, 4), Time(12, 55), Time(13, 34), Time(14, 13), Time(14, 53)],
            // Delay Odd
            [Time(10,35), Time(11,44), Time(12,35), Time(13,44), Time(14,53)],
            // Delay Even
            [Time(10,58), Time(12,30), Time(13,21), Time(14,53)],
            // No School
            [Time(23,59)],
            // Test Day
            [Time(9,25), Time(10,57), Time(11,53), Time(13,22), Time(14,53)],
            // Delay Arr
            [Time(11,18), Time(12,9), Time(13,31), Time(14,53)],
            // Special
            [Time(0, 1)]
        ]
        
        let labs: [Time] = [Time(11,53), Time(11,21)]
        
        for ord in 0..<names.count {
            if ord < labs.count {
                vals.append(DayType(ordinal: ord, name: names[ord], starts: allStarts[ord], ends: allEnds[ord], labSwitch: labs[ord]))
            } else {
                vals.append(DayType(ordinal: ord, name: names[ord], starts: allStarts[ord], ends: allEnds[ord], labSwitch: nil))
            }
        }
    }
    func get(name: String) -> DayType? {
        for t in vals {
            if t.name == name {
                return t
            }
        }
        return nil
    }
}
