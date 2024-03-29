//
//  BaseSlidingController.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 10/12/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BaseSlidingController: UIViewController {
    
    let redView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = .red
        return view
    }()
    
    let blueView: UIView = {
        let view = UIView()
//        v.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let darkCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var rightViewController: UIViewController = {
        let layout = UICollectionViewFlowLayout()
        let view = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))
        return view
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Your Logic here
        rightViewController.view.layoutIfNeeded()
    }
    
//    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        if Defaults.getGender() == "male" || Defaults.getGender() == "female" {
//            setupViews()
//        } else {
//            perform(#selector(showGenderController), with: nil, afterDelay: 0.01)
//        }
        if Defaults.getGender() == "noneSelected" {
            perform(#selector(showGenderController), with: nil, afterDelay: 0.01)
        }
        setupViews()

        // reverse above
        
        // pan gesture to track slide, and adjust redview's constraint
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
        darkCoverView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showGenderController() {
        let genderVC = GenderController()
        present(genderVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleTapDismiss() {
        closeMenu()
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if isMenuOpened == false {
            return
        }
        let translation = gesture.translation(in: view)
        var translationX = translation.x
        
        translationX = isMenuOpened ? translationX - menuWidth : translationX
        translationX = max(-menuWidth, translationX)
        translationX = min(0, translationX)
        
//        print(x)
        
        redViewLeadingConstraint.constant = translationX
        redViewTrailingConstraint.constant = translationX
        darkCoverView.alpha = abs(translationX) / menuWidth
        
        if gesture.state == .ended {
            handleEnded(gesture: gesture)
        }
    }
    
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        // Cleaning up this section of code to solve for Lesson #10 Challenge of velocity and darkCoverView
        if isMenuOpened {
            print("opened")
//            print("x \(velocity.x)")
//            print(velocityThreshold)
            if velocity.x > velocityThreshold {
                closeMenu()
                return
            }
            if translation.x > menuWidth / 2 {
                closeMenu()
            } else {
                openMenu()
            }
        } else {
            print("closed")
//            print("x \(velocity.x)")
//            print(velocityThreshold)
            if velocity.x < -velocityThreshold {
                openMenu()
                return
            }
            
            if abs(translation.x) > menuWidth / 2 {
                openMenu()
            } else {
                closeMenu()
            }
        }
    }
    
    func openMenu() {
        isMenuOpened = true
        redViewLeadingConstraint.constant = -menuWidth
        redViewTrailingConstraint.constant = -menuWidth
        performAnimations()
    }
    
    func closeMenu() {
        redViewLeadingConstraint.constant = 0
        redViewTrailingConstraint.constant = 0
        isMenuOpened = false
        performAnimations()
    }
    
    func didSelectMenuItem(indexPath: IndexPath) {
        performRightViewCleanUp()
        closeMenu()
        
        switch indexPath.row {
        case 0:
            print("Home Screen")
            rightViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
            
        case 1:
            print("Opening Favorites List")
            let height = CGFloat(38.8125)
            let width = CGFloat(414.0)
            //        print(height, width)
            let layout = UICollectionViewFlowLayout()
            layout.headerReferenceSize = CGSize(width: width, height: height)
            rightViewController = UINavigationController(rootViewController: FavoritesListController(collectionViewLayout: layout))
            
        case 2:
            print("Switching Gender")
            if Defaults.getGender() == "male" {
                print("Switching to female")
                Defaults.setGender("female")
            } else if Defaults.getGender() == "female" {
                print("Switching to female")
                Defaults.setGender("male")
            } else {
                print("No gender previously chosen. Defaulting to male")
                Defaults.setGender("male")
            }
            rightViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
            
        default:
            rightViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        }
        
        redView.addSubview(rightViewController.view)
        addChild(rightViewController)
        
        redView.bringSubviewToFront(darkCoverView)
    }
    
    fileprivate func performRightViewCleanUp() {
        rightViewController.view.removeFromSuperview()
        rightViewController.removeFromParent()
        rightViewController.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func performAnimations() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            // leave a reference link down in desc below
            self.view.layoutIfNeeded()
            self.darkCoverView.alpha = self.isMenuOpened ? 1 : 0
        })
    }
    
    var redViewLeadingConstraint: NSLayoutConstraint!
    var redViewTrailingConstraint: NSLayoutConstraint!
    fileprivate let menuWidth: CGFloat = 250
    fileprivate let velocityThreshold: CGFloat = 500
    fileprivate var isMenuOpened = false
    
    fileprivate func setupViews() {
        view.addSubview(redView)
        view.addSubview(blueView)
        
        // let's go ahead and use Auto Layout
        NSLayoutConstraint.activate([
            redView.topAnchor.constraint(equalTo: view.topAnchor),
            redView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blueView.topAnchor.constraint(equalTo: view.topAnchor),
            blueView.leadingAnchor.constraint(equalTo: redView.trailingAnchor),
            blueView.widthAnchor.constraint(equalToConstant: menuWidth),
            blueView.bottomAnchor.constraint(equalTo: redView.safeBottomAnchor)
            ])
        
        redViewLeadingConstraint = redView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        redViewLeadingConstraint.isActive = true
        
        redViewTrailingConstraint = redView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        redViewTrailingConstraint.isActive = true
        
        setupViewControllers()
    }
    
    fileprivate func setupViewControllers() {
        let menuController = MenuController()
        let homeView = rightViewController.view!
        let menuView = menuController.view!
        
        homeView.translatesAutoresizingMaskIntoConstraints = false
        menuView.translatesAutoresizingMaskIntoConstraints = false
        
        redView.addSubview(homeView)
        redView.addSubview(darkCoverView)
        blueView.addSubview(menuView)
        
        NSLayoutConstraint.activate([
            // top, leading, bottom, trailing anchors
            homeView.topAnchor.constraint(equalTo: redView.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: redView.leadingAnchor),
            homeView.bottomAnchor.constraint(equalTo: redView.bottomAnchor),
            homeView.trailingAnchor.constraint(equalTo: redView.trailingAnchor),

            menuView.topAnchor.constraint(equalTo: blueView.topAnchor),
            menuView.leadingAnchor.constraint(equalTo: blueView.leadingAnchor),
            menuView.bottomAnchor.constraint(equalTo: blueView.bottomAnchor),
            menuView.trailingAnchor.constraint(equalTo: blueView.trailingAnchor),
            
            darkCoverView.topAnchor.constraint(equalTo: redView.topAnchor),
            darkCoverView.leadingAnchor.constraint(equalTo: redView.leadingAnchor),
            darkCoverView.bottomAnchor.constraint(equalTo: redView.bottomAnchor),
            darkCoverView.trailingAnchor.constraint(equalTo: redView.trailingAnchor)
            ])
        
        addChild(rightViewController)
        addChild(menuController)
    }
    
}
