//
//  ViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 LPIEM Lyon1. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {

    var items: [ChecklistItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        items.append(ChecklistItem(textV: "Test1", checkedV: true))
        items.append(ChecklistItem(textV: "Test2"))
        items.append(ChecklistItem(textV: "Test3", checkedV: false))
        items.append(ChecklistItem(textV: "Test4", checkedV: true))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) as? ChecklistItemCell else {
            return UITableViewCell()
        }

        configureText(for: cell, withItem: items[indexPath.row])
        configureCheckmark(for: cell, withItem: items[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.row].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    
    func configureCheckmark(for cell: ChecklistItemCell, withItem item: ChecklistItem) {
        
        if (item.checked) {
            cell.cellCheck.isHidden = false
        } else {
            cell.cellCheck.isHidden = true
        }
        
    }
    
    func configureText(for cell: ChecklistItemCell, withItem item: ChecklistItem) {
        cell.cellLabel.text = item.text
    }

    @IBAction func addDummyTodo(_ sender: UIBarButtonItem) {
        let indexPath = IndexPath(row: items.count, section: 0)
        items.append(ChecklistItem(textV: "dummy", checkedV: false))
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    
    //MARK:- Prepare for segue AddItemViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "addItem" {
            let firstDest = segue.destination as! UINavigationController
            let destinationVC = firstDest.topViewController as! AddItemViewController
            destinationVC.delegate = self
        }
        
        if segue.identifier == "editItem" {
            let firstDest = segue.destination as! UINavigationController
            let destinationVC = firstDest.topViewController as! AddItemViewController
            guard let id = tableView.indexPath(for: sender as! ChecklistItemCell) else {
                return
            }
            destinationVC.itemToEdit = items[id.row]
            destinationVC.delegate = self
        }
    }
    
    //MARK:- Delegate funcs
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        dismiss(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: ChecklistItem) {
        dismiss(animated: true)
        let indexPath = IndexPath(row: items.count, section: 0)
        items.append(item)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishEditingItem item: ChecklistItem) {
        dismiss(animated: true)
        if items.index(where:{ $0 === item }) {
        let indexPath = IndexPath(row: 1, section: 0)
        items.append(item)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    
}

