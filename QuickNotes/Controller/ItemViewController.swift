//
//  ItemViewControllerTableViewController.swift
//  QuickNotes
//
//  Created by Ratnesh Kumar on 13/06/19.
//  Copyright © 2019 Anand Gupta. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ItemViewController: UITableViewController {
    let realm = try! Realm()
    var items : Results<Item>?
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let hexColor = selectedCategory?.color{
            setUpNavBarColor(colorCode: hexColor)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setUpNavBarColor(colorCode: UIColor.white.hexValue())
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemCell
        cell.titleLabel.text = items?[indexPath.row].title ?? "No Note found"
        
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @IBAction func addItem(_ sender: Any) {
        var itemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add Notes", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
        if let category = self.selectedCategory{
            do{
                try self.realm.write {
                    let newItem = Item()
                    if !(itemTextField.text!.isEmpty){
                        newItem.title = itemTextField.text!
                        category.items.append(newItem)
                    }
                }
            }catch{
                print("\(error)")
            }
        }
            
        self.tableView.reloadData()
            
        }
        
        alert.addTextField { (textField) in
            itemTextField = textField
            itemTextField.placeholder = "Add new item"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func setUpNavBar(){
        navigationItem.title = selectedCategory?.title
        let searchConroller = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchConroller
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setUpNavBarColor(colorCode hexColor : String){
        guard let navBar = navigationController?.navigationBar else{
            fatalError()
        }
        
        if let navColor = UIColor(hexString: hexColor){
            navBar.barTintColor = navColor
            navBar.tintColor = ContrastColorOf(navColor, returnFlat: false)
            navBar.largeTitleTextAttributes  = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navColor, returnFlat: false)]
        }
    }
    
    private func loadItems(){
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    private func updateNoteTitle(alertTitle: String, actionTitle: String, note: Item){
        var noteTextField = UITextField()
        let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
            if let noteTitle = noteTextField.text
            {
                do{
                    try self.realm.write {
                        note.title = noteTitle
                    }
                }catch{
                    print("\(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (textField) in
            noteTextField = textField
            noteTextField.text = note.title
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
}

extension ItemViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text!
        if query.count == 0{
            self.loadItems()
        }else{
            items = items?.filter("title CONTAINS[cd] %@", query)
            self.tableView.reloadData()
        }
    }
    
    
}

extension ItemViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let noteToBeDeleted = self.items?[indexPath.row]{
                do{
                    try self.realm.write {
                        self.realm.delete(noteToBeDeleted)
                    }
                }catch{
                    print("\(error)")
                }
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "icon-delete")
        deleteAction.textColor = UIColor.black
        deleteAction.backgroundColor = UIColor.white
        
        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            // handle action by updating model with deletion
            if let itemToBeEdit = self.items?[indexPath.row]{
                self.updateNoteTitle(alertTitle: "Update Note", actionTitle: "Note", note: itemToBeEdit)
            }
            
        }
        
        // customize the action appearance
        editAction.image = UIImage(named: "icon-edit")
        editAction.backgroundColor = UIColor.white
        editAction.textColor = UIColor.black
        
        return [deleteAction,editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}
