//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Shannon Draeker on 4/22/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController {
    
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Reload the data so that it refreshes when the user returns from the detail view
        tableView.reloadData()
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.shared.tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell() }
        
        // Get the task to be displayed
        let task = TaskController.shared.tasks[indexPath.row]
        
        // Fill in the cell's details
        cell.updateView(withTask: task)
        
        // Claim the role of the cell's delegate
        cell.delegate = self

        // Return the cell
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Get the task to be deleted
            let taskToDelete = TaskController.shared.tasks[indexPath.row]
            
            // Delete the task
            TaskController.shared.delete(task: taskToDelete)
            
            // Update the view in the tableview
            tableView.deleteRows(at: [indexPath], with: .fade)
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
            let task = TaskController.shared.tasks[indexPath.row]
            
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
        let task = TaskController.shared.tasks[indexPath.row]
        
        // Toggle the value of the task's isCompleted property
        TaskController.shared.toggleIsCompleted(for: task)
        
        // Refresh the view to reflect the changes
        cell.updateView(withTask: task)
    }
}
