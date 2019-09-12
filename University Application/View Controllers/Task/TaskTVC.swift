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
//    var delegate: TaskChecklistDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(task: Task) {
        courseNameLabel.text = task.getCourse().showCourseName()
        taskNameLabel.text = task.taskName
        
        if task.isChecked {
            tickButton.setImage(UIImage(named: "Checkbox_Selected"), for: .normal)
        } else {
            tickButton.setImage(UIImage(named: "Checkbox_Empty"), for: .normal)
        }
        
//        if tickButton.isSelected {
//            tickButton.setImage(UIImage(named: "Checkbox_Selected"), for: .normal)
//        } else {
//            tickButton.setImage(UIImage(named: "Checkbox_Empty"), for: .normal)
//        }
    }
    
    func setupByCourseName(task: Task) {
        courseNameLabel.text = "DUE ON " + task.getWeekDayToString()
        taskNameLabel.text = task.taskName
        
        if task.isChecked {
            tickButton.setImage(UIImage(named: "Checkbox_Selected"), for: .normal)
        } else {
            tickButton.setImage(UIImage(named: "Checkbox_Empty"), for: .normal)
        }
    }
    
    func buttonSelected(task: Task) {
        print("SELECTED")
        tickButton.setImage(UIImage(named: "Checkbox_Selected"), for: .normal)
        tickButton.isSelected = true
        UniversityDB.instance.updateTaskByChecking(id: task.tid, checkVar: true)
    }
    
    func buttonDeselected(task: Task) {
        print("DESELECTED")
        tickButton.setImage(UIImage(named: "Checkbox_Empty"), for: .normal)
        tickButton.isSelected = false
        UniversityDB.instance.updateTaskByChecking(id: task.tid, checkVar: false)
    }
    
//    func buttonSelected(index: IndexPath, task: Task) {
//        tickButton.setImage(UIImage(named: "Checkbox_Selected"), for: .normal)
//        if UniversityDB.instance.updateTaskByChecking(id: task.tid, checkVar: true) {
//            let aTask = Task(cid: task.cid, tid: task.tid, taskName: task.taskName,
//                             taskType: task.taskType, taskDate: task.taskDate,
//                             taskTime: task.taskTime, isChecked: true)
//            
//            delegate?.updateTaskChecklist(index: index, task: aTask)
//        }
//    }
//
//    func buttonDeselected(index: IndexPath, task: Task) {
//        tickButton.setImage(UIImage(named: "Checkbox_Empty"), for: .normal)
//        if UniversityDB.instance.updateTaskByChecking(id: task.tid, checkVar: false) {
//            let aTask = Task(cid: task.cid, tid: task.tid, taskName: task.taskName,
//                             taskType: task.taskType, taskDate: task.taskDate,
//                             taskTime: task.taskTime, isChecked: false)
//            
//            delegate?.updateTaskChecklist(index: index, task: aTask)
//        }
//    }
}
