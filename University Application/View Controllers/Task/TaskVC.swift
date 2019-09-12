//
//  TaskVC.swift
//  University Application
//
//  Created by Jason Yeoh on 30/08/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit

class TaskVC: UIViewController {
    @IBOutlet weak var taskControls: UISegmentedControl!
    @IBOutlet weak var taskTableView: UITableView!
    
    private var tasksByDate = [[Task]]()
    private var tasksByCourseName = [[Task]]()
    private var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "TASKS"
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(openAddTask))
        
        taskTableView.dataSource = self
        taskTableView.delegate = self
        
        tasksByDate = UniversityDB.instance.getTasksByDate()
        tasksByCourseName = UniversityDB.instance.getTasksByCourseName()
        courses = UniversityDB.instance.getCourses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tasksByDate = UniversityDB.instance.getTasksByDate()
        tasksByCourseName = UniversityDB.instance.getTasksByCourseName()
        courses = UniversityDB.instance.getCourses()
    }
    
    @objc func openAddTask() {
        let storyboard = UIStoryboard(name: "AddTask", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! AddTaskVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func taskControlsChanged() {
        self.taskTableView.reloadData()
    }
}

extension TaskVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch taskControls.selectedSegmentIndex {
        case 0: return tasksByDate[section].count ?? 0
        case 1: return tasksByCourseName[section].count ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch taskControls.selectedSegmentIndex {
        case 0:
            let task = tasksByDate[indexPath.section][indexPath.row]
            let cell = taskTableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskTVC
            cell.setup(task: task)
            return cell
            
        case 1:
            let task = tasksByCourseName[indexPath.section][indexPath.row]
            let cell = taskTableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskTVC
            cell.setupByCourseName(task: task)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch taskControls.selectedSegmentIndex {
        case 0: return tasksByDate.count
        case 1: return tasksByCourseName.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch taskControls.selectedSegmentIndex {
        case 0:
            let task = tasksByDate[section]
            let cell = taskTableView.dequeueReusableCell(withIdentifier: "TaskHeaderCell") as! TaskHeaderTVC
            
            if task.count > 0 {
                cell.setup(task: task[0])
            }
            
            return cell.contentView
        
        case 1:
            let task = tasksByCourseName[section]
            let cell = taskTableView.dequeueReusableCell(withIdentifier: "TaskHeaderCell") as! TaskHeaderTVC
            
            if task.count > 0 {
                let course = courses.first(where: {$0.cid == task[0].cid})
                cell.setupByCourseName(course: course!)
            }
            
            return cell.contentView
        
        
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = taskTableView.cellForRow(at: indexPath) as! TaskTVC
        cell.buttonSelected()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = taskTableView.cellForRow(at: indexPath) as! TaskTVC
        cell.buttonDeselected()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch taskControls.selectedSegmentIndex {
        case 0:
            let delete = UIContextualAction(style: .destructive, title: "Delete")
            { (contextualAction, view, actionPerformed: @escaping (Bool)->()) in
                
                let task = self.tasksByDate[indexPath.section][indexPath.row]
                
                if UniversityDB.instance.deleteTask(id: task.tid) {
                    self.tasksByDate[indexPath.section].remove(at: indexPath.row)
                    self.taskTableView.deleteRows(at: [indexPath], with: .fade)
                    
                    if(self.taskTableView.numberOfRows(inSection: indexPath.section) == 0) {
                        self.tasksByDate.remove(at: indexPath.section)
                        self.taskTableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
                    }
                }
                actionPerformed(true)
            }
            
            delete.backgroundColor = Theme.Primary
            return UISwipeActionsConfiguration(actions: [delete])
            
        case 1:
            let delete = UIContextualAction(style: .destructive, title: "Delete")
            { (contextualAction, view, actionPerformed: @escaping (Bool)->()) in
                
                let task = self.tasksByCourseName[indexPath.section][indexPath.row]
                
                if UniversityDB.instance.deleteTask(id: task.tid) {
                    self.tasksByCourseName[indexPath.section].remove(at: indexPath.row)
                    self.taskTableView.deleteRows(at: [indexPath], with: .fade)
                    
                    if(self.taskTableView.numberOfRows(inSection: indexPath.section) == 0) {
                        self.tasksByCourseName.remove(at: indexPath.section)
                        self.taskTableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
                    }
                }
            }
            
            delete.backgroundColor = Theme.Primary
            return UISwipeActionsConfiguration(actions: [delete])
            
        default:
            return UISwipeActionsConfiguration()
        }
    }
}

extension TaskVC: AddTaskDelegate {
    func addTask(task: Task) {
        self.navigationController?.popViewController(animated: true)
//        self.tasksByDate.append(task)
//        self.tasksByCourseName.append(task)
        self.taskTableView.reloadData()
    }
    
    func updateTask(index: Int, task: Task) {
        self.navigationController?.popViewController(animated: true)
        self.taskTableView.reloadData()
    }
}
