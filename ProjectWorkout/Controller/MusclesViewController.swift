//
//  ViewController.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/10/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import UIKit


class MusclesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.hidesBarsOnSwipe = true
        
        collectionView?.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        collectionView?.contentInsetAdjustmentBehavior = .always
        collectionView?.insetsLayoutMarginsFromSafeArea = true
        
        // register videocell as our cells for our collectionview
        collectionView?.register(MuscleCell.self, forCellWithReuseIdentifier: "cellId")
        
        setupSearchBar()
        
//        // move collection view under the bar. push it 50 pixels down
//        collectionView?.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
//        // move scroll view under the bar as well, 50 pixels down
//        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(25, 0, 0, 0)
    }
    
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil) // display results in our homecontroller
        searchController.searchResultsUpdater = self // allows homecontroller class to be informed as text changes within uisearchbar
        searchController.obscuresBackgroundDuringPresentation = false // do not obscure current view when showing results
        searchController.searchBar.placeholder = "Search Workouts"
        searchController.searchBar.sizeToFit()

        navigationItem.searchController = searchController
        definesPresentationContext = true // ensure search bar does not remain on screen if user navigates to another view controller while uisearchcontroller is active
        searchController.hidesNavigationBarDuringPresentation = true
//        let searchBar = UISearchBar()
//        navigationItem.titleView = searchController.searchBar
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
    
    
    
    // MARK: UICollectionView override delegation methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 // 5 items for now, base off Model later
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
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
}
