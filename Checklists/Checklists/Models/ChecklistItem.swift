//
//  ChecklistItem.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 LPIEM Lyon1. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text: String
    var checked: Bool
    
    init(textV: String, checkedV: Bool = false) {
        text = textV
        checked = checkedV
    }
    
    func toggleChecked() {
        checked = !checked
    }
}
