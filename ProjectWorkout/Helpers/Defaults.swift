//
//  Defaults.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/25/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation

// Model to handle our UserDefault permanent user preference values
struct Defaults {
    
    // Gender value modifiers
    static var setGender = { (gender: String) in
        // Set up notification to send our selected gender value
        let selectedGender = Notification.Name(rawValue: gender)
        NotificationCenter.default.post(name: selectedGender, object: nil) // post nofitication to subscribed topics
        
        // Store user preference data
        UserDefaults.standard.set(gender, forKey: "genderKey")
//        UserDefaults.standard.synchronize()
    }
    
    static var getGender = {
        return UserDefaults.standard.value(forKey: "genderKey") as? String ?? "noneSelected"
    }
    
    // Clear all stored data
    static func clearUserData() {
        UserDefaults.standard.removeObject(forKey: "genderKey")
        // UserDefaults.standard.set("noneSelected", forKey: "genderKey")
    }
    
}
