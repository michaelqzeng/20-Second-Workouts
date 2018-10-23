//
//  MusclesSearch.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/15/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

extension HomeController: UISearchBarDelegate {
    
    // MARK: Keyboard handling for Muscle View Controller
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        startTyping()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        doneTyping()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        doneTyping()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doneTyping()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doneTyping))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func startTyping() {
        searchBar.showsCancelButton = true
        // Dim background
        
    }
    
    @objc func doneTyping() {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
}
