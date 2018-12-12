//
//  WorkoutListController.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/23/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class WorkoutListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // List of workouts for the given muscle
    var workouts: [[NSManagedObject]] = []
    // Duplicate list of workouts that we will search upon
    var searchableWorkouts: [NSManagedObject] = []
    // Stores filtered workouts based on search text
    var filteredWorkouts = [NSManagedObject]()
    // Stores the selected muscle type for this workout list
    var muscleType: String?
    // Subgroups for the given muscle
    lazy var subgroups: [String] = {
        var subgroups: [String] = []
        if Defaults.getGender() == "male" {
            subgroups = CoreData.retrieveWorkoutSubgroups(for: self.muscleType ?? "Arms", gender: "M") // insert default value here later
        } else if Defaults.getGender() == "female" {
            subgroups = CoreData.retrieveWorkoutSubgroups(for: self.muscleType ?? "Arms", gender: "F") // insert default value here later
        }
        return subgroups
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
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            // Handles search bar appearing upon first loading view
            navigationItem.hidesSearchBarWhenScrolling =  false
        }
        // Ensure pageLabel does not glitch size
        pageLabel.sizeToFit()
        // Handles horizontal view rotation
        collectionView.collectionViewLayout.invalidateLayout()
        // Reloads data every time view is about to appear
        collectionView?.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            // Handles search bar appearing upon first loading view
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if workouts.isEmpty == false {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    func favoriteCell(cell: WorkoutCell) {
        // Grab favorited cell
        guard let indexPath = collectionView?.indexPath(for: cell) else {return}
        let workout: NSManagedObject
        if isFiltering() {
            workout = filteredWorkouts[indexPath.row]
        } else {
            workout = workouts[indexPath.section][indexPath.item]
        }

        // Update favorited data
        let isCurFavorited = workout.value(forKey: "hasFavorited") as? String
        if isCurFavorited == "TRUE" {
            CoreData.updateFavoriteData(workout: workout, to: "FALSE")
        } else if isCurFavorited == "FALSE" {
            CoreData.updateFavoriteData(workout: workout, to: "TRUE")
        }

        // Switch the color of the favorited cell upon click
        let brightYellow = UIColor.rgb(red: 255, green: 255, blue: 0)
        let lightGray = UIColor.rgb(red: 183, green: 183, blue: 176)
        cell.favoriteImageView.tintColor = isCurFavorited == "TRUE" ? lightGray : brightYellow
    }

    // MARK: Navigation Bar
    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: Search Controller
    let search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.hidesNavigationBarDuringPresentation = true
        return search
    }()
    
    private func setupSearchBar() {
        search.searchBar.placeholder = "Search \(self.muscleType ?? "") Workouts"
        search.obscuresBackgroundDuringPresentation = false
        search.searchResultsUpdater = self
        self.definesPresentationContext = true
        
        // Make search text box white
        if #available(iOS 11.0, *) {
            let scb = search.searchBar
            scb.tintColor = UIColor.white
            scb.barTintColor = UIColor.white
                        
            if let textfield = scb.value(forKey: "searchField") as? UITextField {
                // Set text color
                if let backgroundview = textfield.subviews.first {
                    // Background color
                    backgroundview.backgroundColor = UIColor.white
                    // Rounded corner
                    backgroundview.layer.cornerRadius = 10
                    backgroundview.clipsToBounds = true
                }
            }
            navigationItem.searchController = search
        } else {
            search.searchBar.backgroundColor = UIColor.white
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return search.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String) {
        // Reset upon each new search text
        filteredWorkouts = []
        // Filter by searched text
        filteredWorkouts = searchableWorkouts.filter({( workout: NSManagedObject) -> Bool in
            let temp = workout.value(forKey: "displayName") as? String ?? ""
            return temp.lowercased().contains(searchText.lowercased())
        })
        // Reload text to reflect searched text live
        collectionView?.reloadData()
    }
    
    func isFiltering() -> Bool {
        return search.isActive && !searchBarIsEmpty()
    }
    
    // MARK: Options Button
    private func setupMoreOptions() {
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
    }

    @objc private func handleMoreOptions() {
        (UIApplication.shared.keyWindow?.rootViewController as? BaseSlidingController)?.openMenu()
    }
    
    // MARK: Page Label
    let pageLabel = UILabel()
    private func setupPageLabel() {
        let size = (navigationController?.navigationBar.frame.height)! - 10
        if let muscleType = muscleType {
            pageLabel.attributedText = muscleType.convertToNSAtrributredString(size: CGFloat(size), color: UIColor.black)
        } else {
            self.muscleType = "Default"
            pageLabel.attributedText = self.muscleType!.convertToNSAtrributredString(size: CGFloat(size), color: UIColor.black)
        }
        pageLabel.sizeToFit()
        navigationItem.titleView = pageLabel
    }

    // MARK: Collection View
    private func setupCollectionView() {
        // Register WorkoutCell as our cells for our collectionview
        collectionView?.register(WorkoutCell.self, forCellWithReuseIdentifier: "cellId")
        // Register our header cells as ReusableCollectionView
        collectionView?.register(ReusableCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        // White background color for collectionview
        collectionView?.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        collectionView?.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
    }
    
    // MARK: Collection View Override Delegation Methods
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Change the back button look
        let backItem = UIBarButtonItem()
        backItem.title = "\(muscleType ?? "Muscle") "
        navigationItem.backBarButtonItem = backItem
        
        // Grab selected workout object
        let workout: NSManagedObject
        if isFiltering() {
            workout = filteredWorkouts[indexPath.row]
        } else {
            workout = workouts[indexPath.section][indexPath.item]
        }
        
        // Open content controller based off selected workout
        let contentVC = ContentController()
        contentVC.workout = workout
        navigationController?.pushViewController(contentVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Define size of each cell. Adhere to 9x16 rule
        let height = view.frame.width * 9/16
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Remove extra pixels between cells
        return 0
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isFiltering() {
            return 1
        }
        // Reset previously filtered workouts
        searchableWorkouts = []
        return subgroups.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredWorkouts.count
        } else {
            var count = 0
            var workoutsForSubgroup: [NSManagedObject] = []
            if Defaults.getGender() == "male" {
                workoutsForSubgroup = CoreData.retrieveWorkoutsForSubgroup(subgroup: subgroups[section], gender: "M")
            } else if Defaults.getGender() == "female" {
                workoutsForSubgroup = CoreData.retrieveWorkoutsForSubgroup(subgroup: subgroups[section], gender: "F")
            }
            // If we have a new section to add
            if section > workouts.count - 1 {
                workouts.append(workoutsForSubgroup)
                searchableWorkouts.append(contentsOf: workoutsForSubgroup)
            } else {
                // Otherwise, we are updating an existing section
                workouts[section] = workoutsForSubgroup
                for item in workoutsForSubgroup {
                    if !searchableWorkouts.contains(item) {
                        searchableWorkouts.append(item)
                    }
                }
            }
            
            count = workoutsForSubgroup.count
            print(workouts.count)
            print(searchableWorkouts.count)
            return count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? WorkoutCell else {
            fatalError("Misconfigured cell type, \(collectionView)!")
        }
        cell.link = self
        
        let workout: NSManagedObject
        if isFiltering() {
            workout = filteredWorkouts[indexPath.item]
        } else {
            workout = workouts[indexPath.section][indexPath.item]
        }
        cell.displayName = workout.value(forKeyPath: "displayName") as? String
        cell.imageName = workout.value(forKeyPath: "imageName") as? String
        cell.hasFavorited = workout.value(forKey: "hasFavorited") as? String
        
        return cell
    }

    // MARK: Section Header View
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? ReusableCollectionView else {
            fatalError("Misconfigured cell type, \(collectionView)!")
        }
        if isFiltering() {
            sectionHeaderView.headerLabel.attributedText = "  Result".convertToNSAtrributredString(size: 25, color: .black)
        } else {
            let subgroup = "  " + subgroups[indexPath.section]
            
            sectionHeaderView.headerLabel.attributedText = subgroup.convertToNSAtrributredString(size: 25, color: .black)
        }
        return sectionHeaderView
    }
}

extension WorkoutListController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
