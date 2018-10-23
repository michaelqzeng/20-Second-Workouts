//
//  ContentController.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/23/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class ContentController: UIViewController {
    
    // video variable
    
    let scrollView = UIScrollView()
    let pageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var videoView = UIView()
    weak var collectionView: UICollectionView!
    var content: [Content] = []
    
    fileprivate var videoHeightV: NSLayoutConstraint?
    fileprivate var videoHeightL: NSLayoutConstraint?
    
    override func viewDidLoad() {
        
        content.append(contentsOf: [Content(subtitle: "What to do", content: ["Grab dumbbells and rotate shoulders externally, so ears and shoulders are aligned.", "Keep shoulders externally rotated and elbows glued to to the side of your body.", "Keep wrists straight as you curl the barbell throughout its full range of motion; up to shoulders and back down to the starting position."]), Content(subtitle: "Common Mistakes", content: ["Step 1", "Step 2", "Step 3"]), Content(subtitle: "What is incline bench", content: ["First invented in 2000", "Good for moving boxes"])])
        
//        setupScrollView()
        setupMoreOptions()
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
        
        let url = Bundle.main.url(forResource: "vid", withExtension: ".mp4")!
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
        
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
        let moreOptionsImage = UIImage(named: "hamburger")
        button.setImage(moreOptionsImage, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.addTarget(self, action: #selector(handleMoreOptions), for: .touchUpInside)
        let moreOptions = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItems = [moreOptions]
    }
    
    @objc private func handleMoreOptions() {
        (UIApplication.shared.keyWindow?.rootViewController as? BaseSlidingController)?.openMenu()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        
        if UIDevice.current.orientation.isLandscape {
//            print("Landscape")
//            print(self.view.frame.height)
            //            videoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 9/16).isActive = true
            videoHeightV?.isActive = false
            videoHeightL?.isActive = true
        } else {
//            print("Vertical")
//            print(self.view.frame.width)
            //            videoView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16).isActive = true
            videoHeightL?.isActive = false
            videoHeightV?.isActive = true
        }
        
    }
}

extension ContentController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? ContentCell else {
            fatalError("Misconfigured cell type, \(collectionView)!")
        }
        cell.content = content[indexPath.row]
//        cell.backgroundColor = .black
//        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 5))
//        cell.addSubview(image)
        return cell
    }
    
}

extension ContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numOfChars = 0
        for sentence in content[indexPath.row].content! {
            numOfChars += sentence.count + 100
        }
        let numOfLines = numOfChars / 30
        print(numOfChars, numOfLines)
        // Every 2 lines amounts to 30 pixels in height
        let height = (numOfLines/2) * 30
//        let height = view.frame.width * 9/16
        print(height)
        return CGSize(width: view.frame.width, height: CGFloat(height))
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
