//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Ruslan on 01/08/2017.
//  Copyright © 2017 Ruslan Petrov. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    override init() {
        super.init()
    }
    
    init(containing text: String) {
        super.init()
        self.text = text
        self.checked = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
}
