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
    private var isCompleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "TASKS"
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: UIImage(named: "NotDone"), style: .plain, target: self, action: #selector(openCompletedTasks))
        
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(openAddTask))
        
        taskTableView.dataSource = self
        taskTableView.delegate = self
        
        tasksByDate = UniversityDB.instance.getTasksByDate(checkVar: false)
        tasksByCourseName = UniversityDB.instance.getTasksByCourseName(checkVar: false)
        courses = UniversityDB.instance.getCourses()
        
        self.taskTableView.setEditing(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tasksByDate = UniversityDB.instance.getTasksByDate(checkVar: false)
        tasksByCourseName = UniversityDB.instance.getTasksByCourseName(checkVar: false)
        courses = UniversityDB.instance.getCourses()
    }
    
    @objc func openAddTask() {
        let storyboard = UIStoryboard(name: "AddTask", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! AddTaskVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openCompletedTasks() {
        if isCompleted == true {
            print("--------")
            print("NOT DONE")
            self.navigationItem.title = "TASKS"
            self.navigationItem.leftBarButtonItem?.setBackgroundImage(UIImage(named: "NotDone"), for: .normal, barMetrics: .default)
            isCompleted = false
            tasksByDate = UniversityDB.instance.getTasksByDate(checkVar: false)
            tasksByCourseName = UniversityDB.instance.getTasksByCourseName(checkVar: false)
            courses = UniversityDB.instance.getCourses()
            self.taskTableView.reloadData()
        } else {
            print("DONE")
            self.navigationItem.leftBarButtonItem?.setBackgroundImage(UIImage(named: "Done"), for: .normal, barMetrics: .default)
            self.navigationItem.title = "COMPLETED TASKS"
            isCompleted = true
            tasksByDate = UniversityDB.instance.getTasksByDate(checkVar: true)
            tasksByCourseName = UniversityDB.instance.getTasksByCourseName(checkVar: true)
            self.taskTableView.reloadData()
        }
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
    }//end viewForHeader
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch taskControls.selectedSegmentIndex {
        case 0:
            let task = tasksByDate[indexPath.section][indexPath.row]
            task.isSelected()
        case 1:
            let task = tasksByCourseName[indexPath.section][indexPath.row]
            task.isSelected()
        default:
             break
        }
    }//end didSelectRow
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch taskControls.selectedSegmentIndex {
        case 0:
            let task = tasksByDate[indexPath.section][indexPath.row]
            task.isDeselected()
        case 1:
            let task = tasksByCourseName[indexPath.section][indexPath.row]
            task.isDeselected()
        default:
            break
        }
    }//end didDeselectRow
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isCompleted {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
}

extension TaskVC: AddTaskDelegate {
//    func updateTaskChecklist(index: IndexPath, task: Task) {
//        switch taskControls.selectedSegmentIndex {
//        case 0:
//            self.tasksByDate[index.section][index.row] = task
//        case 1:
//            self.tasksByCourseName[index.section][index.row] = task
//        default:
//            break
//        }
//        
//        self.taskTableView.reloadData()
//    }
    
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
