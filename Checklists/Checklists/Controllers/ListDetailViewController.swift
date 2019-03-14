//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by lpiem on 14/03/2019.
//  Copyright © 2019 LPIEM Lyon1. All rights reserved.
//

import UIKit

class ListDetailViewController: UITableViewController {
    
    @IBOutlet weak var listField: UITextField!
    var delegate: ListDetailViewControllerDelegate?
    var listToEdit: Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (listToEdit != nil) {
            listField.text = listToEdit?.name
            self.title = "Edit Item"
        }
    }
    
    
    
    @IBAction func done() {
        //print(listField.text)
        if listToEdit != nil {
            listToEdit!.name = listField.text!
            delegate?.listDetailViewController(self, didFinishEditingList: listToEdit!)
        } else {
            delegate?.listDetailViewController(self, didFinishAddingList: Checklist(nameV: listField.text!))
        }
    }
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listField.becomeFirstResponder()
    }
    
}

protocol ListDetailViewControllerDelegate : class {
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingList item: Checklist)
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingList item: Checklist)
}
