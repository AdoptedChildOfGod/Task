//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Shannon Draeker on 4/23/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController {
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Claim the role of being the delegate for the fetchRequestController
        TaskController.shared.fetchedResultsController.delegate = self
    }

    
    // MARK: - Table view data source
    
    // The number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TaskController.shared.fetchedResultsController.sections?.count ?? 0
    }

    // The number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.shared.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    // Configure each section header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TaskController.shared.fetchedResultsController.sectionIndexTitles[section] == "0" ? "Incomplete" : "Complete"
    }

    // Configure each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell() }

        // Get the task to be displayed in the cell
        let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
        
        // Update the cell's view with the task and claim the role of delegate for the cell's button handling protocol
        cell.updateView(withTask: task)
        cell.delegate = self
        
        // Return the cell
        return cell
    }

    // Allow cells to be deleted
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Get the task to be deleted
            let taskToDelete = TaskController.shared.fetchedResultsController.object(at: indexPath)
            
            // Delete the task
            TaskController.shared.delete(task: taskToDelete)
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExistingTaskTVC" {
            // Get the index of the selected row and the destination of the segue
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? TaskDetailTableViewController
                else { return }
            
            // Get the task object that was selected
            let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
            
            // Pass the task object to the detail view controller
            destinationVC.task = task
        }
    }
}


// MARK: - Adopt Button Protocol

extension TaskListTableViewController: ButtonTableViewCellDelegate {
    
    func buttonCellButtonTapped(for cell: ButtonTableViewCell) {
        // Get the index path of the cell
        guard let indexPath = tableView.indexPath(for: cell) else { return }

        // Get the task object that was clicked
        let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
        
        // Toggle the value of the task's isCompleted property
        TaskController.shared.toggleIsCompleted(for: task)
        
        // Refresh the view to reflect the changes
        cell.updateView(withTask: task)
    }
}


// MARK: - Conform to NSFRC Protocol

extension TaskListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // Adding and deleting cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            guard let indexPath = indexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        case .insert:
            guard let newIndexPath = newIndexPath else { break }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { break }
            tableView.moveRow(at: indexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        @unknown default:
            fatalError()
        }
    }
    
    // Adding and deleting sections
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            case .move:
                break
            case .update:
                break
            @unknown default:
                fatalError()
        }
    }
}
