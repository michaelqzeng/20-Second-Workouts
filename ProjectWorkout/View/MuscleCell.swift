//
//  MuscleCell.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/10/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class MuscleCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    //var thumbnailLabel: UILabel
    //var thumbnailImageView: UIImageView?
    
    // every time our muscle variable is set
    var muscle: Muscle? {
        didSet{
            thumbnailLabel.attributedText =  (muscle?.displayName)!.convertToNSAtrributredString(size: 30)
            thumbnailImageView.image = UIImage(named: (muscle?.muscleImageName)!)
        }
    }
    
    // image of workout
    let thumbnailImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.backgroundColor = .blue
        imageview.image = UIImage(named: "male_arms")
        // maintain aspect ratio in cell
        //imageview.contentMode = .scaleAspectFit
        // round image
        imageview.layoutIfNeeded()
        imageview.layer.cornerRadius = 20
        imageview.layer.masksToBounds = true
        return imageview
    }()
    
    // name of workout
    let thumbnailLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 63, height: 32))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleAspectFit // maintain aspect ratio in cell

        //let text = "Mock text"
        

        //label.attributedText = text.convertToNSAtrributredString(size: 30)
        return label
    }()
    
    func setUpViews() {
        self.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        // add muscle image
        addSubview(thumbnailImageView)
        // 80 pixels from top, 57 pixels from left and right
        addConstraintsWithFormat(format: "V:|-25-[v0]|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "H:|-57-[v0]-57-|", views: thumbnailImageView)
        
        // add muscle name
        addSubview(thumbnailLabel)
        // anchor to center of thumbnail imageview
        thumbnailLabel.centerAnchor(to: thumbnailImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
