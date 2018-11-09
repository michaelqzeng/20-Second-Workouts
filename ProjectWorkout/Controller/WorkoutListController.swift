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
    
    let brightYellow = UIColor.rgb(red: 255, green: 255, blue: 0)
    let darkGray = UIColor.rgb(red: 61, green: 61, blue: 56)
    let lightGray = UIColor.rgb(red: 183, green: 183, blue: 176)
    
    let pageLabel = UILabel()
    let spaceBetweenTopSafeAreaAndPageLabel = 10
    let pageLabelSize = 38
    let search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
//        search.hidesNavigationBarDuringPresentation = true
        return search
    }()
    
    lazy var subgroups: [String] = {
        var subgroups = CoreData.retrieveWorkoutSubgroups(for: self.muscleType ?? "Arms") // insert default value here later
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
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        collectionView?.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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

    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = false
    }

    private func setupSearchBar() {
        navigationItem.searchController = search
        search.searchBar.placeholder = "Search \(self.muscleType ?? "") Workouts"
        search.obscuresBackgroundDuringPresentation = false
        search.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return search.searchBar.text?.isEmpty ?? true
    }

    var filteredWorkouts = [NSManagedObject]()

    func filterContentForSearchText(_ searchText: String) {
        filteredWorkouts = searchableWorkouts.filter({( workout: NSManagedObject) -> Bool in
            let temp = workout.value(forKey: "displayName") as? String ?? ""
//            print(temp)
            return temp.lowercased().contains(searchText.lowercased())
        })
//        print(filteredWorkouts)
        collectionView?.reloadData()
    }
    
    func isFiltering() -> Bool {
        print(search.isActive && !searchBarIsEmpty())
        return search.isActive && !searchBarIsEmpty()
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
        let workout: NSManagedObject
        
        if isFiltering() {
            workout = searchableWorkouts[indexPath.row]
        } else {
            workout = workouts[indexPath.section][indexPath.item]
        }
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
    var searchableWorkouts: [NSManagedObject] = []
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        print("sections.count", sections.count)
//        print(subgroups)
        if isFiltering() {
//            for item in searchableWorkouts {
//                print(item.value(forKey: "displayName"))
//            }
            return 1
        }
        // reset previously filtered workouts
        searchableWorkouts = []
        return subgroups.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("sections[section].muscle!.count", sections[section].muscle!.count)
//        return sections[section].muscle!.count
        if isFiltering() {
            print(filteredWorkouts.count)
//            print(filteredWorkouts)
            return filteredWorkouts.count
        } else {
            var count = 0
            var workoutsForSubgroup: [NSManagedObject] = []
            if Defaults.getGender() == "male" {
                workoutsForSubgroup = CoreData.retrieveWorkoutsForSubgroup(subgroup: subgroups[section], gender: "M")
            } else if Defaults.getGender() == "female" {
                workoutsForSubgroup = CoreData.retrieveWorkoutsForSubgroup(subgroup: subgroups[section], gender: "F")
            }
//            for item in workoutsForSubgroup {
//                print(item.value(forKey: "displayName"))
//            }
            workouts.append(workoutsForSubgroup)
            searchableWorkouts.append(contentsOf: workoutsForSubgroup)
            count = workoutsForSubgroup.count
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
        if isFiltering() {
            sectionHeaderView.headerLabel.attributedText = "  Result".convertToNSAtrributredString(size: 25, color: .black)
        } else {
            let subgroup = "  " + subgroups[indexPath.section]
            
            sectionHeaderView.headerLabel.attributedText = subgroup.convertToNSAtrributredString(size: 25, color: .black)
        }
//        print(subgroup)

        return sectionHeaderView
    }
}

extension WorkoutListController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
