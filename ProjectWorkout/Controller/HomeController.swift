//
//  ViewController.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/10/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import UIKit


class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let brightYellow = UIColor.rgb(red: 255, green: 255, blue: 0)
    let darkGray = UIColor.rgb(red: 61, green: 61, blue: 56)
    let lightGray = UIColor.rgb(red: 183, green: 183, blue: 176)
    
    let searchBar = UISearchBar()
    let whiteView = UIView()
    let pageLabel = UILabel()
    let search = UISearchController(searchResultsController: nil)
    let spaceBetweenTopSafeAreaAndPageLabel = 10
    let pageLabelSize = 45
    
//    weak var delegate: MenuOptionsDelegate?
    
    var muscles: [Muscle] = {
        var male_arms = Muscle(imageFileName: "male_arms", muscleName: "Arms")
        var male_chest = Muscle(imageFileName: "male_chest", muscleName: "Chest")
        var male_legs = Muscle(imageFileName: "male_legs", muscleName: "Legs")
        var male_back = Muscle(imageFileName: "male_back", muscleName: "Back")
        var male_shoudlers = Muscle(imageFileName: "male_shoulders", muscleName: "Shoulders")
        return [male_legs, male_arms, male_chest, male_back, male_shoudlers]
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
        
        self.navigationItem.searchController = search
        collectionView?.reloadData()
        
        view.layoutIfNeeded()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Defaults.getGender() == "noneSelected" {
            let vc = GenderController()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search Workouts"
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.changeBarColor(color: UIColor.rgb(red: 232, green: 233, blue: 234))
        search.hidesNavigationBarDuringPresentation = true
        
        search.searchBar.placeholder = "Search Workouts"
        navigationItem.searchController = search
        
        hideKeyboardWhenTappedAround()
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
        let size = (navigationController?.navigationBar.frame.height)! - 10
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MuscleCell
        cell.muscle = muscles[indexPath.item]
        let height = cell.frame.height/6
        let width = cell.frame.width
//        print(height, width)
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: width, height: height)
        let workoutListVC = WorkoutListController(collectionViewLayout: layout)
//        let workoutListVC = WorkoutListViewController()
        
        self.navigationItem.searchController?.isActive = false
        self.navigationItem.searchController = nil
        
        self.navigationController?.pushViewController(workoutListVC, animated: true)
    }
    
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
        let width = view.frame.width 
        let height = width * 9/16
        return CGSize(width: width, height: height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        collectionView?.collectionViewLayout.invalidateLayout()
        
    }
    
    // remove extra pixel padding between each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
