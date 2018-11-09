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

    let brightYellow = UIColor.rgb(red: 255, green: 255, blue: 0)
    let darkGray = UIColor.rgb(red: 61, green: 61, blue: 56)
    let lightGray = UIColor.rgb(red: 183, green: 183, blue: 176)
    let whiteView = UIView()
    let pageLabel = UILabel()
    let search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        //        search.hidesNavigationBarDuringPresentation = true
        return search
    }()
    let spaceBetweenTopSafeAreaAndPageLabel = 10
    let pageLabelSize = 45

//    var managedObjectContext: NSManagedObjectContext? = nil
    var muscles: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        
        setupNavBar()
//        setupSearchBar()
        setupMoreOptions()
        setupPageLabel()
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Defaults.getGender() == "male" {
            muscles = CoreData.retrieveMuscleData(table: "Muscle", gender: "M")
        } else if Defaults.getGender() == "female" {
            muscles = CoreData.retrieveMuscleData(table: "Muscle", gender: "F")
        }
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        collectionView?.reloadData()

        view.layoutIfNeeded()

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

    private func setupNavBar() {
        self.navigationController?.navigationBar.isTranslucent = false
    }

    private func setupSearchBar() {
        navigationItem.searchController = search
        search.searchBar.placeholder = "Search Muscles"
        search.obscuresBackgroundDuringPresentation = false
//        search.searchResultsUpdater = self
        definesPresentationContext = true

    }

    private func setupMoreOptions() {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        let moreOptionsImage = UIImage(named: "hamburger")
        button.setImage(moreOptionsImage, for: .normal)
//        button.backgroundColor = .red
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.addTarget(self, action: #selector(handleMoreOptions), for: .touchUpInside)
        let moreOptions = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItems = [moreOptions]
    }

    @objc private func handleMoreOptions() {
//        self.delegate?.openMenu()
        (UIApplication.shared.keyWindow?.rootViewController as? BaseSlidingController)?.openMenu()
    }

    private func setupPageLabel() {
        let text = "Workouts"
        let size = (navigationController?.navigationBar.frame.height)! - 7
        pageLabel.attributedText = text.convertToNSAtrributredString(size: CGFloat(size), color: UIColor.black)
        pageLabel.backgroundColor = .white
        pageLabel.sizeToFit()
        navigationItem.titleView = pageLabel
    }

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

    // MARK: UICollectionView override delegation methods
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? MuscleCell else {
            fatalError("Misconfigured cell type, \(collectionView)!")
        }
        let muscle = muscles[indexPath.item]
        let height = cell.frame.height/6
        let width = cell.frame.width
//        print("------------", height, width)
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: width, height: height)
        let workoutListVC = WorkoutListController(collectionViewLayout: layout)
//        let workoutListVC = WorkoutListViewController()
        // pass muscle type data into workout list
        workoutListVC.muscleType = muscle.value(forKey: "displayName") as? String

        self.navigationItem.searchController?.isActive = false
        self.navigationItem.searchController = nil

        self.navigationController?.pushViewController(workoutListVC, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return muscles.count // 5 items for now, base off Model later
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? MuscleCell else {
            fatalError("Misconfigured cell type, \(collectionView)!")
        }
        let muscle = muscles[indexPath.item]
//        print(muscle)
        cell.displayName = muscle.value(forKeyPath: "displayName") as? String
        cell.imageName = muscle.value(forKeyPath: "imageName") as? String
        return cell
    }

    // define size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // conform to 16 by 9 standard. subtract left and right padding
        let width = view.frame.width
        let height = width * 9/16
        return CGSize(width: width, height: height)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if muscles.isEmpty == false {
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
}
