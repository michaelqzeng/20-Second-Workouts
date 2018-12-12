//////
//////  Firebase.swift
//////  ProjectWorkout
//////
//////  Created by Michael Zeng on 11/4/18.
//////  Copyright © 2018 Michael Zeng. All rights reserved.
//////
//
//import Foundation
//import Firebase
//
//struct Firebase {
//    static func getURL(workoutName: String) {
//        let storage = Storage.storage()
//        
//        // Create a reference from a Google Cloud Storage URI
//        let gsReference = storage.reference(forURL: "gs://projectworkout-84fca.appspot.com")
//        
//        let nsString = NSString(string: workoutName)
//        // Create a reference to the file you want to download
////        let starsRef = gsReference.child("male_decline_barbell_bench_press.mp4")
//        let starsRef = gsReference.child(nsString as String )
//        // Fetch the download URL
//        return starsRef.downloadURL(completion: { url, error in
//            if let error = error {
//                // Handle any errors
//                print("ERROR \(error)")
//                return
//            } else {
//                // Get the download URL for 'images/stars.jpg'
//                print("download URL retrieved \(url!)")
//            }
//        }) 
//        
////        print("I'm extremely sad. I hope this URL loads: ", downloadURL)
//        
//    }
//}
