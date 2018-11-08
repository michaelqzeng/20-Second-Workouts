//
//  MuscleCell.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/10/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    func setupSections() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class MuscleCell: BaseCell {
    
    let size = CGFloat(35)
    
    var displayName: String? {
        didSet {
            thumbnailLabel.attributedText =  displayName?.convertToNSAtrributredString(size: size, color: UIColor.white)
        }
    }
    
    var imageName: String? {
        didSet {
            thumbnailImageView.image = UIImage(named: imageName ?? "male_arms") // add default image name later
        }
    }
    
    let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        view.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        return view
    }()
    
    // image of workout
    let thumbnailImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
//        imageview.backgroundColor = .blue
        imageview.image = UIImage(named: "male_arms")
        // maintain aspect ratio in cell
        //imageview.contentMode = .scaleAspectFit
        // round image
        imageview.layoutIfNeeded()
        imageview.layer.cornerRadius = 20
        imageview.layer.masksToBounds = true
        return imageview
    }()
    
    // View for favorite button
    let favoriteButtonView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.alpha = 0.8
//        print(view.frame.height)
        return view
    }()
    
    // Button represented as UIImageview
    let favoriteImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "fav_star"))
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.8
//        print(imageView.frame.height)
//        imageView.contentMode = .scaleAspectFit
//        imageView.layer.cornerRadius = imageView.frame.height/2
//        imageView.clipsToBounds = true
//        imageView.layer.masksToBounds = false
        return imageView
    }()
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        print("Selected")
    }
    
    // name of workout
    let thumbnailLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        favoriteButtonView.layer.cornerRadius = favoriteButtonView.frame.height/2
    }
    
    override func setupViews() {
        super.setupViews()
        
//        self.backgroundColor = .white
        setupSections()
        setupCell()
        
        // add muscle image
//        addSubview(thumbnailImageView)
        // 80 pixels from top, 57 pixels from left and right
//        addConstraintsWithFormat(format: "V:|-25-[v0]|", views: thumbnailImageView)
//        addConstraintsWithFormat(format: "H:|-35-[v0]-35-|", views: thumbnailImageView)
        
        // add muscle name
//        addSubview(thumbnailLabel)
        // anchor to center of thumbnail imageview
//        thumbnailLabel.centerAnchor(to: thumbnailImageView)
    }
    
    override func setupSections() {
//        self.addSubview(cellView)
    }
    
    private func setupCell() {
        self.addSubview(thumbnailImageView)
        thumbnailImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 5/6).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 4/5).isActive = true
        thumbnailImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        thumbnailImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        self.addSubview(thumbnailLabel)
        thumbnailLabel.centerAnchor(to: thumbnailImageView)
        thumbnailLabel.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 1).isActive = true
        thumbnailLabel.widthAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 1).isActive = true
    }
}
