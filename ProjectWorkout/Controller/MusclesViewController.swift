//
//  ViewController.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/10/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import UIKit


class MusclesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let searchBar = UISearchBar()
    let pageLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var muscles: [Muscle] = {
        var male_arms = Muscle(imageFileName: "male_arms", muscleName: "Arms")
        var male_chest = Muscle(imageFileName: "male_chest", muscleName: "Chest")
        var male_legs = Muscle(imageFileName: "male_legs", muscleName: "Legs")
        var male_back = Muscle(imageFileName: "male_back", muscleName: "Back")
        var male_shoudlers = Muscle(imageFileName: "male_shoulders", muscleName: "Shoulders")
        return [male_arms, male_chest, male_back, male_back, male_shoudlers]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.isTranslucent = false
        
        collectionView?.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        collectionView?.contentInsetAdjustmentBehavior = .always
        collectionView?.insetsLayoutMarginsFromSafeArea = true
        
        // register videocell as our cells for our collectionview
        collectionView?.register(MuscleCell.self, forCellWithReuseIdentifier: "cellId")
        
        setupSearchBar()
             
    }
    
    
    
    private func setupSearchBar() {
//        let image = UIImage(named: "search_icon")
//
//        let searchButton = UIButton(type: .custom)
//        searchButton.setImage(image, for: .normal)
//        searchButton.addTarget(self, action: #selector(MusclesViewController.handleSearch), for: .touchUpInside)
//
//        let searchButtonItem = UIBarButtonItem(customView: searchButton)
//        NSLayoutConstraint.activate([searchButtonItem.customView!.widthAnchor.constraint(equalToConstant: 40),
//                                    searchButtonItem.customView!.heightAnchor.constraint(equalToConstant: 40)])
//
//        navigationItem.leftBarButtonItems = [searchButtonItem]
        
        searchBar.placeholder = "Search Workouts"
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        hideKeyboardWhenTappedAround()
    }
    
    private func setupPageLabel() {
        pageLabel.text = "Muscle Groups"
        pageLabel.textColor = .white
    }
    
    // MARK: UICollectionView override delegation methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return muscles.count // 5 items for now, base off Model later
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MuscleCell
        
        cell.muscle = muscles[indexPath.item]
        
        return cell
    }
    
    
    // define size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // conform to 16 by 9 standard. subtract left and right padding
        var height = (view.frame.width - 57 - 57) * 9 / 16
        // also add the height of pixel padding from top of each cell
        height += 25
        return CGSize(width: view.frame.width, height: height)
    }
    
    // remove extra pixel padding between each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    // MARK: Hide navigation bar on this viewcontroller
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        navigationController?.setNavigationBarHidden(true, animated: animated)
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        navigationController?.setNavigationBarHidden(false, animated: animated)
    //    }
}
