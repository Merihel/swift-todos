//
//  AllListViewController.swift
//  Checklists
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 LPIEM Lyon1. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController, CheckListViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        DataModel.instance.loadChecklistItems()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.instance.lists.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistsItem", for: indexPath)
        configureText(for: cell, withItem: DataModel.instance.lists[indexPath.row])

        return cell
    }
    
    func configureText(for cell: UITableViewCell, withItem item: Checklist) {
        cell.textLabel?.text = item.name
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "checklist") {
            let destinationVC = segue.destination as! ChecklistViewController
            guard let id = tableView.indexPath(for: sender as! UITableViewCell) else {
                return
            }
            destinationVC.list = DataModel.instance.lists[id.row]
            destinationVC.delegate = self
        } else if segue.identifier == "addList" {
            let firstDest = segue.destination as! UINavigationController
            let destinationVC = firstDest.topViewController as! ListDetailViewController
            destinationVC.delegate = self
        } else  if segue.identifier == "editList" {
            let firstDest = segue.destination as! UINavigationController
            let destinationVC = firstDest.topViewController as! ListDetailViewController
            guard let id = tableView.indexPath(for: sender as! UITableViewCell) else {
                return
            }
            destinationVC.listToEdit = DataModel.instance.lists[id.row]
            destinationVC.delegate = self
        }
    }
    
    //MARK:- JSON Save and load
    /*
    func saveChecklistItems() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let newData = try? encoder.encode(lists)
        print(String(data: newData!, encoding: .utf8)!)
        try? newData?.write(to: ChecklistViewController.dataFileUrl)
    }
    
    func loadChecklistItems() {
        let decoder = JSONDecoder()
        let data = try FileManager.default.contents(atPath: ChecklistViewController.dataFileUrl.path)
        print(String(data: data!, encoding: .utf8)!)
        if (data != nil) {
            let items = try? decoder.decode([Checklist].self, from: data!)
            if items != nil {
                self.lists = items!
            } else {
                print("Error: Can't decode Data to items array")
            }
        } else {
            print("Error: Can't read file to get Data")
        }
    } */
    
    //MARK - Delegates funcs
    func checkListViewControllerDidCancel(_ controller: ChecklistViewController) {
        dismiss(animated: true)
    }
}

//MARK:- EXT: ListDetailDelegate funcs
extension AllListViewController : ListDetailViewControllerDelegate {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingList item: Checklist) {
        dismiss(animated: true)
        let indexPath = IndexPath(row: DataModel.instance.lists.count, section: 0)
        DataModel.instance.lists.append(item)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        DataModel.instance.saveChecklistItems()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingList item: Checklist) {
        dismiss(animated: true)
        if let row = DataModel.instance.lists.index(where: {$0 === item}) {
            print("Item found at: \(row)")
            let indexPath = IndexPath(row: row, section: 0)
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        DataModel.instance.saveChecklistItems()
    }
}
