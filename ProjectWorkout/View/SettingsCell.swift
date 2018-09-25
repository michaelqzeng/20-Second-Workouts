//
//  SettingsCell.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/19/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class SettingsCell: BaseCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorites"
        label.sizeToFit()
        return label
    }()
    
    var settingsOption: Setting? {
        didSet {
            nameLabel.text = settingsOption?.settingOptionName
            nameLabel.textAlignment = .center
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(nameLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        
    }
}
