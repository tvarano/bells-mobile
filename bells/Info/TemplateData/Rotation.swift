//
//  Rotation.swift
//  bells
//
//  Created by Thomas Varano on 10/26/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import Foundation

struct Rotation {
    var times: [Period]
    let dayType: DayType
    let ordinal: Int
    let name: String
    
    init(ordinal: Int, name: String, dayType: DayType, slotRotation: [Int]) {
        times = []
        self.name = name
        self.ordinal = ordinal
        self.dayType = dayType
        var slotRotation = retrieveSlotRotation()
        for i in 0..<dayType.count() {
            times.append(Period(named: Period.getPeriodName(at: slotRotation[i]), from: dayType.startTimes[i], to: dayType.endTimes[i]))
        }
    }
    
    func retrieveSlotRotation() -> [Int] {
        // try reading from internet
        // catch
        return getOfflineRotation();
    }
    
    func getOfflineRotation() -> [Int] {
        return RotationManager.getSlotRotation(for: ordinal)
    }
}

class RotationManager {
    var rotations: [Rotation]
    let names = ["R1", "R2", "R3", "R4", "Odd Block", "Even Block", "R1 Half Day", "R3 Half Day", "R4 Half Day", "R1 Delayed Opening", "R3 Delayed Opening", "R4 Delayed Opening", "Odd Block Delayed Opening", "Even Block Delayed Opening", "No School", "INCORRECT_PARSE", "Day One", "Day Two", "Day Three", "10:00 Opening", "Special", "Flipped Even Block"]
    
    init() {
        rotations = []
    }
    
    static func getSlotRotation(for ordinal: Int) -> [Int] {
        switch ordinal {
        case R1, delayR1:
            return [1, 2, 3, 4, lunch, 5, 6, 7]
        case R2:
            return [2, 3, 4, 1, lunch, 5, 6, 7]
        case R3, delayR3:
            return [3, 4, 1, 2, lunch, 6, 7, 5]
        case R4, delayR4:
            return [4, 1, 2, 3, lunch, 7, 5, 6]
        case oddBlock, delayOdd:
            return [3, 1, lunch, 5, 7]
        case evenBlock:
            return [2, 4, lunch, pascack, 6]
        case delayEven:
            return [2, 4, lunch, 6]
        case halfR1:
            return [1, 2, 3, 4, 5, 6, 7]
        case halfR4:
            return [4, 1, 2, 3, 7, 5, 6]
        case halfR3:
            return [3, 4, 1, 2, 6, 7, 5]
        case testOne:
            return [1, pascackStudy, lunch, 5, pascackStudy]
        case testTwo:
            return [2, 4, lunch, pascackStudy, 6]
        case testThree:
            return [3, pascackStudy, lunch, 7, pascackStudy]
        case delayArr:
            return [6, lunch, 2, 4]
        case special:
            return [specialOfflineIndex]
        case flipEvenBlock:
            return [2, 4, lunch, 6, pascackStudy]
        default: return []
        }
    }
}

let lunch = 9, pascack = 10, noSchoolSlot = 11, pascackStudy = 12, specialOfflineIndex = 13, parcc = 14, noSlot = -1

let R1 = 0, R2 = 1, R3 = 2, R4 = 3, oddBlock = 4, evenBlock = 5
let halfR1 = 6, halfR3 = 7, halfR4 = 8
let delayR1 = 9, delayR3 = 10, delayR4 = 11, delayOdd = 12, delayEven = 13
let noSchoolOrdinal = 14, incorrectParse = 15, testOne = 16, testTwo = 17, testThree = 18, delayArr = 19, special = 20, flipEvenBlock = 21
