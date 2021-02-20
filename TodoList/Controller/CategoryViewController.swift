//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Mauricio Zarate on 08/02/21.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    
    var category: Results<Category>?
    var realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
        tableView.rowHeight = 85.0
    }
    
//    CREATE
    func saveCategory(category: Category) {
        do{
            try! realm.write{
                realm.add(category)
            }
        }catch{
           print("error saving category \(error)")
        }
     
        self.tableView.reloadData()
    }
    
//    LOAD
    
    func loadCategories(){
        category = realm.objects(Category.self)
        self.tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
//    DELETE DATA FROM SWIPE
    override func updatemodel(at indexPath: IndexPath) {
                if let categoryForDelete = self.category?[indexPath.row]{
                do{
                    try self.realm.write {
                        self.realm.delete(categoryForDelete)
                    }
                }
                catch{
                    print("Error \(error)")
                 }
                }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = category?[indexPath.row].categoryName ?? "No cat added yet"
        cell.backgroundColor = UIColor(hexString: category?[indexPath.row].color ?? "1D9BF6")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    @IBAction func addBtnCategory(_ sender: UIBarButtonItem) {
        var textCategory = UITextField()
        let alert = UIAlertController(title: "add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (error) in
            let newcategory = Category()
            newcategory.categoryName = textCategory.text!
            newcategory.color = UIColor.randomFlat().hexValue()
            
            self.saveCategory(category: newcategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add new Category"
            textCategory = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category?[indexPath.row]
        }
    }
}


