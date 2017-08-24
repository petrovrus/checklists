//
//  Checklist.swift
//  Checklists
//
//  Created by Ruslan on 19/08/2017.
//  Copyright © 2017 Ruslan Petrov. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name = ""
    var items = [ChecklistItem]()
    
    init(named name: String) {
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }
    
    func countUncheckedItems() -> Int {
        return items.reduce(0) { count, item in count + (item.checked ? 0 : 1) }
    }
}
