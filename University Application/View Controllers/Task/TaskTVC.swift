//
//  TaskTVC.swift
//  University Application
//
//  Created by Jason Yeoh on 30/08/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit

class TaskTVC: UITableViewCell {

    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var tickButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(task: Task) {
        courseNameLabel.text = task.getCourse().showCourseName()
        taskNameLabel.text = task.taskName
        
        if tickButton.isSelected {
            tickButton.setImage(UIImage(named: "Checkbox_Selected"), for: .normal)
        } else {
            tickButton.setImage(UIImage(named: "Checkbox_Empty"), for: .normal)
        }
    }
    
    func setupByCourseName(task: Task) {
        courseNameLabel.text = "DUE ON " + task.getWeekDayToString()
        taskNameLabel.text = task.taskName
        
        if tickButton.isSelected {
            tickButton.setImage(UIImage(named: "Checkbox_Selected"), for: .normal)
        } else {
            tickButton.setImage(UIImage(named: "Checkbox_Empty"), for: .normal)
        }
    }
    
    func buttonSelected() {
        tickButton.setImage(UIImage(named: "Checkbox_Selected"), for: .normal)
    }

    func buttonDeselected() {
        tickButton.setImage(UIImage(named: "Checkbox_Empty"), for: .normal)
    }
}
