//
//  SpacerView.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 10/13/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class SpacerView: UIView {
    
    let space: CGFloat
    
    override var intrinsicContentSize: CGSize {
        return .init(width: space, height: space)
    }
    
    init(space: CGFloat) {
        self.space = space
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
