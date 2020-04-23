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
    
    var tasks: [Task] { fetchTasks() }

    
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
    
    // Fetch the tasks from Core Data
    func fetchTasks() -> [Task] {
        // Get all the tasks from the Core Data
        let moc = CoreDataStack.context
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let fetchResults = try? moc.fetch(fetchRequest)

        // Return the result
        return fetchResults ?? []
        
//        let mockTask1 = Task(name: "say hi", notes: nil, due: Date())
//        let mockTask2 = Task(name: "do homework", notes: "code and stuff", due: nil)
//        let mockTask3 = Task(name: "eat food", notes: "bacon", due: nil, isComplete: true)
//        
//        return [mockTask1, mockTask2, mockTask3]
    }
}
