//
//  WorkoutCell.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 10/1/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class WorkoutCell: BaseCell {
    
    var link: WorkoutListController?
    var favoritesListLink: FavoritesListController?
    
    let brightYellow = UIColor.rgb(red: 255, green: 255, blue: 0)
    let darkGray = UIColor.rgb(red: 61, green: 61, blue: 56).withAlphaComponent(0.55)
    let lightGray = UIColor.rgb(red: 183, green: 183, blue: 176)
    
//    let pageLabelSize = UIScreen.main.bounds.height/18
    let pageLabelSize = CGFloat(38)
    
//    var muscle: Muscle? {
//        didSet {
//            thumbnailLabel.attributedText =  (muscle?.displayName)!.convertToNSAtrributredString(size: 28, color: UIColor.white)
////            thumbnailImageView.image = UIImage(named: (muscle?.muscleImageName)!)
//        }
//    }

    var displayName: String? {
        didSet {
            thumbnailLabel.attributedText = displayName?.convertToNSAtrributredString(size: pageLabelSize, color: UIColor.white)
        }
    }
    
    var imageName: String? {
        didSet {
            thumbnailImageView.image = UIImage(named: imageName ?? "male_arms") // add default image here later for failed loads
//            thumbnailImageView.image = UIImage(named: "male_arms") // debugging image for workout
        }
    }
    
    var hasFavorited: String? {
        didSet {
            self.favoriteImageView.tintColor = hasFavorited == "TRUE" ? brightYellow : lightGray
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
//                imageview.backgroundColor = .blue
        imageview.image = UIImage(named: "male_arms")
        // maintain aspect ratio in cell
        //imageview.contentMode = .scaleAspectFit
        // round image
        imageview.layoutIfNeeded()
        imageview.layer.cornerRadius = 20
        imageview.layer.masksToBounds = true
//        imageview.layer.borderWidth = 5.0
//        imageview.layer.borderColor = UIColor.rgb(red: 191, green: 192, blue: 193).withAlphaComponent(0.25).cgColor
        
        return imageview
    }()
    
    // View for favorite button
    let favoriteButtonView: UIView = {
        let view = UIView(frame: CGRect.zero)
        //        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(red: 61, green: 61, blue: 56)
        view.alpha = 0.8
        return view
    }()
    
    // Button represented as UIImageview
    let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "fav_star")!.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.8
        return imageView
    }()
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        print("Favorited")
        link?.favoriteCell(cell: self)
        favoritesListLink?.favoriteCell(cell: self)
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
        
        self.addSubview(favoriteButtonView)
        favoriteButtonView.widthAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 10.5/72).isActive = true
        favoriteButtonView.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 19.5/72).isActive = true
        //        favoriteButtonView.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor).isActive = true
        favoriteButtonView.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: -5).isActive = true
        //        favoriteButtonView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor).isActive = true
        favoriteButtonView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: 5).isActive = true
        
        self.addSubview(favoriteImageView)
        favoriteImageView.widthAnchor.constraint(equalTo: favoriteButtonView.widthAnchor, multiplier: 0.63).isActive = true
        favoriteImageView.heightAnchor.constraint(equalTo: favoriteButtonView.heightAnchor, multiplier: 0.63).isActive = true
        favoriteImageView.centerXAnchor.constraint(equalTo: favoriteButtonView.centerXAnchor).isActive = true
        favoriteImageView.centerYAnchor.constraint(equalTo: favoriteButtonView.centerYAnchor).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        favoriteImageView.isUserInteractionEnabled = true
        favoriteImageView.addGestureRecognizer(tapGesture)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        favoriteButtonView.isUserInteractionEnabled = true
        favoriteButtonView.addGestureRecognizer(tapGesture1)
    }
}
