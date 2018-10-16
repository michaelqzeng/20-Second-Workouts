//
//  Setting.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/20/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class Setting: NSObject {
    var settingOptionName: String?

    init(settingOptionName: String) {
        self.settingOptionName = settingOptionName
    }
}
