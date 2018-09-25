//
//  ViewController.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/10/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import UIKit


class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let searchBar = UISearchBar()
    let whiteView = UIView()
    let pageLabel = UILabel()
    let search = UISearchController(searchResultsController: nil)
    let spaceBetweenTopSafeAreaAndPageLabel = 10
    let pageLabelSize = 38
    
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
        
        setupNavBar()
        setupSearchBar()
        setupMoreOptions()
        setupPageLabel()
        setupCollectionView()
        
             
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        search.dismiss(animated: false, completion: nil)
    }
    
    private func setupNavBar() {
//        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search Workouts"
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.changeBarColor(color: UIColor.rgb(red: 232, green: 233, blue: 234))
        
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
        pageLabel.attributedText = text.convertToNSAtrributredString(size: CGFloat(pageLabelSize), color: UIColor.black)
        pageLabel.backgroundColor = .white
//        view.addSubview(pageLabel)
//        pageLabel.translatesAutoresizingMaskIntoConstraints = false
//        pageLabel.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: CGFloat(spaceBetweenTopSafeAreaAndPageLabel)).isActive = true
//        pageLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 22).isActive = true
        pageLabel.sizeToFit()
//        pageLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor).isActive = true
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
        
//        // move collection view under the bar. push it 50 pixels down
//        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
//        // move scroll view under the bar as well, 50 pixels down
//        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
    }
    
    // MARK: UICollectionView override delegation methods
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath)
        //cell?.layer.borderWidth = 200
        //cell?.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        
        let layout = UICollectionViewFlowLayout()
        let workoutListVC = WorkoutListViewController(collectionViewLayout: layout)
//        let workoutListVC = WorkoutListViewController()
        
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
        var height = (view.frame.width - 35 - 35) * 9 / 16
        // also add the height of pixel padding from top of each cell
        height += 25
        return CGSize(width: view.frame.width, height: height+3)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
        
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
