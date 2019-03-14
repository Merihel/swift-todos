//
//  Checklist.swift
//  Checklists
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 LPIEM Lyon1. All rights reserved.
//

import Foundation

class Checklist: Codable {
    var name: String
    var items: [ChecklistItem]
    
    init(nameV: String, itemsV: [ChecklistItem] = []) {
        name = nameV
        items = itemsV
    }
}
