//
//  Json.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 11/9/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation

struct Json {
    static func parseFile(muscleSubgroup: String, specificWorkout: String) -> [Content] {
        // Init Content array
        var contents: [Content] = []
        
        // Parse Json data and generate content objects
        // Use guard statement here to catch failing file read
        let url = Bundle.main.url(forResource: muscleSubgroup, withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            if let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                if let jsonData = json[specificWorkout] as? [String: Any] {
                    for item in jsonData {
                        let subtitle = item.key
                        let contentArray = item.value as? [String] ?? ["Null"]
                        contents.append(Content(subtitle: subtitle, content: contentArray))
                    }
                }
            } else {
                print("Using dummy back-up data")
            }
        } catch {
            print(error)
            contents.append(Content(subtitle: "Null", content: ["Null"]))
        }
        return contents
    }
}
