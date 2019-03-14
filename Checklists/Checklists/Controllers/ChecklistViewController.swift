//
//  ViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 LPIEM Lyon1. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    var delegate: CheckListViewControllerDelegate?
    var list: Checklist!
    var items: [ChecklistItem] = []
    static var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    static var dataFileUrl: URL {
        return ChecklistViewController.documentDirectory.appendingPathComponent("checklist").appendingPathExtension("json")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("DocumentDirectory: \(ChecklistViewController.documentDirectory)")
        print("DocumentDirectory: \(ChecklistViewController.dataFileUrl)")
        navigationItem.title = list.name
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
        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        saveChecklistItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadChecklistItems()
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
    
    //MARK:- JSON Save and load
    func saveChecklistItems() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let newData = try? encoder.encode(items)
        print(String(data: newData!, encoding: .utf8)!)
        try? newData?.write(to: ChecklistViewController.dataFileUrl)
    }
    
    func loadChecklistItems() {
        let decoder = JSONDecoder()
        let data = try FileManager.default.contents(atPath: ChecklistViewController.dataFileUrl.path)
        print(String(data: data!, encoding: .utf8)!)
        if (data != nil) {
            let items = try? decoder.decode([ChecklistItem].self, from: data!)
            if items != nil {
                self.items = items!
            } else {
                print("Error: Can't decode Data to items array")
            }
        } else {
            print("Error: Can't read file to get Data")
        }
    }

    @IBAction func addDummyTodo(_ sender: UIBarButtonItem) {
        let indexPath = IndexPath(row: items.count, section: 0)
        items.append(ChecklistItem(textV: "dummy", checkedV: false))
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.checkListViewControllerDidCancel(self)
    }
    
    //MARK:- Prepare for segue AddItemViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "addItem" {
            let firstDest = segue.destination as! UINavigationController
            let destinationVC = firstDest.topViewController as! ItemDetailViewController
            destinationVC.delegate = self
        }
        
        if segue.identifier == "editItem" {
            let firstDest = segue.destination as! UINavigationController
            let destinationVC = firstDest.topViewController as! ItemDetailViewController
            guard let id = tableView.indexPath(for: sender as! ChecklistItemCell) else {
                return
            }
            destinationVC.itemToEdit = items[id.row]
            destinationVC.delegate = self
        }
    }
    
}

protocol CheckListViewControllerDelegate : class {
    func checkListViewControllerDidCancel(_ controller: ChecklistViewController)
}

//MARK:- EXT: ItemDetailDelegate funcs
extension ChecklistViewController : ItemDetailViewControllerDelegate {
    
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        dismiss(animated: true)
        let indexPath = IndexPath(row: items.count, section: 0)
        items.append(item)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        dismiss(animated: true)
        print("Testing item: " + item.text)
        if let row = items.index(where: {$0 === item}) {
            print("Item found at: \(row)")
            let indexPath = IndexPath(row: row, section: 0)
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        saveChecklistItems()
    }
}


