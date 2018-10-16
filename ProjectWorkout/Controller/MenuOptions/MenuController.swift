//
//  MenuController.swift
//  ProjectWorkout
//
//  Created by Michael Zeng on 10/12/18.
//  Copyright © 2018 Michael Zeng. All rights reserved.
//

import Foundation
import UIKit

struct MenuItem {
    let icon: UIImage
    let title: String
}

extension MenuController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        // how do we access BaseSlidingController.closeMenu()
        let slidingController = UIApplication.shared.keyWindow?.rootViewController as? BaseSlidingController
        slidingController?.didSelectMenuItem(indexPath: indexPath)
    }
}

class MenuController: UITableViewController {

    var menuItems = [
        MenuItem(icon: UIImage(named: "male_arms")!, title: "Home"),
        MenuItem(icon: UIImage(named: "male_arms")!, title: "Bookmarks"),
        MenuItem(icon: UIImage(named: "male_arms")!, title: "")
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customHeaderView = CustomMenuHeaderView()
        return customHeaderView
    }

    //    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 300
    //    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }

        if Defaults.getGender() == "female" {
            menuItems.popLast()
            menuItems.append(MenuItem(icon: UIImage(named: "male_arms")!, title: "Switch to Male"))
        } else {
            menuItems.popLast()
            menuItems.append(MenuItem(icon: UIImage(named: "male_arms")!, title: "Switch to Female"))
        }

        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuItemCell(style: .default, reuseIdentifier: "cellId")
        let menuItem = menuItems[indexPath.row]
        cell.iconImageView.image = menuItem.icon
        cell.titleLabel.text = menuItem.title
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath)
        cell!.selectionStyle = .none
        return indexPath
    }

}
