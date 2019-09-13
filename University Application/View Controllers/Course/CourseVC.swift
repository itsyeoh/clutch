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
    @IBOutlet weak var courseControls: UISegmentedControl!
    
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
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
    
    @IBAction func courseControlChanged(_ sender: Any) {
        classTableView.reloadData()
    }
}

extension CourseVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch courseControls.selectedSegmentIndex {
        case 0: return classes.count
        case 1: return tasks.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch courseControls.selectedSegmentIndex {
        case 0:
            let aClass = classes[indexPath.row]
            let cell = classTableView.dequeueReusableCell(withIdentifier: "CourseClassTVC") as! CourseClassTVC
            
            cell.setup(aClass: aClass)
            return cell
        case 1:
            let task = tasks[indexPath.row]
            let cell = classTableView.dequeueReusableCell(withIdentifier: "CourseAssignmentTVC") as! CourseAssignmentTVC
            
            cell.setup(task: task)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch courseControls.selectedSegmentIndex {
        case 0:
            selectedClass = classes[indexPath.row]
            self.classIndexToEdit = indexPath.row
            self.performSegue(withIdentifier: "toAddClassSegue", sender: nil)
        case 1:
            selectedTask = tasks[indexPath.row]
            self.taskIndexToEdit = indexPath.row
            self.performSegue(withIdentifier: "toAddTaskSegue", sender: nil)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch courseControls.selectedSegmentIndex {
            case 0:
                let aClass = self.classes[indexPath.row]
                
                if UniversityDB.instance.deleteClass(id: aClass.clid) {
                    self.classes.remove(at: indexPath.row)
                    self.classTableView.deleteRows(at: [indexPath], with: .fade)
                }
            case 1:
                let task = self.tasks[indexPath.row]
                
                if UniversityDB.instance.deleteTask(id: task.tid) {
                    self.tasks.remove(at: indexPath.row)
                    self.classTableView.deleteRows(at: [indexPath], with: .fade)
                }
            default:
                break
            }
        }
    }
        
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.classTableView.dataSource?.tableView!(self.classTableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = Theme.Primary
        return [deleteButton]
    }
}

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
        self.classTableView.reloadData()
    }
    
    func updateTask(index: Int, task: Task) {
        self.navigationController?.popViewController(animated: true)
        self.tasks[index] = task
        self.classTableView.reloadData()
        self.taskIndexToEdit = nil
    }
}
