//
//  TaskDetailTableViewController.swift
//  Task
//
//  Created by Shannon Draeker on 4/22/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDueTextField: UITextField!
    @IBOutlet weak var taskNotesTextView: UITextView!
    
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    
    // MARK: - Properties
    
    var task: Task?
    
    // Keep track of the value in the due date picker
    var dueDateValue: Date?
    
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the keyboard input for the due date picker
        taskDueTextField.inputView = dueDatePicker
        
        // Fill in the fields from the existing task object, if applicable
        updateViews()
    }
    
    func updateViews() {
        // Fill in the fields of the view with the task's information, if it exists
        guard let task = task else { return }
        
        taskNameTextField.text = task.name
        if let due = task.due {
            taskDueTextField.text = due.toString()
            // Make sure to also update the dueDateValue
            dueDateValue = due
        }
        if let notes = task.notes {
            taskNotesTextView.text = notes
        }
    }
    
    
    // MARK: - Actions
    
    // Handle the due date being changed on the date picker input
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        // Reflect the changed value in both the local variable and in the text field
        dueDateValue = dueDatePicker.date
        taskDueTextField.text = dueDateValue?.toString()
    }
    
    // Close the keyboard when the user taps outside it
    @IBAction func userTappedView(_ sender: UITapGestureRecognizer) {
        resignFirstResponder()
    }
    
    // Handle the save button being clicked
    @IBAction func saveTaskButtonTapped(_ sender: UIBarButtonItem) {
        // Make sure there's valid input in the name text field
        guard let taskName = taskNameTextField.text, !taskName.isEmpty else { return }
        
        // If the task already exists, update it
        if let task = task {
            TaskController.shared.update(task: task, name: taskName, notes: taskNotesTextView.text, due: dueDateValue)
        }
        // Otherwise, create a new task
        else {
            TaskController.shared.createTaskWith(name: taskName, notes: taskNotesTextView.text, due: dueDateValue)
        }
        
        // Close the detail view and return to the list of tasks view
        navigationController?.popViewController(animated: true)
    }
}
