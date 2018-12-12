//
//  ContentCell.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/29/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class ContentCell: UITableViewCell {
    
    let leftSideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let rightSideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var subtitle: String = {
        let subtitle = ""
        return subtitle
    }()
    
    let subtitleSize: CGFloat = 20
    let stepsSize: CGFloat = 15
    
    var subtitleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var checkImage: UIImageView = {
        var label = UIImageView()
        label.image = UIImage(named: "check-icon")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var stepsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var steps: [String] = {
        let steps = ["a"]
        return steps
    }()
    
    var content: Content? {
        didSet {
            subtitleLabel.attributedText = (content?.subtitle)!.convertToNSAtrributredString(size: subtitleSize, color: .black)
            stepsLabel.attributedText = NSAttributedStringHelper.createBulletedList(fromStringArray: (content?.content)!, font: UIFont.systemFont(ofSize: stepsSize))
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
//        self.backgroundColor = .green
        setupSections()
        setupContent()
    }
    
    func setupSections() {
        self.addSubview(leftSideView)
        self.addSubview(rightSideView)
        leftSideView.topAnchor.constraint(equalTo: self.safeTopAnchor).isActive = true
        leftSideView.leadingAnchor.constraint(equalTo: self.safeLeadingAnchor).isActive = true
        leftSideView.bottomAnchor.constraint(equalTo: self.safeBottomAnchor).isActive = true
        
        rightSideView.topAnchor.constraint(equalTo: self.safeTopAnchor).isActive = true
        rightSideView.trailingAnchor.constraint(equalTo: self.safeTrailingAnchor).isActive = true
        rightSideView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        leftSideView.trailingAnchor.constraint(equalTo: rightSideView.leadingAnchor).isActive = true
        
        leftSideView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        
//        leftSideView.backgroundColor = .gray
        rightSideView.backgroundColor = .white
    }
    
    private func setupContent() {
        leftSideView.addSubview(subtitleLabel)
        rightSideView.addSubview(stepsLabel)
        
        subtitleLabel.attributedText = "What to do".convertToNSAtrributredString(size: subtitleSize, color: .black)
        let stringArray = ["first row", "second row", "third row"]
        stepsLabel.attributedText = NSAttributedStringHelper.createBulletedList(fromStringArray: stringArray, font: UIFont(name: "Helvetica", size: stepsSize))
        
//        subtitleLabel.backgroundColor = .green
        subtitleLabel.topAnchor.constraint(equalTo: leftSideView.topAnchor).isActive = true
        subtitleLabel.heightAnchor.constraint(equalTo: leftSideView.heightAnchor, multiplier: 1).isActive = true
        subtitleLabel.widthAnchor.constraint(equalTo: leftSideView.widthAnchor, multiplier: 1).isActive = true
        subtitleLabel.centerXAnchor.constraint(equalTo: leftSideView.centerXAnchor).isActive = true
        subtitleLabel.centerYAnchor.constraint(equalTo: leftSideView.centerYAnchor).isActive = true
        
        stepsLabel.heightAnchor.constraint(equalTo: rightSideView.heightAnchor, multiplier: 1).isActive = true
        stepsLabel.widthAnchor.constraint(equalTo: rightSideView.widthAnchor, multiplier: 1).isActive = true
        stepsLabel.centerXAnchor.constraint(equalTo: rightSideView.centerXAnchor).isActive = true
        stepsLabel.centerYAnchor.constraint(equalTo: rightSideView.centerYAnchor).isActive = true
    }
    
}
