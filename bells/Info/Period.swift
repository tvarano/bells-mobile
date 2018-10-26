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
    
    init(name: String, from start: Time, to end: Time) {
        self.name = name; self.startTime = start; self.endTime = end
    }
    
    func contains(time: Time) -> Bool {
        return time > startTime && time < endTime
    }
}

