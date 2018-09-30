//
//  GenderController.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/23/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class GenderController: UIViewController {
    
    
    let appNameLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = "Fitness".convertToNSAtrributredString(size: 70, color: .black)
        return label
    }()
    
    let maleLabel: UIButton = {
        let maleOption = UIButton()
//        maleOption.backgroundColor = .white
        maleOption.translatesAutoresizingMaskIntoConstraints = false
        maleOption.setAttributedTitle("Male".convertToNSAtrributredString(size: 40, color: .white), for: .normal)
        return maleOption
    }()
    
    let femaleLabel: UIButton = {
        let femaleOption = UIButton()
//        femaleOption.backgroundColor = .white
        femaleOption.translatesAutoresizingMaskIntoConstraints = false
        femaleOption.setAttributedTitle("Female".convertToNSAtrributredString(size: 40, color: .white), for: .normal)
        return femaleOption
    }()
    
    let topImageContainerView = UIView()
    let bottomImageContainerView = UIView()
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        setupBackground()
        setupAppNameLabel()
        setupMaleButton()
        setupFemaleButton()
    }
    
    private func setupBackground() {
        // screen width and height:
        
        let imageViewBackground = UIImageView(frame: CGRect.zero)
        imageViewBackground.image = UIImage(named: "home")
        
        view.addSubview(imageViewBackground)
        view.sendSubviewToBack(imageViewBackground)
        
        imageViewBackground.translatesAutoresizingMaskIntoConstraints = false
        imageViewBackground.contentMode = .scaleAspectFill
        imageViewBackground.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        imageViewBackground.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        imageViewBackground.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        imageViewBackground.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
    }
    
    private func setupAppNameLabel() {
//        topImageContainerView.backgroundColor = .blue
        self.view.addSubview(topImageContainerView)
        
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        topImageContainerView.topAnchor.constraint(equalTo: self.view.safeTopAnchor).isActive = true
        topImageContainerView.leadingAnchor.constraint(equalTo: self.view.safeLeadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor).isActive = true
        topImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/7).isActive = true
        
        topImageContainerView.addSubview(appNameLabel)
        
        appNameLabel.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        appNameLabel.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
//        appNameLabel.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.5).isActive = true
        
    }
    
    private func setupMaleButton() {
        // male button in bottom third, left half of width, center
//        bottomImageContainerView.backgroundColor = .red
        self.view.addSubview(bottomImageContainerView)
        
        bottomImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomImageContainerView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        bottomImageContainerView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        bottomImageContainerView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        bottomImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/7).isActive = true
        
        bottomImageContainerView.addSubview(maleLabel)
        
        maleLabel.topAnchor.constraint(equalTo: bottomImageContainerView.topAnchor).isActive = true
        print(bottomImageContainerView.frame.height)
        print(maleLabel.frame.height)
        print((screenHeight-maleLabel.frame.height)/2)
        maleLabel.leadingAnchor.constraint(equalTo: bottomImageContainerView.leadingAnchor, constant: screenWidth/9).isActive = true
        
        maleLabel.addTarget(self, action: #selector(selectMale(sender:)), for: .touchUpInside)
    }
    
    @objc func selectMale(sender: UIButton!) {
        Defaults.setGender("male")
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupFemaleButton() {
        // male button in bottom third, left half of width, center
        bottomImageContainerView.addSubview(femaleLabel)
        
        femaleLabel.topAnchor.constraint(equalTo: bottomImageContainerView.topAnchor).isActive = true
        femaleLabel.trailingAnchor.constraint(equalTo: bottomImageContainerView.trailingAnchor, constant: -1*screenWidth/9).isActive = true
        
        femaleLabel.addTarget(self, action: #selector(selectFemale(sender:)), for: .touchUpInside)
    }
    
    @objc func selectFemale(sender: UIButton!) {
        Defaults.setGender("female")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
