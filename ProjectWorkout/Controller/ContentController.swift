//
//  ContentController.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/23/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class ContentController: UIViewController {
    
    let scrollView = UIScrollView()
    let pageLabel = UILabel()
    let videoView = UIView()
    
    override func viewDidLoad() {
        
        setupScrollView()
        setupPageLabel()
        setupMoreOptions()
        setupVideo()
    }
    
    private func setupScrollView() {
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = .white
    
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
    }
    
    private func setupPageLabel() {
        
        let text = "Workout"
        pageLabel.attributedText = text.convertToNSAtrributredString(size: CGFloat(38), color: UIColor.black)
        pageLabel.backgroundColor = .white
        pageLabel.sizeToFit()
        navigationItem.titleView = pageLabel
    }
    
    private func setupMoreOptions() {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        let moreOptionsImage = UIImage(named: "more_options")?.withRenderingMode(.alwaysOriginal)
        button.setImage(moreOptionsImage, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.addTarget(self, action: #selector(handleMoreOptions), for: .touchUpInside)
        let moreOptions = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItems = [moreOptions]
    }
    
    
    let settingsLauncher = SettingsLauncher()
    @objc private func handleMoreOptions() {
        settingsLauncher.showSettings()
    }
    
    private func setupVideo() {
        scrollView.addSubview(videoView)
        videoView.backgroundColor = .blue
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        videoView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        videoView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        videoView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        videoView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/4).isActive = true
    }
    
    
}
