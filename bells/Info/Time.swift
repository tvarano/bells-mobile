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
        let timeToMidnight: Int = timeUntil(other: .midnight() - 1).getTotalMins() + 1
        return Time(totalMins: timeToMidnight + other.getTotalMins())
    }
}
