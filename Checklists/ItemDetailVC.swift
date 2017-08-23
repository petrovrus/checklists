//
//  ItemDetailVC.swift
//  Checklists
//
//  Created by Ruslan on 07/08/2017.
//  Copyright © 2017 Ruslan Petrov. All rights reserved.
//

import Foundation
import UIKit

protocol ItemDetailVCDelegate {
    func itemDetailVCDidCancel(_ controller: ItemDetailVC)
    func itemDetailVC(_ controller: ItemDetailVC,
                   didFinishAdding item: ChecklistItem)
    func itemDetailVC(_ controller: ItemDetailVC,
                   didFinishEditing item: ChecklistItem)
}

class ItemDetailVC: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var delegate: ItemDetailVCDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancel() {
        delegate?.itemDetailVCDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailVC(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            delegate?.itemDetailVC(self, didFinishAdding: item)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            title = "Edit item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    
}

