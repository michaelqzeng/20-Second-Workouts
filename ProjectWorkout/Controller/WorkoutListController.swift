//
//  WorkoutListController.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/23/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class WorkoutListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let brightYellow = UIColor.rgb(red: 255, green: 255, blue: 0)
    let darkGray = UIColor.rgb(red: 61, green: 61, blue: 56)
    let lightGray = UIColor.rgb(red: 183, green: 183, blue: 176)
    
    let pageLabel = UILabel()
    let spaceBetweenTopSafeAreaAndPageLabel = 10
    let pageLabelSize = 38
    let search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Search Arms"
        search.hidesNavigationBarDuringPresentation = true
        return search
    }()

    var muscles1: [Muscle] = [
        Muscle(imageFileName: "male_arms_incline_hammer", muscleName: "Incline Hammer"),
        Muscle(imageFileName: "male_arms_tricep_dips", muscleName: "Tricep Dips")
    ]

    var muscles2: [Muscle] = [
        Muscle(imageFileName: "male_back_chin_up", muscleName: "Chin up"),
        Muscle(imageFileName: "male_back_pull_up", muscleName: "Pull up")
    ]

    var muscles3: [Muscle] = [
        Muscle(imageFileName: "male_chest_dumbbell_press", muscleName: "Dumbbell Press")
    ]

    lazy var sections: [Workout] = [Workout(subgroup: "Incline Chest", muscle: muscles1), Workout(subgroup: "Decline Chest", muscle: muscles2), Workout(subgroup: "Inner Chest", muscle: muscles3)]

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

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func favoriteCell(cell: WorkoutCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else {return}

        let section = sections[indexPath.section]
        let workouts = section.muscle
        let workout = workouts![indexPath.item]

        let isCurFavorited = workout.hasFavorited!

        workout.hasFavorited = !isCurFavorited

        cell.favoriteImageView.tintColor = isCurFavorited ? lightGray : brightYellow
//        print(isCurFavorited)
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
    
    private func setupPageLabel() {
        
        let text = "Arms"
        let size = (navigationController?.navigationBar.frame.height)! - 10
        pageLabel.attributedText = text.convertToNSAtrributredString(size: CGFloat(size), color: UIColor.black)
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected workout")
        let contentVC = ContentController()
        navigationController?.pushViewController(contentVC, animated: true)
    }
    // define size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.width * 9/16
        return CGSize(width: view.frame.width, height: height)
    }
//
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        collectionView?.collectionViewLayout.invalidateLayout()

    }
    
    // remove extra pixel padding between each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        print("sections.count", sections.count)
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("sections[section].muscle!.count", sections[section].muscle!.count)
        return sections[section].muscle!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? WorkoutCell else {
            fatalError("Misconfigured cell type, \(collectionView)!")
        }
        cell.link = self
        let section = sections[indexPath.section]
        let workouts = section.muscle
        let workout = workouts![indexPath.item]

        cell.muscle = workout

        cell.favoriteImageView.tintColor = workout.hasFavorited! ? brightYellow : lightGray
//        print(workout.hasFavorited!)
        
        return cell
    }

    // MARK: Section Header View

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? ReusableCollectionView else {
            fatalError("Misconfigured cell type, \(collectionView)!")
        }
        let subgroup = "  " + sections[indexPath.section].subgroup!

        sectionHeaderView.headerLabel.attributedText = subgroup.convertToNSAtrributredString(size: 20, color: .black)
//        print(subgroup)

        return sectionHeaderView
    }
}
