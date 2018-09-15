//
//  SearchBar.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 9/14/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

class SearchHeader: UICollectionViewCell, UISearchBarDelegate {
    
    override init(frame: CGRect)    {
        super.init(frame: frame)
        setupHeaderViews()
    }
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Search Workouts"
        return searchBar
    }()
    
    let temp: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupHeaderViews()   {
        addSubview(temp)
        
        
        temp.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        NSLayoutConstraint.activate([
            temp.leadingAnchor.constraint(equalTo: leadingAnchor),
            temp.trailingAnchor.constraint(equalTo: trailingAnchor),
            temp.heightAnchor.constraint(equalToConstant: 25)
            ])

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
