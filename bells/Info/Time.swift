//
//  Time.swift
//  bells
//
//  Created by Thomas Varano on 10/25/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import Foundation

let minInHour = 60
let hourInDay = 24
let minInDay = minInHour * hourInDay
struct Time: Equatable, Comparable {
    
    let min, hour: Int!
    
    init(hour: Int, min: Int) {
        let extraHours = min / minInHour
        self.hour = hour + extraHours
        self.hour %= hourInDay
        self.min = min % minInHour
    }
    
    init(_ hour: Int, _ min: Int) {
        self.init(hour: hour, min: min)
    }
    
    init(totalMins: Int) {
        var localMins = totalMins < 0 ? minInDay + totalMins : totalMins
        localMins %= minInDay
        hour = localMins / minInHour
        min = localMins % minInHour
    }
    
    static func now() -> Time {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return Time(hour: hour, min: minutes)
//        return Time(8,49)
    }
    
    static func midnight() -> Time {
        return Time(totalMins: 0)
    }
    
    func getTotalMins() -> Int {
        return hour * minInHour + min
    }
    
    //----------------Operators-----------------------
    static func < (this: Time, other: Time) -> Bool {
        return this.compareTo(other: other) < 0
    }
    
    static func > (this: Time, other: Time) -> Bool {
        return this.compareTo(other: other) > 0
    }
    
    static func <= (this: Time, other: Time) -> Bool {
        return this.compareTo(other: other) <= 0
    }
    
    static func >= (this: Time, other: Time) -> Bool {
        return this.compareTo(other: other) >= 0
    }
    
    static func == (this: Time, other: Time) -> Bool {
        return this.compareTo(other: other) == 0
    }
    
    static func - (this: Time, other: Time) -> Time {
        return Time(totalMins: this.getTotalMins() - other.getTotalMins())
    }
    
    static func - (this: Time, mins: Int) -> Time {
        return Time(totalMins: this.getTotalMins() + mins)
    }
    
    static func + (this: Time, other: Time) -> Time {
        return Time(totalMins: this.getTotalMins() + other.getTotalMins())
    }
    
    static func + (this: Time, mins: Int) -> Time {
        return Time(totalMins: this.getTotalMins() + mins)
    }
    
    private func compareTo(other: Time) -> Int {
        return getTotalMins() - other.getTotalMins()
    }
    
    func timeUntil (other: Time) -> Time {
        if other >= self {
            return other - self
        }
        let timeToMidnight: Int = minInDay - self.getTotalMins()
        return Time(totalMins: timeToMidnight + other.getTotalMins())
    }
    
    func string() -> String {
        return "\(hour ?? -1):\(min ?? -1)"
    }
    
    private func minString() -> String {
        return min < 10 ? "0\(min ?? -1)" : "\(min ?? -1)"
    }
    
    func string12hr() -> String {
        let am = hour < 12 ? "am" : "pm"
        let hourStr = hour <= 12 ? "\(hour ?? -1)" : "\(hour%12)"
        return "\(hourStr):\(minString()) \(am)"
        
    }
    
    func remainString() -> String {
        if hour != 0 {
            return "\(hour ?? -1) hour, \(minString()) minutes"
        } else {
            return min == 1 ? "\(minString()) minute" : "\(minString()) minutes"
        }
    }
}
