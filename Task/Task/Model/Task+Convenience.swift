//
//  Task+Convenience.swift
//  Task
//
//  Created by Shannon Draeker on 4/22/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    
    convenience init(name: String, notes: String? = nil, due: Date? = nil, isComplete: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
         
        self.init(context: context)
        
        self.name = name
        self.notes = notes
        self.due = due
        self.isComplete = isComplete
    }
}
