//
//  ViewController.swift
//  Quick Notes
//
//  Created by Ratnesh Kumar on 09/06/19.
//  Copyright © 2019 Anand Gupta. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    var categoryList : Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpNavBar()
        loadCategories()
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
       addCategory(alertTitle: "Add a category", actionTitle: "Add", category: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath) as! CategoryCell
        
        setUpTableViewCell(item: cell)
        
        cell.labelView.text = categoryList?[indexPath.row].title ?? ""
        
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destination = segue.destination as! ItemViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                destination.selectedCategory = categoryList?[indexPath.row]
            }
        }
    }
    
    private func setUpNavBar(){
        let searchConroller = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchConroller
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setUpTableViewCell(item cell : CategoryCell){
        cell.borderView.layer.borderColor = UIColor.blue.cgColor
        cell.borderView.layer.borderWidth = 1.5
        cell.borderView.layer.cornerRadius = 10
    }
    
    private func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
    }
    
    private func loadCategories(){
        categoryList = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    private func addCategory(alertTitle : String, actionTitle : String, category : Category?){
        var categoryTitleField = UITextField()
        let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
            
            if !(categoryTitleField.text!.isEmpty){
                let newCategory = Category()
                newCategory.title = categoryTitleField.text!
                
                self.save(category : newCategory)
            }
        }
        
        alert.addAction(action)
        alert.addTextField { (textField) in
            categoryTitleField = textField
            categoryTitleField.placeholder = "Add category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    private func updateCategory(alertTitle : String, actionTitle : String, category : Category){
        var categoryTitleField = UITextField()
        let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
            
            if !(categoryTitleField.text!.isEmpty){
                do{
                    try self.realm.write {
                        category.title = categoryTitleField.text!
                    }
                }catch{
                    print("\(error)")
                }
            
            }
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (textField) in
            categoryTitleField = textField
            categoryTitleField.text = category.title
            categoryTitleField.placeholder = "Update category"
        }
        present(alert, animated: true, completion: nil)
    }
}

extension CategoryViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let categoryToBeDeleted = self.categoryList?[indexPath.row]{
                do{
                    try self.realm.write {
                        self.realm.delete(categoryToBeDeleted)
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
            if let categoryToBeEdit = self.categoryList?[indexPath.row]{
                self.updateCategory(alertTitle: "Update category", actionTitle: "Update", category: categoryToBeEdit)

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
