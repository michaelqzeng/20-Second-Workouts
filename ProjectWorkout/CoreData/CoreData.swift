//
//  CoreData.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 10/26/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct CoreData {
    
    static func preloadData() {
//        deleteAllData(entityName: "Muscle")
        loadMuscleData()
//        deleteAllData(entityName: "Workout")
        loadWorkoutData()
    }
    
    static func deleteAllData(entityName: String) {
        // swiftlint:disable:next force_cast
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Deleted all data for table \(entityName)...")
        } catch {
            print ("There was an error")
        }
    }
    
    static func loadMuscleData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // ensure we are loading on the first time
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Muscle")
        
        if let count = try? managedContext.count(for: fetchRequest) {
            // swiftlint:disable:next empty_count
            if count > 0 {
                print("We already have Muscle core data loaded!")
                return
            } else {
                print("Loading initial Muscle core data...")
            }
        }
        
        if let path = Bundle.main.path(forResource: "Muscle", ofType: "plist") {
            var arr: NSArray?
            arr = NSArray(contentsOfFile: path)
            let dataArr = ((arr as? [[String: Any]])!)
            for dict in dataArr {
                // swiftlint:disable:next force_cast
                let muscleEntity = NSEntityDescription.insertNewObject(forEntityName: "Muscle", into: managedContext) as! Muscle
                muscleEntity.hasFavorited = dict["hasFavorited"] as? String
                muscleEntity.gender = dict["gender"] as? String
                muscleEntity.imageName = dict["imageName"] as? String
                muscleEntity.displayName = dict["displayName"] as? String
            }
        }
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        do {
            try managedContext.save()
            print("Saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func loadWorkoutData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // ensure we are loading on the first time
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
        
        if let count = try? managedContext.count(for: fetchRequest) {
            print(count)
            // swiftlint:disable:next empty_count
            if count > 0 {
                print("We already have Workout core data loaded!")
                return
            } else {
                print("Loading initial Workout core data...")
            }
        }
        
        if let path = Bundle.main.path(forResource: "Workout", ofType: "plist") {
            var arr: NSArray?
            arr = NSArray(contentsOfFile: path)
            let dataArr = ((arr as? [[String: Any]])!)
            for dict in dataArr {
                print(dict)
                // swiftlint:disable:next force_cast
                let workoutEntity = NSEntityDescription.insertNewObject(forEntityName: "Workout", into: managedContext) as! Workout
                workoutEntity.hasFavorited = dict["hasFavorited"] as? String
                workoutEntity.gender = dict["gender"] as? String
                workoutEntity.imageName = dict["imageName"] as? String
                workoutEntity.displayName = dict["displayName"] as? String
                workoutEntity.subgroup = dict["subgroup"] as? String
                workoutEntity.muscleGroup = dict["muscleGroup"] as? String
            }
        }
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        do {
            try managedContext.save()
            print("Saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

//    static func retrieveData(table: String) {
//        //As we know that container is set up in the AppDelegates so we need to refer that container.
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//        //We need to create a context from this container
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        //Prepare the request of type NSFetchRequest  for the entity
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: table)
//
//        //        fetchRequest.fetchLimit = 1
//        //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
//        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
//        //
//        do {
//            let result = try managedContext.fetch(fetchRequest)
//            for data in result as! [NSManagedObject] {
//                print(data.value(forKey: "username") as! String)
//            }
//
//        } catch {
//
//            print("Failed")
//        }
//    }
    
    static func retrieveMuscleData(table: String, gender: String) -> [NSManagedObject] {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: table)
        
        //        fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "gender = %@", gender)
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        
        var result: [Any]
        
        do {
            print("Retrieving male data from table \(table)")
            result = try managedContext.fetch(fetchRequest)
        } catch {
            print("Failed")
            result = []
        }
        
        // swiftlint:disable:next force_cast
        return result as! [Muscle]
    }
    
    static func retrieveWorkoutData(gender: String, muscle: String) -> [NSManagedObject] {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
//
//        //        fetchRequest.fetchLimit = 1
//        fetchRequest.predicate = NSPredicate(format: "gender = %@", gender)
//        fetchRequest.predicate = NSPredicate(format: "muscleGroup = %@", muscle)
//        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
        
        let genderPredicate = NSPredicate(format: "gender = %@", gender)
        let muscleGroupPredicate = NSPredicate(format: "muscleGroup = %@", muscle)
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [genderPredicate, muscleGroupPredicate])
        
        fetchRequest.predicate = andPredicate
        
        var result: [Any]
        
        do {
            print("Retrieving  \(muscle) data from table Workout table")
            result = try managedContext.fetch(fetchRequest)
        } catch {
            print("Failed")
            result = []
        }
        
        // swiftlint:disable:next force_cast
        return result as! [Workout]
    }
    
    static func retrieveWorkoutSubgroups(for muscle: String) -> [String] {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
        
//        fetchRequest.fetchLimit = 1
//        fetchRequest.predicate = NSPredicate(format: "subgroup = %@", "M")
//        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        
        fetchRequest.predicate = NSPredicate(format: "muscleGroup = %@", muscle)
        fetchRequest.propertiesToFetch = ["subgroup"]
        
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        
        var result: [Any]
        var subgroups: [String] = []
        
        do {
            print("Retrieving subgroups for \(muscle)")
            result = try managedContext.fetch(fetchRequest)
            
            for res in result {
                // swiftlint:disable:next force_cast
                let sub = (res as AnyObject).value(forKey: "subgroup") as! String
                subgroups.append(sub)
            }
        } catch {
            print("Failed")
            result = []
        }
        return subgroups
    }
    
    static func retrieveWorkoutsForSubgroup(subgroup: String, gender: String) -> [NSManagedObject] {
        print("Retrieving workouts for subgroup \(subgroup) for gender \(gender)")
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")

        let genderPredicate = NSPredicate(format: "gender = %@", gender)
        let subgroupPredicate = NSPredicate(format: "subgroup = %@", subgroup)
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [genderPredicate, subgroupPredicate])
        
        fetchRequest.predicate = andPredicate
        
        var result: [Any]
        
        do {
            result = try managedContext.fetch(fetchRequest)
        } catch {
            print("Failed")
            result = []
            // swiftlint:disable:next force_cast
            return result as! [Workout]
        }
        
        // swiftlint:disable:next force_cast
        let temp = result as! [Workout!]
        for tem in temp {
            print(tem?.displayName!)
        }

        // swiftlint:disable:next force_cast
        return result as! [Workout]
    }
    
    static func retrieveFavoritedWorkoutsForMuscle(muscle: String, gender: String) -> [NSManagedObject] {
        print("Retrieving favorited workouts for muscle group \(muscle) for gender \(gender)")
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
        
        let genderPredicate = NSPredicate(format: "gender = %@", gender)
        let subgroupPredicate = NSPredicate(format: "muscleGroup = %@", muscle)
        let favoritePredicate = NSPredicate(format: "hasFavorited = %@", "TRUE")
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [genderPredicate, subgroupPredicate, favoritePredicate])
        
        fetchRequest.predicate = andPredicate
        
        var result: [Any]
        
        do {
            result = try managedContext.fetch(fetchRequest)
        } catch {
            print("Failed")
            result = []
            // swiftlint:disable:next force_cast
            return result as! [Workout]
        }
        
        // swiftlint:disable:next force_cast
        let temp = result as! [Workout!]
        for tem in temp {
            print(tem?.displayName!)
        }
        
        // swiftlint:disable:next force_cast
        return result as! [Workout]
    }
    
    static func retrieveFavoritedWorkoutsMuscleGroups(gender: String) -> [String] {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
        
        //        fetchRequest.fetchLimit = 1
        //        fetchRequest.predicate = NSPredicate(format: "subgroup = %@", "M")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        
        fetchRequest.propertiesToFetch = ["muscleGroup"]
        
        let genderPredicate = NSPredicate(format: "gender = %@", gender)
        let favoritePredicate = NSPredicate(format: "hasFavorited = %@", "TRUE")
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [genderPredicate, favoritePredicate])
        
        fetchRequest.predicate = andPredicate
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        
        var result: [Any]
        var muscleGroups: [String] = []
        
        do {
            print("Retrieving muscle groups for Workout table)")
            result = try managedContext.fetch(fetchRequest)
            
            for res in result {
                // swiftlint:disable:next force_cast
                let sub = (res as AnyObject).value(forKey: "muscleGroup") as! String
                muscleGroups.append(sub)
            }
        } catch {
            print("Failed")
            result = []
        }
        return muscleGroups
    }
    
    static func updateFavoriteData(workout: NSManagedObject, to newValue: String) {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        workout.setValue(newValue, forKey: "hasFavorited")
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
        
    }
//    static func updateData() {
//
//        //As we know that container is set up in the AppDelegates so we need to refer that container.
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//        //We need to create a context from this container
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
////        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur1")
//        do
//        {
//            let test = try managedContext.fetch(fetchRequest)
//
//            let objectUpdate = test[0] as! NSManagedObject
//            objectUpdate.setValue("newName", forKey: "username")
//            objectUpdate.setValue("newmail", forKey: "email")
//            objectUpdate.setValue("newpassword", forKey: "password")
//            do{
//                try managedContext.save()
//            }
//            catch
//            {
//                print(error)
//            }
//        }
//        catch
//        {
//            print(error)
//        }
//
//    }
//
//    static func deleteData(){
//
//        //As we know that container is set up in the AppDelegates so we need to refer that container.
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//        //We need to create a context from this container
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//
//        do
//        {
//            let test = try managedContext.fetch(fetchRequest)
//
//            let objectToDelete = test[0] as! NSManagedObject
//            managedContext.delete(objectToDelete)
//
//            do{
//                try managedContext.save()
//            }
//            catch
//            {
//                print(error)
//            }
//
//        }
//        catch
//        {
//            print(error)
//        }
//    }
}
