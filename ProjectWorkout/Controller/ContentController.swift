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
import CoreData
import WebKit

class ContentController: UIViewController {
    
    // workout variable
    var workout: NSManagedObject?
    
    let scrollView = UIScrollView()
    let pageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
//    var videoView = UIView()
//    var videoView = UIWebView()
    var videoView: WKWebView!
    weak var collectionView: UICollectionView!
    var content: [Content] = []
    
    fileprivate var videoHeightV: NSLayoutConstraint?
    fileprivate var videoHeightL: NSLayoutConstraint?
    
    override func viewDidLoad() {
        
        content.append(contentsOf: [Content(subtitle: "What to do", content: ["Grab dumbbells and rotate shoulders externally, so ears and shoulders are aligned.", "Keep shoulders externally rotated and elbows glued to to the side of your body.", "Keep wrists straight as you curl the barbell throughout its full range of motion; up to shoulders and back down to the starting position."]), Content(subtitle: "Common Mistakes", content: ["Step 1", "Step 2", "Step 3"]), Content(subtitle: "What is incline bench", content: ["First invented in 2000", "Good for moving boxes"])])
        
//        setupScrollView()
        setupMoreOptions()
//        setupPageLabel()
        setupVideo()
        setupPageLabel()
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
    
    var playerController: AVPlayerViewController?
    
    private func setupVideo() {
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true
        videoView = WKWebView(frame: CGRect.zero, configuration: webViewConfiguration)
        let myURL = URL(string: "https://www.youtube.com/embed/Swqye9QIKTs?playsinline=1")
        let youtubeRequest = URLRequest(url: myURL!)
        
        view.addSubview(videoView)
        videoView.backgroundColor = .black
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
//        videoView.topAnchor.constraint(equalTo: pageLabel.bottomAnchor, constant: 5).isActive = true
        videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        videoHeightV = videoView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16)
        videoHeightL = videoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1)
        
        videoView.load(youtubeRequest)
        
//        let url = NSURL(string: "https://firebasestorage.googleapis.com/v0/b/projectworkout-84fca.appspot.com/o/Male%2FArms%2FBicep%2FMale%20-%20Arms%20-%20Barbell%20Bicep%20Curl.MOV?alt=media&token=adad6c23-11e5-42eb-9e8a-b8cc2aa0aaa6")
//        let player = AVPlayer(url: url! as URL)
//        playerController = AVPlayerViewController()
//        playerController?.player = player
//        player.isMuted = true
//        playerController?.view.frame = videoView.bounds
//        self.addChild(playerController!)
//        videoView.addSubview((playerController?.view)!)
//        playerController?.didMove(toParent: self)

//        let url = "https://www.youtube.com/embed/Swqye9QIKTs"
//        let width = view.frame.width
//        let height = view.frame.height
//        print("height ", height, "width ", width)
//        let embedHTML = "<html><body><iframe src=\"\(url)?playsinline=1\" width=\"'\(width)'\" height=\"'\(height*9/16)'\" allowfullscreen></iframe></body></html>"
//        videoView.allowsInlineMediaPlayback = true
//        videoView.loadHTMLString(embedHTML, baseURL: Bundle.main.bundleURL)
//        videoView.scrollView.isScrollEnabled = false
        
        if UIDevice.current.orientation.isLandscape {
            //            videoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 9/16).isActive = true
            videoHeightL?.isActive = true
            navigationController?.navigationBar.isHidden = true
        } else {
            //            videoView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16).isActive = true
            videoHeightV?.isActive = true
            navigationController?.navigationBar.isHidden = false
        }
        
    }
    
    private func setupPageLabel() {
        
        let name = self.workout?.value(forKey: "displayName") as? String ?? ""
        let subgroup = self.workout?.value(forKey: "subgroup") as? String ?? ""
        let text = name + "  ||  " + subgroup
//        let size = (navigationController?.navigationBar.frame.height)! - 10
        let size = CGFloat(20)
        pageLabel.attributedText = text.convertToNSAtrributredString(size: size, color: UIColor.black)
        pageLabel.backgroundColor = .white
        pageLabel.textAlignment = .center
        view.addSubview(pageLabel)
        pageLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor).isActive = true
        pageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        pageLabel.sizeToFit()
//        pageLabel.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        pageLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        pageLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true

    }
    
    private func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: pageLabel.bottomAnchor).isActive = true
//        collectionView.topAnchor.constraint(equalTo: videoView.bottomAnchor).isActive = true
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        collectionView.collectionViewLayout.invalidateLayout()
        
        if UIDevice.current.orientation.isLandscape {
//            print("Landscape")
//            print(self.view.frame.height)
            //            videoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 9/16).isActive = true
            videoHeightV?.isActive = false
            videoHeightL?.isActive = true
            navigationController?.navigationBar.isHidden = true
        } else {
//            print("Vertical")
//            print(self.view.frame.width)
            //            videoView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16).isActive = true
            videoHeightL?.isActive = false
            videoHeightV?.isActive = true
            navigationController?.navigationBar.isHidden = false
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
//        print(numOfChars, numOfLines)
        // Every 2 lines amounts to 30 pixels in height
        let height = (numOfLines/2) * 30
//        let height = view.frame.width * 9/16
//        print(height)
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
