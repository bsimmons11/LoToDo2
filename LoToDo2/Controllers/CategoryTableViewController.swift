//
//  CategoryTableViewController.swift
//  LoToDo2
//
//  Created by Brady Simmons on 7/16/18.
//  Copyright © 2018 Brady Simmons. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var catArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCats()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new LoToDo Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCat = Category(context: self.context)
            newCat.name = textField.text!
            //newItem.done = false
            self.catArray.append(newCat)
            self.saveCats()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return catArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let cat = catArray[indexPath.row]
        cell.textLabel?.text = cat.name
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catArray[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    func saveCats() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCats(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            catArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context /(error)")
        }
        
        tableView.reloadData()
        
    }
}
