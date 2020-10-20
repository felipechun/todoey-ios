//
//  CategoryVC.swift
//  Todoey
//
//  Created by Felipe Chun on 10/12/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryVC: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    // create the context from the AppDelegate, which is basically like the git staging area
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    // MARK: - Table view data source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveCategories(category: Category) {
        
        do {
            // COREDATA
//            try context.save()
            
            // REALM
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    // reading data from the database
    // the parameter is a request but also has a default value if one is not provided on the function call
    
    // COREDATA
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("error fetching data from context: \(error)")
//        }
//    }
    
    // REALM
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()

    }
    
    // MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // adding the textfield to the alert
                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Create new category"
                    textField = alertTextField
                }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // what happens once the user clicks the add category button on our UIAlert
            // COREDATA
//            let newCategory = Category(context: self.context)
//            newCategory.name = textField.text!
//            self.categories.append(newCategory)
            
            // REALM
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.saveCategories(category: newCategory)
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
}

