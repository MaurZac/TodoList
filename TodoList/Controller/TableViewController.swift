//
//  ViewController.swift
//  TodoList
//
//  Created by Mauricio Zarate on 31/01/21.
//

import UIKit
import CoreData
import RealmSwift

class TableViewController: SwipeTableViewController, UIPickerViewDelegate, UIImagePickerControllerDelegate {
    var itemArray: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 85.0
        loadItems()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        }
        // Do any additional setup after loading the view.
//MARK - table
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemArray?[indexPath.row]{
            cell.textLabel?.text = itemArray![indexPath.row].title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    override func updatemodel(at indexPath: IndexPath) {
        if let task = self.itemArray?[indexPath.row]{
        do{
            try self.realm.write {
                self.realm.delete(task)
            }
        }
        catch{
            print("Error \(error)")
         }
        }
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if let item =  itemArray?[indexPath.row]{
//            do {
//                try realm.write{
//                    realm.delete(item)
//                }
//            } catch  {
//                print("error:\(error)")
//            }
//        }
//        tableView.reloadData()
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    @IBAction func addNew(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add new task ", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add Item", style: .default) { (action) in
            //what happens after click add btn
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textfield.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("error adding new task \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "add new task"
            textfield = alertTextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems(){
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

extension TableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
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

