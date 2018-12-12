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
import Firebase

class ContentController: UIViewController {
    
    // workout variable
    var workout: NSManagedObject?
    
    private let kSeparatorId = 123
    private let kSeparatorHeight: CGFloat = 1.5
    let brightYellow = UIColor.rgb(red: 255, green: 255, blue: 0)
    let darkGray = UIColor.rgb(red: 61, green: 61, blue: 56).withAlphaComponent(0.55)
    let lightGray = UIColor.rgb(red: 183, green: 183, blue: 176)
    
    let scrollView = UIScrollView()
    let pageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var videoView: UIView!
    weak var tableView: UITableView!
    lazy var content: [Content] = {
        var content = Json.parseFile(muscleSubgroup: self.muscleSubgroup, specificWorkout: self.specificWorkoutName)
        return content
    }()
    
    fileprivate var videoHeightV: NSLayoutConstraint?
    fileprivate var videoHeightL: NSLayoutConstraint?
    
    override func viewDidLoad() {

        setupMoreOptionsButton()
        setupVideo()
        setupPageLabel()
        setupTableView()
        setupFavButton()
        
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
        videoView = UIView()
        view.addSubview(videoView)
        videoView.backgroundColor = .black
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        videoHeightV = videoView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16)
        videoHeightL = videoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1)
        
        let workoutName = firebaseURL + ".mp4"
        
        let storage = Storage.storage()
        
        // Create a reference from a Google Cloud Storage URI
        let gsReference = storage.reference(forURL: "gs://projectworkout-84fca.appspot.com")
        
        // Create a reference to the file you want to download
        //        let starsRef = gsReference.child("male_decline_barbell_bench_press.mp4")
        let starsRef = gsReference.child(workoutName)
        // Fetch the download URL
        starsRef.downloadURL(completion: { url, error in
            if let error = error {
                // Handle any errors
                print("ERROR \(error)")
                return
            } else {
                // Get the download URL for 'images/stars.jpg'
                print("download URL retrieved \(url!)")
                let player = AVPlayer(url: url!)
                self.playerController = AVPlayerViewController()
                self.playerController?.player = player
                player.isMuted = true
                player.play()
                
                self.playerController?.view.frame = self.videoView.bounds
                self.addChild(self.playerController!)
                self.videoView.addSubview((self.playerController?.view)!)
                self.playerController?.didMove(toParent: self)
            }
        })
        
        if UIDevice.current.orientation.isLandscape {
            videoHeightL?.isActive = true
            navigationController?.navigationBar.isHidden = true
        } else {
            videoHeightV?.isActive = true
            navigationController?.navigationBar.isHidden = false
        }
        
    }
    
    lazy var specificWorkoutName = self.workout?.value(forKey: "displayName") as? String ?? ""
    lazy var muscleSubgroup = self.workout?.value(forKey: "subgroup") as? String ?? ""
    lazy var videoLink = self.workout?.value(forKey: "videoLink") as? String ?? ""
    lazy var muscleGroup = self.workout?.value(forKey: "muscleGroup") as? String ?? ""
    lazy var hasFavorited = self.workout?.value(forKey: "hasFavorited") as? String ?? "FALSE"
    lazy var firebaseURL = self.workout?.value(forKey: "imageName") as? String ?? "FALSE"
    
    // Button represented as UIImageview
    let favoriteButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        return button
    }()
    
    @objc func favoriteCell(_ sender: UIButton) {
        let isCurFavorited = self.workout?.value(forKey: "hasFavorited") as? String ?? "FALSE"
        
        // update favorited data
        if isCurFavorited == "TRUE" {
            CoreData.updateFavoriteData(workout: self.workout!, to: "FALSE")
        } else if isCurFavorited == "FALSE" {
            CoreData.updateFavoriteData(workout: self.workout!, to: "TRUE")
        }
        
        // switch the color of the favorited cell upon click
        sender.tintColor = isCurFavorited == "TRUE" ? UIColor.darkGray.withAlphaComponent(0.55) : brightYellow
    }
    
    private func setupFavButton() {
        favoriteButton.setImage(UIImage(named: "fav_star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        favoriteButton.addTarget(self, action: #selector(favoriteCell(_:)), for: .touchUpInside)
        favoriteButton.backgroundColor = .clear
        if hasFavorited == "FALSE" {
            favoriteButton.tintColor = UIColor.darkGray.withAlphaComponent(0.55)
        } else {
            favoriteButton.tintColor = brightYellow
        }
        self.navigationItem.titleView = favoriteButton
    }
    
    private func setupPageLabel() {
        
//        let text = specificWorkoutName + " - " + muscleSubgroup
        let text = specificWorkoutName
        let size = CGFloat(27)
        pageLabel.attributedText = text.convertToNSAtrributredString(size: size, color: UIColor.black)
        pageLabel.backgroundColor = UIColor.rgb(red: 191, green: 192, blue: 193)
        pageLabel.textAlignment = .center
        pageLabel.lineBreakMode = .byWordWrapping
        pageLabel.numberOfLines = 0
        view.addSubview(pageLabel)
        pageLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor).isActive = true
        pageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        pageLabel.sizeToFit()
        pageLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        pageLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        
        if pageLabel.viewWithTag(kSeparatorId) == nil //add separator only once
        {
            let separatorView = UIView(frame: CGRect(x: 0, y: pageLabel.frame.height - kSeparatorHeight, width: pageLabel.frame.width, height: kSeparatorHeight))
            separatorView.tag = kSeparatorId
            separatorView.backgroundColor = UIColor.rgb(red: 191, green: 192, blue: 193)
            separatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            pageLabel.addSubview(separatorView)
        }

    }
    
    private func setupTableView() {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        // Connect table view to separator line
        tableView.topAnchor.constraint(equalTo: pageLabel.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.rgb(red: 191, green: 192, blue: 193)
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        
        // Assign created tableview to our tableview var
        self.tableView = tableView
        self.tableView.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(ContentCell.self, forCellReuseIdentifier: "cellId")
    }
    
    private func setupMoreOptionsButton() {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.rgb(red: 191, green: 192, blue: 193)
        button.translatesAutoresizingMaskIntoConstraints = false
        let moreOptionsImage = UIImage(named: "hamburger")
        button.setImage(moreOptionsImage, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.addTarget(self, action: #selector(handleMoreOptions), for: .touchUpInside)
        let moreOptions = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItems = [moreOptions]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to \(muscleGroup)", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    
    @objc private func handleMoreOptions() {
        (UIApplication.shared.keyWindow?.rootViewController as? BaseSlidingController)?.openMenu()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        collectionView.collectionViewLayout.invalidateLayout()
        
    }
        
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.current.orientation.isLandscape {
            videoHeightV?.isActive = false
            videoHeightL?.isActive = true
            navigationController?.navigationBar.isHidden = true
        } else {
            videoHeightL?.isActive = false
            videoHeightV?.isActive = true
            navigationController?.navigationBar.isHidden = false
        }
        
    }
}

extension ContentController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? ContentCell else {
            fatalError("Misconfigured cell type, \(tableView)!")
        }
        cell.content = content[indexPath.row]
        
        // Add separator only once
        if cell.viewWithTag(kSeparatorId) == nil {
            let separatorView = UIView(frame: CGRect(x: 0, y: cell.frame.height - kSeparatorHeight, width: cell.frame.width, height: kSeparatorHeight))
            separatorView.tag = kSeparatorId
            separatorView.backgroundColor = UIColor.rgb(red: 191, green: 192, blue: 193)
            separatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            cell.addSubview(separatorView)
        }
        
        return cell
    }
}

extension ContentController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var numOfChars = 0
        for sentence in content[indexPath.row].content! {
            numOfChars += sentence.count + 75
        }
        let numOfLines = numOfChars / 30
        // Every 2 lines amounts to 30 pixels in height
        var height = (numOfLines/2) * 30
        
        // Add extra space to Do NOT section
        if content[indexPath.row].subtitle == "Do NOT" {
            height += 15
        }
        
        return CGFloat(height)
    }
}
