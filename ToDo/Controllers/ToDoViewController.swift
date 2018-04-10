//
//  ViewController.swift
//  ToDo
//
//  Created by Ekaterina Makaryeva on 04/04/2018.
//  Copyright © 2018 Ekaterina Makaryeva. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoViewController: SwipeCellViewController {
    
    let realm = try! Realm()
    var toDoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        //remove separators around searchBar
        searchBar.barTintColor = FlatWhite()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
    }
    override func updateNavBar() {
        super.updateNavBar()
    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let colour = FlatWhite().darken(byPercentage: (CGFloat(indexPath.row)/CGFloat(toDoItems!.count))/2) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                cell.tintColor = ContrastColorOf(colour, returnFlat: true)
                
//                tableView.backgroundColor = toDoItems!.count >= 2 ? colour : FlatWhite()
                tableView.backgroundColor = cell.backgroundColor
                
            }
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No ToDo's To Do"
        }
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating data, \(error)")
            }
            self.tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "You are amazing", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateOfCreation = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving context, \(error)")
                }
                
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add your awesome task"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateOfCreation", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
}

//MARK: - Search Bar methods

extension ToDoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            searchBarSearchButtonClicked(searchBar)
        }
    }
}
