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
//        setupMoreOptions()
        setupPageLabel()
        setupCollectionView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.searchController = search
        collectionView?.reloadData()
        
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
//        navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationController?.navigationBar.barTintColor = .white
//        let text = "Workouts"
//        self.navigationItem.title = text
////        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Superclarendon-Black ", size: CGFloat(size))!]
//
//        var size = 44
//        if UIDevice.current.orientation.isLandscape {
//            size = 32
//        }
//        let attrs = [
//            NSAttributedString.Key.foregroundColor: UIColor.white,
//            NSAttributedString.Key.font: UIFont(name: "Superclarendon-Black", size: CGFloat(size))!
//        ]
//        UINavigationBar.appearance().titleTextAttributes = attrs
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
        let moreOptionsImage = UIImage(named: "more_options")?.withRenderingMode(.alwaysOriginal)
        button.setImage(moreOptionsImage, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.addTarget(self, action: #selector(handleMoreOptions), for: .touchUpInside)
        let moreOptions = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItems = [moreOptions]
    }
    
    
    let settingsLauncher = SettingsLauncher()
    @objc private func handleMoreOptions() {
        
        //let distFromWindowTop = UIApplication.shared.framestatusBarFrame.height
        settingsLauncher.showSettings()
    }
    
    private func setupPageLabel() {
        
//        whiteView.backgroundColor = .white
//        view.addSubview(whiteView)
//        whiteView.translatesAutoresizingMaskIntoConstraints = false
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": whiteView]))
//        let spaceBetweenTopSafeAreaInsetsAndWV = spaceBetweenTopSafeAreaAndPageLabel + pageLabelSize + 12
//        view.addConstraintsWithFormat(format: "V:[v0(\(spaceBetweenTopSafeAreaInsetsAndWV))]", views: whiteView)
        // whiteView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true

        let text = "Workouts"
        let size = (navigationController?.navigationBar.frame.height)! - 10
//        pageLabel.text = text
        pageLabel.attributedText = text.convertToNSAtrributredString(size: CGFloat(size), color: UIColor.black)
        pageLabel.backgroundColor = .white
        pageLabel.sizeToFit()
        navigationItem.titleView = pageLabel
//        view.addSubview(pageLabel)
//        pageLabel.translatesAutoresizingMaskIntoConstraints = false
//        pageLabel.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: CGFloat(spaceBetweenTopSafeAreaAndPageLabel)).isActive = true
//        pageLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 22).isActive = true
//        pageLabel.sizeToFit()
//        pageLabel.translatesAutoresizingMaskIntoConstraints = false
//        pageLabel.textAlignment = .left
//        pageLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
        
//        pageLabel.superview?.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: .centerX, relatedBy: .equal, toItem: pageLabel.superview, attribute: .centerX, multiplier: 1, constant: 0))
//        pageLabel.superview?.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: .width, relatedBy: .equal, toItem: pageLabel.superview, attribute: .width, multiplier: 1, constant: 0))
//        pageLabel.superview?.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: .centerY, relatedBy: .equal, toItem: pageLabel.superview, attribute: .centerY, multiplier: 1, constant: 0))
//        pageLabel.superview?.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: .height, relatedBy: .equal, toItem: pageLabel.superview, attribute: .height, multiplier: 1, constant: 0))
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
        
//        // move collection view under the bar. push it 50 pixels down
//        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
//        // move scroll view under the bar as well, 50 pixels down
//        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
    }
    
    // MARK: UICollectionView override delegation methods
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MuscleCell
        cell.muscle = muscles[indexPath.item]
        let height = cell.frame.height/6
        let width = cell.frame.width
        print(height, width)
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
//        var height = (view.frame.width - 35 - 35) * 9 / 16
        let height = view.frame.width * 9/16
        // also add the height of pixel padding from top of each cell
//        height += 25
//        return CGSize(width: view.frame.width, height: height+3)
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
        
//        var size = 44
//        if UIDevice.current.orientation.isLandscape {
//            size = 25
//        }
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Futura", size: CGFloat(size))!]
//        navigationController?.setValue(CustomNavigationBar.self, forKey: "navigationBar")
//        pageLabel.attributedText = pageLabel.text?.convertToNSAtrributredString(size: size!, color: .black)
        
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
