//
//  Firebase.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 11/4/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

//import Foundation
//import Firebase
//
//struct Firebase {
//    static func getURL() {
//        let storage = Storage.storage()
//        
//        // Create a reference from a Google Cloud Storage URI
//        let gsReference = storage.reference(forURL: "gs://projectworkout-84fca.appspot.com")
//        
//        // Create a reference to the file you want to download
//        let starsRef = gsReference.child("Male/Arms/Bicep/Barbell_Bicep_Curl.MOV")
//        
//        // Fetch the download URL
//        starsRef.downloadURL { url, error in
//            if let error = error {
//                // Handle any errors
//                print("ERROR \(error)")
//                return
//            } else {
//                // Get the download URL for 'images/stars.jpg'
//                print("download URL retrieved \(url!)")
//            }
//        }
//
//    }
//    
//    static func loadVideo(imageURL: String) {
//        
//    }
//}
