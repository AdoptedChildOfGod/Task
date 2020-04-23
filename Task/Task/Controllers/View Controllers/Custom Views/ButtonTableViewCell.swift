//
//  ButtonTableViewCell.swift
//  Task
//
//  Created by Shannon Draeker on 4/22/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit

// MARK: - Protocol to Handle Button

protocol ButtonTableViewCellDelegate: class {
    func buttonCellButtonTapped(for cell: ButtonTableViewCell)
}


class ButtonTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    
    // MARK: - Properties
    
    weak var delegate: ButtonTableViewCellDelegate?
    
    
    // MARK: - Actions
    
    // Respond to the button being tapped
    @IBAction func buttonTapped(_ sender: UIButton) {
        // Call the delegate's function to handle the button being tapped
        delegate?.buttonCellButtonTapped(for: self)
    }
    
    
    // Update the button based on whether the task is completed or not
    func updateButton(with isComplete: Bool) {
        completeButton.setImage(isComplete ? #imageLiteral(resourceName: "complete") : #imageLiteral(resourceName: "incomplete"), for: .normal)
    }
}

extension ButtonTableViewCell {
    
    // Update the cell's view with information from the task object
    func updateView(withTask task: Task) {
        // Change the name of the label
        primaryLabel.text = task.name
        
        // Set the image of the button appropriately
        updateButton(with: task.isComplete)
    }
}
