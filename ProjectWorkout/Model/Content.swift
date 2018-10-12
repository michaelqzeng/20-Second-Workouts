//
//  Content.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/29/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class Content: NSObject {
    init(subtitle: String, content: [String]) {
        self.subtitle = subtitle
        self.content = content
    }
    
    var subtitle: String?
    var content: [String]?
}
