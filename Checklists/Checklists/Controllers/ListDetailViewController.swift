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
    var currentIcon: IconAsset = IconAsset.Folder
    @IBOutlet weak var iconImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (listToEdit != nil) {
            listField.text = listToEdit?.name
            iconImage.image = listToEdit?.icon.image
            currentIcon = listToEdit!.icon
            self.title = "Edit Item"
        } else {
            iconImage.image = IconAsset.Folder.image
            currentIcon = IconAsset.Folder
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "iconPicker") {
            let destinationVC = segue.destination as! IconPickerViewController
            destinationVC.delegate = self
        }
    }
    
    @IBAction func done() {
        //print(listField.text)
        if listToEdit != nil {
            listToEdit!.name = listField.text!
            delegate?.listDetailViewController(self, didFinishEditingList: listToEdit!)
        } else {
            delegate?.listDetailViewController(self, didFinishAddingList: Checklist(nameV: listField.text!, iconV: currentIcon))
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

extension ListDetailViewController : IconPickerViewControllerDelegate {
    func iconPickerViewController(_ controller: IconPickerViewController, didChooseIcon icon: IconAsset) {
        iconImage.image = icon.image
        currentIcon = icon
        listToEdit?.icon = icon
    }
}
