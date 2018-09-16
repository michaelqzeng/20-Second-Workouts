//
//  Extensions.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/10/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UILabel {
    func centerAnchor(to view: UIView) {
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: self.frame.width).isActive = true
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: self.frame.height).isActive = true
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension UICollectionViewController {
    // shift down our collectionView and scrollView 
    func shiftDownCollectionView(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        let inset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        collectionView?.contentInset = inset // move collection view under the bar. push it 50 pixels down
        collectionView?.scrollIndicatorInsets = inset // move scroll view under the bar as well, 50 pixels down
    }
}

extension String {
    func convertToNSAtrributredString(size: CGFloat) -> NSAttributedString {
        
        let attributes = [NSAttributedStringKey.font: UIFont(name: "Futura", size: size) as Any,
                          NSAttributedStringKey.foregroundColor: UIColor.white
            ] as [NSAttributedStringKey: Any]
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        
        return attributedString
    }
}

