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
    
    
    @IBAction func done() {
        print(itemField.text)
        delegate?.addItemViewController(self, didFinishAddingItem: ChecklistItem(textV: itemField.text!))
    }
    
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemField.becomeFirstResponder()
    }
    
}

protocol AddItemViewControllerDelegate : class {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: ChecklistItem)
}
