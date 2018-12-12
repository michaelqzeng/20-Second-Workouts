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
    
//    let size = UIScreen.main.bounds.height/18
    let size = CGFloat(38)
//    let size: CGFloat = {
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            return CGFloat(48)
//        }
//        return CGFloat(38)
//    }()
    
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
//        imageview.layer.borderWidth = 5.0
//        imageview.layer.borderColor = UIColor.rgb(red: 191, green: 192, blue: 193).withAlphaComponent(0.8).cgColor
        return imageview
    }()
    
    // View for favorite button
    let favoriteButtonView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
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
        
        setupSections()
        setupCell()
        
    }
    
    override func setupSections() {
//        self.addSubview(cellView)
    }
    
    private func setupCell() {
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = UIColor.rgb(red: 191, green: 192, blue: 193)
        borderView.alpha = 0.4
        self.addSubview(borderView)
        borderView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 19/24).isActive = true
        borderView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 4/5).isActive = true
        borderView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        borderView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        borderView.layoutIfNeeded()
        borderView.layer.cornerRadius = 20
        borderView.layer.masksToBounds = true
        
        self.addSubview(thumbnailImageView)
        thumbnailImageView.widthAnchor.constraint(equalTo: borderView.widthAnchor, constant: -8).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalTo: borderView.heightAnchor, constant: -8).isActive = true
        thumbnailImageView.centerXAnchor.constraint(equalTo: borderView.centerXAnchor).isActive = true
        thumbnailImageView.centerYAnchor.constraint(equalTo: borderView.centerYAnchor).isActive = true

        self.addSubview(thumbnailLabel)
        thumbnailLabel.centerAnchor(to: thumbnailImageView)
        thumbnailLabel.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 1).isActive = true
        thumbnailLabel.widthAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 1).isActive = true
    }
}
