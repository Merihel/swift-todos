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
    var icon: IconAsset
    
    init(nameV: String, itemsV: [ChecklistItem] = [], iconV: IconAsset = IconAsset.NoIcon) {
        name = nameV
        items = itemsV
        icon = iconV
    }
    
    var uncheckedItemsCount: Int {
        return items.filter({!$0.checked}).count
    }
}
