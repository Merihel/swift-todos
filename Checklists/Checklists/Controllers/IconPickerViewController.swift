//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by lpiem on 21/03/2019.
//  Copyright © 2019 LPIEM Lyon1. All rights reserved.
//

import Foundation
import UIKit

class IconPickerViewController: UITableViewController {
    
    var delegate: IconPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IconAsset.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath) as? UITableViewCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = IconAsset.allCases[indexPath.row].rawValue
        cell.imageView?.image = IconAsset.allCases[indexPath.row].image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.iconPickerViewController(self, didChooseIcon: IconAsset.allCases[indexPath.row])
        //TODO changer l'icon dans les cells
        navigationController?.popViewController(animated: true)
        
    }
}

protocol IconPickerViewControllerDelegate: class {
    func iconPickerViewController(_ controller: IconPickerViewController, didChooseIcon icon: IconAsset)
}
