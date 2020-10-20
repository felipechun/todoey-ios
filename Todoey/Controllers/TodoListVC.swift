

import UIKit
//import CoreData
import RealmSwift

class TodoListVC: UITableViewController {
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    // create instance of UserDefaults
    //    let defaults = UserDefaults.standard
    
    // COREDATA
    // create the context from the AppDelegate, which is basically like the git staging area
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        whereIsMySQLite()
        
        // retrieving the local data from UserDefaults and safe checking to see if there are values inside
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //            itemArray = items
        //        }
        
    }
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title

            // ternary operator => value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // COREDATA
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
//        let item = todoItems[indexPath.row]
//
//        // if user selects an item, it will toggle done or not done
//        item.done = !item.done
//
//        saveItems()
        
        // REALM
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error saving done status, \(error)")
            }
            
        }
        
        // reload the tableview to show updated done status
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what happens once the user clicks the add item button on our UIAlert
            
            // COREDATA
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
            
            // save itemArray in user defaults
            //            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // REALM
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
                
            }
            
            self.tableView.reloadData()
        }
        
        // adding the textfield to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Model Manipulation Methods
    
    
    // reading data from the database
    // the parameter is a request but also has a default value if one is not provided on the function call
    // COREDATA
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
////        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        // query to retrieve items that match the parent category
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        // safe unwrapping to allow additional predicates (such as the search bar functionality)
//        // if it doesn't have an additional predicate, it will only perform the categoryPredicate
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("error fetching data from context: \(error)")
//        }
//    }
    
    // REALM
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    
    // MARK: - get SQLite path
//    func whereIsMySQLite() {
//        let path = FileManager
//            .default
//            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
//            .last?
//            .absoluteString
//            .replacingOccurrences(of: "file://", with: "")
//            .removingPercentEncoding
//
//        print(path ?? "Not found")
//    }
    
}

// MARK: - UISearchBarDelegate Methods

extension TodoListVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // COREDATA
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        // predicate acts like a query or filter, using the format to specify what to filter
//        // adding the [cd] ignores case and acentos sensitivity
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        // setting the descriptor. note that it expects an array or sortDescriptors but if you have one you can just put a single one inside an array
//        // how to sort the data after the request
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        // performing the request
//        loadItems(with: request, predicate: predicate)
        
        // REALM
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

