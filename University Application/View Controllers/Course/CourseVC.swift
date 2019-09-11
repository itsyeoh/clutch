//
//  CourseVC.swift
//  University Application
//
//  Created by Jason Yeoh on 29/08/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit

class CourseVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classTableView: UITableView!
    @IBOutlet weak var assignmentTableView: UITableView!
    
    private var classes = [Class]()
    private var tasks = [Task]()
    var course: Course!
    var semesterName: String!
    
    var selectedClass: Class!
    var selectedTask: Task!
    var classIndexToEdit: Int?
    var taskIndexToEdit: Int?
    
    override func viewDidLoad() {
        let courseName = course?.showCourseName()
        super.viewDidLoad()
        
        classTableView.dataSource = self
        classTableView.delegate = self
        assignmentTableView.dataSource = self
        assignmentTableView.delegate = self
        
        self.navigationItem.title = courseName! + " (" + semesterName.uppercased() + ")"
        nameLabel.text = courseName
        
        classes = UniversityDB.instance.getCourseClasses(ccid: course.cid)
        tasks = UniversityDB.instance.getCourseTasks(tcid: course.cid)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddClassSegue" {
            let vc = segue.destination as! AddClassVC
            vc.delegate = self
            vc.course = self.course
            vc.newClass = self.selectedClass
            vc.classIndexToEdit = self.classIndexToEdit
            print("Segue performed to \(classIndexToEdit)")
        }
        else if segue.identifier == "toAddTaskSegue" {
            let vc = segue.destination as! AddTaskVC
            vc.delegate = self
            vc.course = self.course
            vc.newTask = self.selectedTask
            vc.taskIndexToEdit = self.taskIndexToEdit
        }
    }
    
    @IBAction func addButtonClicked() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // [ADD CLASS OPTION]
        alert.addAction(UIAlertAction(title: "Add Class", style: .default, handler: {(action) in
            let storyboard = UIStoryboard(name: "AddClass", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! AddClassVC
            vc.delegate = self
            vc.course = self.course
            vc.classIndexToEdit = self.classIndexToEdit
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        
        // [ADD TASK OPTION]
        alert.addAction(UIAlertAction(title: "Add Task", style: .default, handler: {(action) in
            let storyboard = UIStoryboard(name: "AddTask", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! AddTaskVC
            vc.delegate = self
            vc.course = self.course
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}

extension CourseVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == classTableView) { return classes.count }
        else { return tasks.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == classTableView) {
            let aClass = classes[indexPath.row]
            let cell = classTableView.dequeueReusableCell(withIdentifier: "CourseClassTVC") as! CourseClassTVC
            
            cell.setup(aClass: aClass)
            return cell
        } else {
            let task = tasks[indexPath.row]
            let cell = assignmentTableView.dequeueReusableCell(withIdentifier: "CourseAssignmentTVC") as! CourseAssignmentTVC
            
            cell.setup(task: task)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == classTableView) {
            selectedClass = classes[indexPath.row]
            self.classIndexToEdit = indexPath.row
            self.performSegue(withIdentifier: "toAddClassSegue", sender: nil)
        } else {
            selectedTask = tasks[indexPath.row]
            self.taskIndexToEdit = indexPath.row
            self.performSegue(withIdentifier: "toAddTaskSegue", sender: nil)
        }
    }
    
    // Supports deletion
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delete = UIContextualAction(style: .destructive, title: "Delete")
//        { (contextualAction, view, actionPerformed: @escaping (Bool)->()) in
//
//            let alert = UIAlertController(title: "Delete Class", message: "Sure ka baks?", preferredStyle: .alert)
//
//            alert.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
//                actionPerformed(false)
//            })))
//
//            alert.addAction((UIAlertAction(title: "Delete", style: .destructive, handler: { (alertAction) in
//                // Perform delete
//                let aClass = self.classes[indexPath.row]
//
//                if UniversityDB.instance.deleteClass(id: aClass.clid) {
//                    self.classes.remove(at: indexPath.row)
//                    self.classTableView.deleteRows(at: [indexPath], with: .fade)
//                }
//
//                actionPerformed(true)
//            })))
//
//            self.present(alert, animated: true)
//        }
//
//        delete.backgroundColor = Theme.Primary
//
//        return UISwipeActionsConfiguration(actions: [delete])
//    }
}

//protocol CourseToClassDelegate {
//    func getClass(aClass: Class)
//}

extension CourseVC: AddClassDelegate, AddTaskDelegate {
    func addClass(aClass: Class) {
        self.navigationController?.popViewController(animated: true)
        self.classes.append(aClass)
        self.classTableView.reloadData()
    }
    
    func updateClass(index: Int, aClass: Class) {
        self.navigationController?.popViewController(animated: true)
        self.classes[index] = aClass
        self.classTableView.reloadData()
        self.classIndexToEdit = nil
    }
    
    func addTask(task: Task) {
        self.navigationController?.popViewController(animated: true)
        self.tasks.append(task)
        self.assignmentTableView.reloadData()
    }
    
    func updateTask(index: Int, task: Task) {
        self.navigationController?.popViewController(animated: true)
        self.tasks[index] = task
        self.assignmentTableView.reloadData()
        self.taskIndexToEdit = nil
    }
}
