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
        }
    }
    

    
    @IBAction func done() {
        print(itemField.text)
        if (itemToEdit != nil) {
            delegate?.addItemViewController(self, didFinishAddingItem: ChecklistItem(textV: itemField.text!))
        } else {
            delegate?.addItemViewController(self, didFinishEditingItem: ChecklistItem(textV: itemField.text!))
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
