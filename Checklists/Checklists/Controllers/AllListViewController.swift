//
//  AllListViewController.swift
//  Checklists
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 LPIEM Lyon1. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController, CheckListViewControllerDelegate {

    var lists: [Checklist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lists.append(Checklist(nameV: "Musiques"))
        lists.append(Checklist(nameV: "Courses"))
        lists.append(Checklist(nameV: "Matos nouveau PC"))
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistsItem", for: indexPath)
        configureText(for: cell, withItem: lists[indexPath.row])

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
            destinationVC.list = lists[id.row]
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
            destinationVC.listToEdit = lists[id.row]
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
        let indexPath = IndexPath(row: lists.count, section: 0)
        lists.append(item)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        //saveChecklistItems()
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingList item: Checklist) {
        dismiss(animated: true)
        if let row = lists.index(where: {$0 === item}) {
            print("Item found at: \(row)")
            let indexPath = IndexPath(row: row, section: 0)
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        //saveChecklistItems()
    }
}
