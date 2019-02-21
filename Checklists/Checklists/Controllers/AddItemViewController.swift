//
//  AddItemViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 LPIEM Lyon1. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {

    @IBOutlet weak var itemField: UITextField!
    var delegate: AddItemViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (itemToEdit != nil) {
            itemField.text = itemToEdit?.text
            self.title = "Edit Item"
        }
    }
    

    
    @IBAction func done() {
        print(itemField.text)
        if let itemToEdit = itemToEdit {
            itemToEdit.text = itemField.text!
            delegate?.addItemViewController(self, didFinishEditingItem: itemToEdit)
        } else {
            delegate?.addItemViewController(self, didFinishAddingItem: ChecklistItem(textV: itemField.text!))
        }
    }
    
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemField.becomeFirstResponder()
    }
    
}

protocol AddItemViewControllerDelegate : class {
    func addItemViewController(_ controller: AddItemViewController, didFinishEditingItem item: ChecklistItem)
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: ChecklistItem)
}
