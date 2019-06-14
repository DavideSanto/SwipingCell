//
//  MyTableViewController.swift
//  SwipingCell
//
//  Created by Davide Santo on 11.06.19.
//  Copyright © 2019 Davide Santo. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import CoreData

class MyTableViewController: UITableViewController, MGSwipeTableCellDelegate {

    // let itemArray = ["Davide", "Elisa", "Rocco"]
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  // Context used to store on Core Data DB
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }
    //MARK: - Add delegated functions when swiping
    
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
        return true;
    }
    
    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        print("I am here")
        
    
        expansionSettings.fillOnTrigger = true;
        expansionSettings.threshold = 1.1;
        let padding = 15;
        let color1 = UIColor.init(red:1.0, green:59/255.0, blue:50/255.0, alpha:1.0);
        let color2 = UIColor.init(red:1.0, green:149/255.0, blue:0.05, alpha:1.0);
        let color3 = UIColor.init(red:200/255.0, green:200/255.0, blue:205/255.0, alpha:1.0);
        let defaultcolor = UIColor.init(red:0/255.0, green:0/255.0, blue:0/255.0, alpha:1.0);
        
        let trash = MGSwipeButton(title: "Trash", backgroundColor: color1, padding: padding, callback: { (cell) -> Bool in
            print("Delete code to be added")
            let index = self.tableView.indexPath(for: cell)
            cell.textLabel?.textColor = defaultcolor
            self.TrashCell(for: index!)
            return false; //don't autohide to improve delete animation
        })
        
        let flag = MGSwipeButton(title: "Flag", backgroundColor: color2, padding: padding, callback: { (cell) -> Bool in
                cell.textLabel?.textColor = color3
            return true; //autohide
        })
        
        return [trash, flag]
 
        }
        
    
    func TrashCell(for indexPath: IndexPath) {
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MGSwipeTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! MGSwipeTableCell
        
        cell.textLabel?.text = itemArray[indexPath.row].name
        cell.detailTextLabel?.text=String(itemArray[indexPath.row].age)
// Delegation of Cell for the Sweeping functions
        cell.delegate = self
        
        return cell
    }
    
   
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

   /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Add New Items
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var nametextField = UITextField()
        var agetextField = UITextField()
        
        
        let alert1 = UIAlertController(title: "Add New Name & Age", message: "This is to enter new Item", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            
            newItem.name = nametextField.text!
            newItem.age = Int32(agetextField.text!) ?? 0
            
          
            
            self.itemArray.append(newItem)
            self.saveItems()
        }
        alert1.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Name"
            nametextField = alertTextField
        }
        alert1.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Age"
            agetextField = alertTextField
        }
        alert1.addAction(action1)
        present(alert1,animated: true, completion:nil)
    }
    
    //MARK: - Load and Save items in DB
    func loadItems(with request: NSFetchRequest <Item> = Item.fetchRequest()){
        do {
            itemArray =  try context.fetch(request)
        } catch {
            print("Error while attempting to load Items from lcoal Databaase, \(error)")
        }
        tableView.reloadData() // Update view after loading data
    }
    
    func saveItems() {
        // Committing to Database
        do {
            try context.save()
        } catch {
            print("Error while saving Items into DB, \(error)")
        }
            tableView.reloadData()
    }

}
