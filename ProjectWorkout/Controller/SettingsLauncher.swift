//
//  SettingsLauncher.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/18/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var settingOptions: [Setting] = {
        var male: Setting = Setting(settingOptionName: "Male")
        var female: Setting = Setting(settingOptionName: "Female")
        return [male, female]
    }()
    
    let blackView = UIView()
    
    let settingsView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        //cv.layer.cornerRadius = 10
        return cv
    }()
    
    let cellId = "cellId"
    
    let height: CGFloat = 240
    let width: CGFloat = 170
    var insetFromWindowTop: CGFloat = UIApplication.shared.statusBarFrame.height
    
    func showSettings() {
        if let window = UIApplication.shared.keyWindow {
            // Dim background
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSettings)))
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            blackView.translatesAutoresizingMaskIntoConstraints = false
            blackView.topAnchor.constraint(equalTo: window.safeTopAnchor).isActive = true
            blackView.bottomAnchor.constraint(equalTo: window.safeBottomAnchor).isActive = true
            blackView.trailingAnchor.constraint(equalTo: window.safeTrailingAnchor).isActive = true
            blackView.leadingAnchor.constraint(equalTo: window.safeLeadingAnchor).isActive = true
            
            // Instantiate slide in settings view controller
            window.addSubview(settingsView)
            
//            let width: CGFloat = 150
//            let height: CGFloat = window.frame.height
            
            settingsView.frame = CGRect(x: window.frame.width, y: insetFromWindowTop, width: self.width, height: window.frame.height)
            
            // Recognize swipe gesture to close window
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            rightSwipe.direction = .right
            window.addGestureRecognizer(rightSwipe)
//            self.settingsView.translatesAutoresizingMaskIntoConstraints = false
//            self.settingsView.widthAnchor.constraint(equalToConstant: width).isActive = true
//            self.settingsView.heightAnchor.constraint(equalToConstant: height).isActive = true
//            self.settingsView.topAnchor.constraint(equalTo: window.safeTopAnchor, constant: 0).isActive = true
//            self.settingsView.trailingAnchor.constraint(equalTo: window.safeTrailingAnchor, constant: width).isActive = true
            
//            let y = window.frame.height - height
//            settingsView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            // Dim background and slide in vc
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.settingsView.frame = CGRect(x: window.frame.width - self.width, y: self.insetFromWindowTop, width: self.width, height: window.frame.height)
                
//                self.settingsView.trailingAnchor.constraint(equalTo: window.safeTrailingAnchor, constant: 0).isActive = true
                
//                self.settingsView.frame = CGRect(x: 0, y: y, width: self.settingsView.frame.width, height: self.settingsView.frame.height)
            }, completion: nil)
        }
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .left) {
            print("Swipe Left")
        }
        
        if (sender.direction == .right) {
            print("Swipe Right")
            dismissSettings()
        }
    }
    
    @objc private func dismissSettings() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.settingsView.frame = CGRect(x: window.frame.width, y: self.insetFromWindowTop, width: self.settingsView.frame.width, height: window.frame.height)
                
//                self.settingsView.frame = CGRect(x: 0, y: window.frame.height, width: self.settingsView.frame.width, height: self.settingsView.frame.height)
                
//                self.settingsView.trailingAnchor.constraint(equalTo: window.safeTrailingAnchor, constant: self.width).isActive = true
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = settingsView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
        cell.settingsOption = settingOptions[indexPath.item]
        return cell
    }
    
    // define size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = settingsView.frame.height / CGFloat(settingOptions.count)
        return CGSize(width: self.settingsView.frame.width, height: height)
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//
//        collectionView?.collectionViewLayout.invalidateLayout()
//
//    }
    
//    init(valueFromWindowTop: CGFloat) {
//        insetFromWindowTop = valueFromWindowTop
//    }
    
    override init() {
        super.init()
        
        settingsView.delegate = self
        settingsView.dataSource = self
        
        settingsView.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
    }
}
