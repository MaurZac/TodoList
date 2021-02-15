//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Mauricio Zarate on 08/02/21.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    
    var category: Results<Category>?
    var realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
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
    
    func loadCategories(){
        category = realm.objects(Category.self)
        self.tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category?[indexPath.row].categoryName ?? "No cat added yet"
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
