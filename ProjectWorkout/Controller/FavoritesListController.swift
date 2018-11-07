//
//  FavoritesListController.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 11/2/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoritesListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let brightYellow = UIColor.rgb(red: 255, green: 255, blue: 0)
    let darkGray = UIColor.rgb(red: 61, green: 61, blue: 56)
    let lightGray = UIColor.rgb(red: 183, green: 183, blue: 176)
    
    let pageLabel = UILabel()
    let spaceBetweenTopSafeAreaAndPageLabel = 10
    let pageLabelSize = 38
    let search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Search Favorites"
        search.hidesNavigationBarDuringPresentation = true
        return search
    }()
    
    lazy var muscleGroups: [String] = {
        var muscleGroups: [String] = []
//        retrieveFavoritedWorkoutsMuscleGroups
        if Defaults.getGender() == "male" {
            muscleGroups = CoreData.retrieveFavoritedWorkoutsMuscleGroups(gender: "M")
        } else if Defaults.getGender() == "female" {
            muscleGroups = CoreData.retrieveFavoritedWorkoutsMuscleGroups(gender: "F")
        }
        return muscleGroups
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupSearchBar()
        setupMoreOptions()
        setupPageLabel()
        setupCollectionView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        collectionView?.reloadData()
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = search
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
    
    func favoriteCell(cell: WorkoutCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else {return}
        
        let workout = workouts[indexPath.section][indexPath.item]
        
        let isCurFavorited = workout.value(forKey: "hasFavorited") as? String
        
        // update favorited data
        if isCurFavorited == "TRUE" {
            CoreData.updateFavoriteData(workout: workout, to: "FALSE")
        } else if isCurFavorited == "FALSE" {
            CoreData.updateFavoriteData(workout: workout, to: "TRUE")
        }
        
        // switch the color of the favorited cell upon click
        cell.favoriteImageView.tintColor = isCurFavorited == "TRUE" ? lightGray : brightYellow
        //        print(isCurFavorited)
    }
    
    var muscleType: String?
    
    private func setupPageLabel() {
        let size = (navigationController?.navigationBar.frame.height)! - 10
        if let muscleType = muscleType {
            pageLabel.attributedText = muscleType.convertToNSAtrributredString(size: CGFloat(size), color: UIColor.black)
        } else {
            self.muscleType = "Default"
            pageLabel.attributedText = self.muscleType!.convertToNSAtrributredString(size: CGFloat(size), color: UIColor.black)
        }
        
        pageLabel.backgroundColor = .white
        pageLabel.sizeToFit()
        navigationItem.titleView = pageLabel
    }
    
    private func setupCollectionView() {
        // register videocell as our cells for our collectionview
        collectionView?.register(WorkoutCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.register(ReusableCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        collectionView?.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        collectionView?.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
    }
    
    // MARK: UICollectionView override delegation methods
    
    // Go to selected workout cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let workout = workouts[indexPath.section][indexPath.item]
        print("Selected workout \(workout)")
        let contentVC = ContentController()
        contentVC.workout = workout
        navigationController?.pushViewController(contentVC, animated: true)
    }
    
    // define size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.width * 9/16
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if workouts.isEmpty == false {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
//        collectionView?.collectionViewLayout.invalidateLayout()
        
    }
    
    // remove extra pixel padding between each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    var workouts: [[NSManagedObject]] = []
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //        print("sections.count", sections.count)
        print(muscleGroups)
        return muscleGroups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        print("sections[section].muscle!.count", sections[section].muscle!.count)
        //        return sections[section].muscle!.count
        var count = 0
        var workoutsForSubgroup: [NSManagedObject] = []
        if Defaults.getGender() == "male" {
            workoutsForSubgroup = CoreData.retrieveFavoritedWorkoutsForMuscle(muscle: muscleGroups[section], gender: "M")
        } else if Defaults.getGender() == "female" {
            workoutsForSubgroup = CoreData.retrieveFavoritedWorkoutsForMuscle(muscle: muscleGroups[section], gender: "F")
        }
        workouts.append(workoutsForSubgroup)
        count = workoutsForSubgroup.count
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? WorkoutCell else {
            fatalError("Misconfigured cell type, \(collectionView)!")
        }
        cell.favoritesListLink = self
        
        let workout = workouts[indexPath.section][indexPath.item]
        cell.displayName = workout.value(forKeyPath: "displayName") as? String
        cell.imageName = workout.value(forKeyPath: "imageName") as? String
        cell.hasFavorited = workout.value(forKey: "hasFavorited") as? String
        //        print(cell.displayName!)
        //        print(workout.hasFavorited!)
        
        return cell
    }
    
    // MARK: Section Header View
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? ReusableCollectionView else {
            fatalError("Misconfigured cell type, \(collectionView)!")
        }
        //        let subgroup = "  " + sections[indexPath.section].subgroup!
        let subgroup = "  " + muscleGroups[indexPath.section]
        
        sectionHeaderView.headerLabel.attributedText = subgroup.convertToNSAtrributredString(size: 20, color: .black)
        //        print(subgroup)
        
        return sectionHeaderView
    }
}
