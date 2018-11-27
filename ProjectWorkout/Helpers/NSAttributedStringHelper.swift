//
//  NSAttributedStringHelper.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/29/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class NSAttributedStringHelper {
    static func createBulletedList(fromStringArray strings: [String], font: UIFont? = nil) -> NSAttributedString {
        
        let fullAttributedString = NSMutableAttributedString()
        let attributesDictionary: [NSAttributedString.Key: Any]
        
        if font != nil {
            attributesDictionary = [NSAttributedString.Key.font: font!]
        } else {
            attributesDictionary = [NSAttributedString.Key: Any]()
        }
        
        for index in 0..<strings.count {
            let bulletPoint: String = "\u{2022}"
            var formattedString: String = "\(bulletPoint) \(strings[index])"
//            var formattedString: String = "\(index+1). \(strings[index])"
//            var formattedString: String = "   \(strings[index])"
            
            if index < strings.count - 1 {
                formattedString = "\(formattedString)\n\n"
            }
            
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString, attributes: attributesDictionary)
            let paragraphStyle = NSAttributedStringHelper.createParagraphAttribute()
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedString.length))
            fullAttributedString.append(attributedString)
        }
        
//        print(fullAttributedString)
        return fullAttributedString
    }
    
    private static func createParagraphAttribute() -> NSParagraphStyle {
        guard let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle else {
            fatalError("NSMutableParagraphStyle failure! Check NSAttributedStringHelper.swift")
        }
        guard let nsDictionary = NSDictionary() as? [NSTextTab.OptionKey: Any] else {
            fatalError("Bad NSDictionary unwrapping! Check NSAttributedStringHelper.swift")
        }
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: nsDictionary)]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 11
        return paragraphStyle
    }
}
