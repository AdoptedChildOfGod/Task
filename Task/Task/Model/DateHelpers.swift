//
//  DateHelpers.swift
//  Task
//
//  Created by Shannon Draeker on 4/22/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import Foundation

extension Date {
    
    // MARK: - Helper Methods for Strings
    
    // Convert a date object to a nice readable string
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return formatter.string(from: self)
    }
}
