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
    
    override func viewWillAppear(_ animated: Bool) {
        DataModel.instance.sortChecklists()
        tableView.reloadData()
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
        let item = DataModel.instance.lists[indexPath.row]
        configureText(for: cell, withItem: item)

        if item.items.isEmpty {
            cell.detailTextLabel?.text = "(No Item)"
        } else {
            switch (item.items.count, item.uncheckedItemsCount) {
                case (0, _): cell.detailTextLabel?.text = "(No Item)"
                case (_, 0): cell.detailTextLabel?.text = "All Done!"
                case (_, let nbr): cell.detailTextLabel?.text = "\(nbr) restants"
            }
        }
        
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
