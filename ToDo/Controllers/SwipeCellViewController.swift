//
//  SwipeCellViewController.swift
//  ToDo
//
//  Created by Ekaterina Makaryeva on 10/04/2018.
//  Copyright © 2018 Ekaterina Makaryeva. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipeCellViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 75.0
        tableView.separatorStyle = .none
        tableView.backgroundColor = FlatWhite()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateNavBar()
    }
    
    func updateNavBar() {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        navBar.barTintColor = FlatWhite()
        navBar.tintColor = FlatBlackDark()
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: FlatBlackDark()]
        //remove separators around searchBar
        navBar.shadowImage = UIImage()
    }
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            action.transitionDelegate = ScaleTransition.default
            self.updateModel(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .drag
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        
    }
}
