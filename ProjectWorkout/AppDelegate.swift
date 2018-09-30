//
//  AppDelegate.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/10/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        Defaults.setGender("noneSelected")
        // Initial screen will be to select gender... otherwise display screen w/ selected gender
//        let initialGenderSelection = Defaults.getGender()
//        if initialGenderSelection == "noneSelected"  {
//            print("noneSelected")
//            window?.rootViewController = GenderController()
//        } else {
//            print("Male")
//            let layout = UICollectionViewFlowLayout()
//            window?.rootViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))
//            window?.backgroundColor = .white
//            // Navigation bar at top
//            UINavigationBar.appearance().barTintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
//
//            // get rid of black bar underneath navigation bar
//            UINavigationBar.appearance().shadowImage = UIImage()
//            UINavigationBar.appearance().setBackgroundImage(UIImage(), for:.default)
//        }
        
        let layout = UICollectionViewFlowLayout()
        window?.rootViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))
        window?.backgroundColor = .white
        // Navigation bar at top
        UINavigationBar.appearance().barTintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        // get rid of black bar underneath navigation bar
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for:.default)
        
        
        
        // change status bar to white color... go to info.plist add view controller-based status bar, set to no
//        application.statusBarStyle = .default
        
        // add status bar which stays no matter what in our window, which contains everything in all applications
//        let statusBarBackgroundView = UIView()
//        statusBarBackgroundView.backgroundColor = .white
//        window?.addSubview(statusBarBackgroundView)
//        // horiztonally left to right
//        window?.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBackgroundView)
//        var statusBarHeight = 20
//        if (window?.safeAreaInsets.top)! > CGFloat(0.0) || window?.safeAreaInsets != .zero {
//            statusBarHeight = 44
//        }
//        // vertically 20 pixels tall, touch top only
//        window?.addConstraintsWithFormat(format: "V:|[v0(\(statusBarHeight))]", views: statusBarBackgroundView)
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

