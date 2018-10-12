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
    let pageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let videoView = UIView()
    weak var collectionView: UICollectionView!
    var content: [ContentCell] = []
    
    fileprivate var videoHeightV: NSLayoutConstraint?
    fileprivate var videoHeightL: NSLayoutConstraint?
    
    override func viewDidLoad() {
        
//        setupScrollView()
//        setupMoreOptions()
        setupPageLabel()
        setupVideo()
//        setupPageLabel()
        setupCollectionView()
        
        
        view.backgroundColor = .white
        
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
    
    private func setupVideo() {
        view.addSubview(videoView)
        videoView.backgroundColor = .blue
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
//        videoView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        videoView.topAnchor.constraint(equalTo: pageLabel.bottomAnchor, constant: 5).isActive = true
        videoView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        videoView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        videoHeightV = videoView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16)
        videoHeightL = videoView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16)
        
        if UIDevice.current.orientation.isLandscape {
            //            videoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 9/16).isActive = true
            videoHeightL?.isActive = true
        } else {
            //            videoView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16).isActive = true
            videoHeightV?.isActive = true
        }
        
        
    }
    
    private func setupPageLabel() {
        
        let text = "Incline Bench"
        let size = (navigationController?.navigationBar.frame.height)! - 10
        pageLabel.attributedText = text.convertToNSAtrributredString(size: size, color: UIColor.black)
        pageLabel.backgroundColor = .white
        pageLabel.textAlignment = .center
        view.addSubview(pageLabel)
//        pageLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor).isActive = true
        pageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        pageLabel.sizeToFit()
        pageLabel.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        pageLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        pageLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true

    }
    
    private func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
//        collectionView.topAnchor.constraint(equalTo: pageLabel.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: videoView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        
        self.collectionView = collectionView
        self.collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(ContentCell.self, forCellWithReuseIdentifier: "cellId")
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
    
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            print(self.view.frame.height)
            //            videoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 9/16).isActive = true
            videoHeightV?.isActive = false
            videoHeightL?.isActive = true
        } else {
            print("Vertical")
            print(self.view.frame.width)
            //            videoView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16).isActive = true
            videoHeightL?.isActive = false
            videoHeightV?.isActive = true
        }
        
    }
}

extension ContentController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ContentCell
        
        return cell
    }
    
    
}

extension ContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.width * 9/16
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ContentController: UICollectionViewDelegateFlowLayout {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
        
    }
}
