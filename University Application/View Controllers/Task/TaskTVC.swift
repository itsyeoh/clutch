//
//  TaskTVC.swift
//  University Application
//
//  Created by Jason Yeoh on 30/08/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit

//protocol TaskChecklistDelegate {
//    func updateTaskChecklist(index: IndexPath, task: Task)
//}

class TaskTVC: UITableViewCell {
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var tickButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }

    func setup(task: Task, isCompleted: Bool) {
        courseNameLabel.text = task.getCourse().showCourseName()
        taskNameLabel.text = task.taskName
        
        if isCompleted {
            tickButton.setImage(UIImage(named: "Checkbox_Selected"), for: .normal)
        } else {
            tickButton.setImage(UIImage(named: "Checkbox_Empty"), for: .normal)
        }
    }
    
    func setupByCourseName(task: Task, isCompleted: Bool) {
        if isCompleted {
            courseNameLabel.text = "COMPLETED TASK"
            taskNameLabel.text = task.taskName
        }
        else {
            courseNameLabel.text = "DUE ON " + task.getWeekDayToString()
            taskNameLabel.text = task.taskName
        }
    }
}
