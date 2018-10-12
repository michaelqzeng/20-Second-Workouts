//
//  Workout.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 10/1/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class Workout: NSObject {
    var subgroup: String?
    var muscle: [Muscle]?
    
    init(subgroup: String, muscle: [Muscle]) {
        self.subgroup = subgroup
        self.muscle = muscle
    }
}
