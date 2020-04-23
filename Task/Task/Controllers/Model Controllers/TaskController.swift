//
//  TaskController.swift
//  Task
//
//  Created by Shannon Draeker on 4/22/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    // MARK: - Singleton
    
    static let shared = TaskController()
    
    
    // MARK: - Source of Truth
    
    let fetchedResultsController: NSFetchedResultsController<Task>
    
    init() {
        // Create the fetch request
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Define how the fetched data should be sorted
        request.sortDescriptors = [NSSortDescriptor(key: "isComplete", ascending: true), NSSortDescriptor(key: "due", ascending: true)]
        
        // Create the controller and define how it should handle the fetched results
        let requestsController: NSFetchedResultsController<Task> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
        fetchedResultsController = requestsController
        
        // Use the fetched results controller to fetch the data
        do {
          try fetchedResultsController.performFetch()
        } catch {
             print("There was an error performing the fetch \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - CRUD Methods
    
    // Create a new task
    func createTaskWith(name: String, notes: String?, due: Date?) {
        // Create the task
        _ = Task(name: name, notes: notes, due: due)
        
        // Save the changes
        saveToPersistantStorage()
    }

    // Update an existing task with new information
    func update(task: Task, name: String, notes: String?, due: Date?) {
        // Update all the values of the task
        task.name = name
        task.notes = notes
        task.due = due
        
        // Save the changes
        saveToPersistantStorage()
    }
    
    // Update an existing task by toggling its completed property
    func toggleIsCompleted(for task: Task) {
        // Change the state of the task's completion property
        task.isComplete = !task.isComplete
        
        // Save the changes
        saveToPersistantStorage()
    }
    
    // Delete a task
    func delete(task: Task) {
        if let moc = task.managedObjectContext {
            // Delete the task
            moc.delete(task)
            
            // Save the changes
            saveToPersistantStorage()
        }
    }
    
    
    // MARK: - Persistence
    
    // Save to Core Data
    func saveToPersistantStorage() {
        let moc = CoreDataStack.context
        do {
            try moc.save()
        } catch let saveError {
            print("Error in saving to Core Data: \(saveError)")
        }
    }
}
