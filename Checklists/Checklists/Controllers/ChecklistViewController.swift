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
    //var items: [ChecklistItem] = [ChecklistItem(textV: "DummyItem1", checkedV: true), ChecklistItem(textV: "DummyItem2", checkedV: false)]
    
    override func viewWillAppear(_ animated: Bool) {
        DataModel.instance.sortChecklists()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("DocumentDirectory: \(DataModel.instance.documentDirectory)")
        print("DocumentDirectory: \(DataModel.instance.dataFileUrl)")
        navigationItem.title = list.name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath) as? ChecklistItemCell else {
            return UITableViewCell()
        }

        configureText(for: cell, withItem: list.items[indexPath.row])
        configureCheckmark(for: cell, withItem: list.items[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        list.items[indexPath.row].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        DataModel.instance.saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        list.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        DataModel.instance.saveChecklistItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        DataModel.instance.loadChecklistItems()
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
        let indexPath = IndexPath(row: list.items.count, section: 0)
        list.items.append(ChecklistItem(textV: "dummy", checkedV: false))
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
            destinationVC.itemToEdit = list.items[id.row]
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
        let indexPath = IndexPath(row: list.items.count, section: 0)
        list.items.append(item)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        DataModel.instance.saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        dismiss(animated: true)
        print("Testing item: " + item.text)
        if let row = list.items.index(where: {$0 === item}) {
            print("Item found at: \(row)")
            let indexPath = IndexPath(row: row, section: 0)
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        DataModel.instance.saveChecklistItems()
    }
}


