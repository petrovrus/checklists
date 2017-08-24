//
//  AllListsVC.swift
//  Checklists
//
//  Created by Ruslan on 18/08/2017.
//  Copyright © 2017 Ruslan Petrov. All rights reserved.
//

import UIKit

class AllListsVC: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

    //var lists: [Checklist]
    
//    required init?(coder aDecoder: NSCoder) {
//        lists = [Checklist]()
//        super.init(coder: aDecoder)
//        loadChecklists()
//    }
    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        } else if count > 0 {
            cell.detailTextLabel!.text = "\(count) Remaining"
        } else {
            cell.detailTextLabel!.text = "All done!"
        }
        return cell
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    @IBAction func addChecklist(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddChecklist", sender: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        dataModel.saveChecklists()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(
            withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        present(navigationController, animated: true, completion: nil)
    }
    
    //MARK: protocol ListDetailVC conformance
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dataModel.saveChecklists()
        
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = dataModel.lists.index(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = checklist.name
            }
        }
        dataModel.saveChecklists()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowChecklist":
                let controller = segue.destination as! ChecklistVC
                controller.checklist = sender as! Checklist
            case "AddChecklist":
                let navigationController = segue.destination as! UINavigationController
                let controller = navigationController.topViewController as! ListDetailViewController
                controller.delegate = self
                controller.checklistToEdit = nil
            default:
                print("unnamed segue")
            }
        }
    }
    
    //MARK: UINavigationControllerDelegate conformance
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}
