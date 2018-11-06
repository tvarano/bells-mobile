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
    
    func equals(other: Rotation) -> Bool {
        return other.ordinal == self.ordinal
    }
    
    func retrieveSlotRotation() -> [Int] {
        // try reading from internet
        // catch
        return getOfflineRotation();
    }
    
    func day() -> Period {
        return Period(named: "schoolDay", from: dayType.startTimes[0], to: dayType.endTimes[dayType.endTimes.count - 1])
    }
    
    func getOfflineRotation() -> [Int] {
        return RotationManager.getSlotRotation(for: ordinal)
    }
}

class RotationManager {
    var vals: [Rotation]
    var types: DayTypeManager
    
    static let names = ["R1", "R2", "R3", "R4", "Odd Block", "Even Block", "R1 Half Day", "R3 Half Day", "R4 Half Day", "R1 Delayed Opening", "R3 Delayed Opening", "R4 Delayed Opening", "Odd Block Delayed Opening", "Even Block Delayed Opening", "No School", "INCORRECT_PARSE", "Testing Day One", "Testing Day Two", "Testing Day Three", "10:00 Opening", "Special", "Pep Rally"]
    
    
    init(with types: DayTypeManager) {
        print("constructing rotation manager")
        vals = []
        self.types = types
        //online init
        //catch
        //offline init
        offlineInit()
    }
    
    convenience init() {
        self.init(with: DayTypeManager())
    }
    
    private func offlineInit() {
        for ord in 0..<RotationManager.names.count {
            vals.append(Rotation(ordinal: ord, name: RotationManager.names[ord], dayType: getType(for: ord), slotRotation: RotationManager.getSlotRotation(for: ord)))
        }
    }
    
    func getType(for ordinal: Int) -> DayType {
        switch ordinal {
        case R1, R2, R3, R4:
            return types.vals[DayTypeManager.normal]
        case evenBlock, oddBlock, flipEvenBlock:
            return types.vals[DayTypeManager.block]
        case halfR1, halfR3, halfR4:
            return types.vals[DayTypeManager.halfDay]
        case delayR1, delayR3, delayR4:
            return types.vals[DayTypeManager.delayOpen]
        case delayOdd:
            return types.vals[DayTypeManager.delayOdd]
        case delayEven:
            return types.vals[DayTypeManager.delayEven]
        case noSchoolOrdinal, incorrectParse:
            return types.vals[DayTypeManager.noSchool]
        case testOne, testTwo, testThree:
            return types.vals[DayTypeManager.testDay]
        case delayArr:
            return types.vals[DayTypeManager.delayArr]
        default:
            return types.vals[DayTypeManager.noSchool]
        }
        
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
        case noSchoolOrdinal, incorrectParse:
            return [noSchoolSlot]
        default: return []
        }
    }
    func get(name: String) -> Rotation? {
        for r in vals {
            if r.name == name {
                return r
            }
        }
        return nil
    }
}


class RotationTableManager {
    static let sectionNames: [String] = ["Normal", "Half Day", "Delayed Opening", "Midterm / Finals", "Other"]
    
    static let showOrder: [[Int]] = [[R1, oddBlock, evenBlock, R4, R3],
                            [halfR1, halfR3, halfR4],
                            [delayR1, delayOdd, delayEven, delayR4, delayR3, delayArr],
                            [testOne, testTwo, testThree],
                            [flipEvenBlock, special]
    ]
    
    var groups = [RotationGroup]()
    
    init(manager: RotationManager) {
        var nameIndex: Int = 0
        for sec in RotationTableManager.showOrder {
            var sectionVals = [Rotation]()
            for ind in sec {
                sectionVals.append(manager.vals[ind])
            }
            groups.append(RotationGroup(name: RotationTableManager.sectionNames[nameIndex], vals: sectionVals))
            nameIndex += 1
        }
    }
    
    
}

struct RotationGroup {
    var name: String
    var vals: [Rotation]
}

let lunch = 9, pascack = 10, noSchoolSlot = 11, pascackStudy = 12, specialOfflineIndex = 13, parcc = 14, noSlot = -1

let R1 = 0, R2 = 1, R3 = 2, R4 = 3, oddBlock = 4, evenBlock = 5
let halfR1 = 6, halfR3 = 7, halfR4 = 8
let delayR1 = 9, delayR3 = 10, delayR4 = 11, delayOdd = 12, delayEven = 13
let noSchoolOrdinal = 14, incorrectParse = 15, testOne = 16, testTwo = 17, testThree = 18, delayArr = 19, special = 20, flipEvenBlock = 21
let BREAK = -1
