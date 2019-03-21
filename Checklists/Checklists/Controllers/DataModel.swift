//
//  DataModel.swift
//  Checklists
//
//  Created by lpiem on 14/03/2019.
//  Copyright © 2019 LPIEM Lyon1. All rights reserved.
//

import Foundation;
import UIKit;

class DataModel {
    
    // MARK: - Properties
    var lists: [Checklist] = []
    static let instance = DataModel()
    
    // Initialization
    
    init() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveChecklistItems),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        
    }
    
    var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var dataFileUrl: URL {
        return self.documentDirectory.appendingPathComponent("checklist").appendingPathExtension("json")
    }
    
    //MARK:- JSON Save and load
    @objc
    func saveChecklistItems() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let newData = try? encoder.encode(self.lists)
        print(String(data: newData!, encoding: .utf8)!)
        try? newData?.write(to: self.dataFileUrl)
    }
    
    func loadChecklistItems() {
        let decoder = JSONDecoder()
        let data = try FileManager.default.contents(atPath: self.dataFileUrl.path)
        //print(String(data: data!, encoding: .utf8)!)
        if (data != nil) {
            let items = try? decoder.decode([Checklist].self, from: data!)
            if items != nil {
                self.lists = items!
            } else {
                print("Error: Can't decode Data to items array")
            }
        } else {
            print("Error: Can't read file to get Data")
        }
    }
    
    func sortChecklists() {
        var ans: [Checklist] = self.lists
        for (index, item) in self.lists.enumerated() {
            ans[index].items = item.items.sorted {
                (s1, s2) -> Bool in return s1.text.localizedStandardCompare(s2.text) == .orderedAscending
            }
        }
        ans = ans.sorted {
            (s1, s2) -> Bool in return s1.name.localizedStandardCompare(s2.name) == .orderedAscending
        }
        self.lists = ans
    }
    
}
