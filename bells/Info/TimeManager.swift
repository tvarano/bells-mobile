//
//  TimeManager.swift
//  bells
//
//  Created by Thomas Varano on 10/25/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import Foundation

class TimeManager {
    var rotations: RotationManager
    var currentRotation: Rotation
    let view: ViewController
    
    init(rotations: RotationManager, view: ViewController) {
        self.view = view
        self.rotations = rotations
        currentRotation = rotations.vals[incorrectParse]
        currentRotation = findTodaysRotation()
    }
    
    func findTodaysRotation() -> Rotation{
        //use more later, but for now just do by day
        switch Date().dayNumberOfWeek() {
        case 1, 7:
//            return rotations.vals[noSchoolOrdinal]
            return rotations.vals[R1]
        case 2:
            return rotations.vals[R1]
        case 3:
            return rotations.vals[oddBlock]
        case 4:
            return rotations.vals[evenBlock]
        case 5:
            return rotations.vals[R4]
        case 6:
            return rotations.vals[R3]
        default:
            return rotations.vals[incorrectParse]
        }
    }
    
    func getCurrentClass() -> Period? {
        for per in currentRotation.times {
            if per.contains(time: Time.now()) {
                return per
            }
        }
        return nil
    }
}
