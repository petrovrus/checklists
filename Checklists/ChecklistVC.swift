//
//  ViewController.swift
//  Checklists
//
//  Created by Ruslan on 31/07/2017.
//  Copyright © 2017 Ruslan Petrov. All rights reserved.
//

import UIKit

class ChecklistVC : UITableViewController, ItemDetailVCDelegate {

    var checklist: Checklist!
    
    //MARK: table settings
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem", for: indexPath)
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //MARK: configuring cells
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = item.checked ? "✔️" : ""
    }
    
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }


    //MARK: Protocol ItemDetailVCDelegate conformance
    
    func itemDetailVCDidCancel(
        _ controller: ItemDetailVC) {
        dismiss(animated: true, completion: nil)
    }
    func itemDetailVC(_ controller: ItemDetailVC,
                               didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
    }
    func itemDetailVC(_ controller: ItemDetailVC, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(checklist.items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadChecklistItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            checklist.items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
            unarchiver.finishDecoding()
        }
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "AddItem":
                let navigationController = segue.destination
                    as! UINavigationController
                let controller = navigationController.topViewController as! ItemDetailVC
                controller.delegate = self
            case "EditItem":
                let navigationController = segue.destination
                    as! UINavigationController
                let controller = navigationController.topViewController as! ItemDetailVC
                controller.delegate = self
                if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                    controller.itemToEdit = checklist.items[indexPath.row]
                }
            default:
                print("Add new identifier")
            }
        }
    }

}

