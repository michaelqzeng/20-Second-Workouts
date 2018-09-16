//
//  Muscle.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/14/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class Muscle: NSObject {
    var muscleImageName: String?
    var displayName: String?
    
    init(imageFileName: String, muscleName: String) {
        muscleImageName = imageFileName
        displayName = muscleName
    }
}
