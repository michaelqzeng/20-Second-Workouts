//
//  ViewController.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/10/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import UIKit
import CoreData

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    // List of muscles included in database
    var muscles: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        print(urls[urls.count-1] as URL)
        
        setupNavBar()
//        setupSearchBar()
        setupMoreOptions()
        setupPageLabel()
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get muscles and it's corresponding images based on selected gender
        if Defaults.getGender() == "male" {
            muscles = CoreData.retrieveMuscleData(table: "Muscle", gender: "M")
        } else if Defaults.getGender() == "female" {
            muscles = CoreData.retrieveMuscleData(table: "Muscle", gender: "F")
        }
        
        // Reload data with most recent data
        collectionView?.reloadData()

        // Handles layout changes
        view.layoutIfNeeded()
    }
    
    // MARK: Page Label
    let pageLabel = UILabel()
    
    private func setupPageLabel() {
        let text = "Home"
        let size = (navigationController?.navigationBar.frame.height)! - 7
        pageLabel.attributedText = text.convertToNSAtrributredString(size: CGFloat(size), color: UIColor.black)
        pageLabel.backgroundColor = UIColor.rgb(red: 191, green: 192, blue: 193)
        pageLabel.sizeToFit()
        navigationItem.titleView = pageLabel
    }
    
    // MARK: Search Controller
    let search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        //        search.hidesNavigationBarDuringPresentation = true
        return search
    }()
    
    private func setupSearchBar() {
        navigationItem.searchController = search
        search.searchBar.placeholder = "Search Muscles"
        search.obscuresBackgroundDuringPresentation = false
        //        search.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    // MARK: Navigation Bar
    private func setupNavBar() {
        self.navigationController?.navigationBar.isTranslucent = false
    }

    // MARK: Options Button
    private func setupMoreOptions() {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        let moreOptionsImage = UIImage(named: "hamburger")
        button.setImage(moreOptionsImage, for: .normal)
        button.backgroundColor = UIColor.rgb(red: 191, green: 192, blue: 193)
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.addTarget(self, action: #selector(handleMoreOptions), for: .touchUpInside)
        let moreOptions = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItems = [moreOptions]
    }

    @objc private func handleMoreOptions() {
        (UIApplication.shared.keyWindow?.rootViewController as? BaseSlidingController)?.openMenu()
    }

    // MARK: Collection View
    private func setupCollectionView() {
        // register videocell as our cells for our collectionview
        collectionView?.register(MuscleCell.self, forCellWithReuseIdentifier: "cellId")

        collectionView?.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)

        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        collectionView?.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.safeBottomAnchor).isActive = true
    }

    // MARK: Collection View override delegation methods
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Cast cell into a MuscleCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? MuscleCell else {
            fatalError("Misconfigured cell type, \(collectionView)!")
        }
        
        // Load muscle cell from list, and create next view controller w/ defined header size
        let muscle = muscles[indexPath.item]
        let layout = UICollectionViewFlowLayout()
        let headerHeight = cell.frame.height/6
        let headerWidth = cell.frame.width
        layout.headerReferenceSize = CGSize(width: headerWidth, height: headerHeight)
        let workoutListVC = WorkoutListController(collectionViewLayout: layout)
        
        // Pass selected muscle information to our newly created WorkoutList controller
        workoutListVC.muscleType = muscle.value(forKey: "displayName") as? String

        // Back Button customization
        let backItem = UIBarButtonItem()
        navigationItem.backBarButtonItem = backItem
        backItem.title = "Home "
        
        // Push Workout List VC
        self.navigationController?.pushViewController(workoutListVC, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return muscles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Load each cell from list of muscles
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? MuscleCell else {
            fatalError("Misconfigured cell type, \(collectionView)!")
        }
        
        let muscle = muscles[indexPath.item]
        cell.displayName = muscle.value(forKeyPath: "displayName") as? String
        cell.imageName = muscle.value(forKeyPath: "imageName") as? String
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Define size of each cell. Conform to 16 by 9 standard
        let width = view.frame.width
        let height = width * 9/16
        return CGSize(width: width, height: height)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Reload layout if we have an empty set of muscles?
        if muscles.isEmpty == false {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
//        collectionView?.collectionViewLayout.invalidateLayout()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Remove extra pixel padding between each cell
        return 0
    }
}
