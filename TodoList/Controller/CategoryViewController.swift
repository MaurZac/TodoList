//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Mauricio Zarate on 08/02/21.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    var category = [Category]()
    let contextCategory = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
       
    }

    @IBAction func addBtnCategory(_ sender: UIBarButtonItem) {
        var textCategory = UITextField()
        let alert = UIAlertController(title: "add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (error) in
            let newcategory = Category(context: self.contextCategory)
            newcategory.name = textCategory.text!
            self.category.append(newcategory)
            self.saveCategory()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add new Category"
            textCategory = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TABLEVIEW DATAsource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        category.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category[indexPath.row].name
        let item = category[indexPath.row]
        return cell
        
    }
  
    //MARK: - TABLEVIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category[indexPath.row]
        }
    }

    //MARK: - DATA Manipulation methods
    
    func saveCategory() {
        do{
            try contextCategory.save()
        }catch{
           print("error saving category \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            category = try contextCategory.fetch(request)
        } catch  {
            print("error loading Categories \(error)")
        }
        tableView.reloadData()
    }
    




}
