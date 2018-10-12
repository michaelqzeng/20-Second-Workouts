//
//  ReusableCollectionView.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 10/2/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class ReusableCollectionView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: safeTopAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: safeBottomAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: safeLeadingAnchor).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: safeTrailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var headerLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .left
        return label
    }()
}
