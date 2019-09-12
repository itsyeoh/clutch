//
//  AddTaskVC.swift
//  UniversityApplication
//
//  Created by Jason Yeoh on 05/09/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation
import Eureka

protocol AddTaskDelegate {
    func addTask(task: Task)
    func updateTask(index: Int, task: Task)
}

class AddTaskVC: FormViewController {
    private var courses = [Course]()
    private var courseList = [Int64:String]()
    private var selectedCourse: (Int64, String)?
    var delegate: AddTaskDelegate?
    var taskIndexToEdit: Int?
    var newTask: Task?
    var course: Course?
    var isChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addTask))
        
        courses = UniversityDB.instance.getCourses()
        for crs in courses {
            courseList[crs.cid] = crs.showCourseName()
        }
        
        form +++ Section("ADD TASK")
            <<< PushRow<String>("tCourseRow") {
                let courseNames = [String](courseList.values)

                $0.title = "Course"
                $0.options = courseNames
                if course != nil {
                    $0.value = course?.showCourseName()
                } else {
                    $0.value = courseNames.count > 0 ? courseNames[0] : ""
                }
                
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.backgroundColor = Theme.Secondary_2
                        cell.textLabel?.textColor = Theme.Secondary
                    } else {
                        cell.backgroundColor = .white
                }})
            
            +++ Section("NAME & DESCRIPTION")
            <<< TextRow("nameRow") {
                $0.placeholder = "Name"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.backgroundColor = Theme.Secondary_2
                    } else {
                        cell.backgroundColor = .white
                }})
            
            
            <<< TextAreaRow("descRow") {
                $0.title = "Description"
                $0.placeholder = "Input your description here"
                }
            
            +++ Section("TYPE & DATE")
            <<< PushRow<String>("aTypeRow") {
                $0.title = "Assignment Type"
                $0.options = ["Quiz", "Reading", "Project", "Homework", "Lab Report", "Paper"]
                $0.value = "Quiz"    // initially selected
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.backgroundColor = Theme.Secondary_2
                        cell.textLabel?.textColor = Theme.Secondary
                    } else {
                        cell.backgroundColor = .white
                }})
        
            <<< DateInlineRow("dueDateRow") {
                $0.title = "Due Date"
                $0.value = Date(timeIntervalSinceNow: 0)
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.backgroundColor = Theme.Secondary_2
                        cell.textLabel?.textColor = Theme.Secondary
                    } else {
                        cell.backgroundColor = .white
                }})
        
            <<< TimeInlineRow("dueTimeRow") {
                $0.title = "Due Time"
                $0.value = Date(timeIntervalSinceNow: 0)
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.backgroundColor = Theme.Secondary_2
                        cell.textLabel?.textColor = Theme.Secondary
                    } else {
                        cell.backgroundColor = .white
                }})
        // Plug in all values for an existing task
        if let index = taskIndexToEdit {
            form.setValues(["tCourseRow": course?.showCourseName(), "nameRow": newTask?.taskName,
                            "descRow": newTask?.description, "aTypeRow": newTask?.taskType,
                            "dueDateRow": newTask?.taskDate, "dueTimeRow": newTask?.taskTime])
            isChecked = newTask!.isChecked
        }
    }//end viewDidLoad()
    
    @objc func addTask() {
        if form.validate() == [] {
            // Access row data
            let courseRow: PushRow<String>? = form.rowBy(tag: "tCourseRow")
            let nameRow: TextRow? = form.rowBy(tag: "nameRow")
            let descRow: TextAreaRow? = form.rowBy(tag: "descRow")
            let aTypeRow: PushRow<String>? = form.rowBy(tag: "aTypeRow")
            let dueDateRow: DateInlineRow? = form.rowBy(tag: "dueDateRow")
            let dueTimeRow: TimeInlineRow? = form.rowBy(tag: "dueTimeRow")
            
            // Access row data values
            let ccid = courseList.filter {$0.value == (courseRow?.value)!}.map{$0.0}.first!
            let taskName = (nameRow?.value)!
            let taskType = (aTypeRow?.value)!
            let taskDate = (dueDateRow?.value)!
            let taskTime = (dueTimeRow?.value)!
            let description = descRow?.value ?? ""
            
            if let index = taskIndexToEdit {
                let aTask = Task(cid: ccid, tid: newTask!.tid, taskName: taskName, taskType: taskType,
                                 taskDate: taskDate, taskTime: taskTime, description: description,
                                 isChecked: self.isChecked)
                
                if UniversityDB.instance.updateTask(id: aTask.tid, newTask: aTask) {
                    delegate?.updateTask(index: index, task: aTask)
                }
            } else {
                // Insert task to the database
                if let id = UniversityDB.instance.addTask(ccid: ccid, ctaskName: taskName, ctaskType: taskType,
                                                          ctaskDate: taskDate, ctaskTime: taskTime,
                                                          cdescription: description) {
                    let task = Task(cid: ccid, tid: id, taskName: taskName, taskType: taskType,
                                    taskDate: taskDate, taskTime: taskTime, isChecked: false)
                    delegate?.addTask(task: task)       // Communicate with delegate VCs
                }
            }
        }//end validation
    }//end addTask()
}

enum RepeatInterval : String, CaseIterable, CustomStringConvertible {
    case Never = "Never"
    case Every_Day = "Every Day"
    case Every_Week = "Every Week"
    case Every_2_Weeks = "Every 2 Weeks"
    case Every_Month = "Every Month"
    case Every_Year = "Every Year"
    
    var description : String { return rawValue }
}
