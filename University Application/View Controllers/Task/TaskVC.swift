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
    var taskIndexToEdit: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "TASKS"
        setUpMenuButton("NotDone")
        setupAddButton()
        
        taskTableView.dataSource = self
        taskTableView.delegate = self
        
        refreshData(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tasksByDate = UniversityDB.instance.getTasksByDate(checkVar: isCompleted)
        tasksByCourseName = UniversityDB.instance.getTasksByCourseName(checkVar: isCompleted)
        courses = UniversityDB.instance.getCourses()
    }
    
    func setupAddButton() {
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named: "Add"), for: .normal)
        
        menuBtn.addTarget(self, action: #selector(openAddTask), for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    func setUpMenuButton(_ name: String){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named: name), for: .normal)
        
        menuBtn.addTarget(self, action: #selector(openCompletedTasks), for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItem
    }
    
    @objc func openAddTask() {
        let storyboard = UIStoryboard(name: "AddTask", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! AddTaskVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func refreshData(_ isSelected: Bool) {
        tasksByDate = UniversityDB.instance.getTasksByDate(checkVar: isSelected)
        tasksByCourseName = UniversityDB.instance.getTasksByCourseName(checkVar: isSelected)
        courses = UniversityDB.instance.getCourses()
        self.taskTableView.reloadData()
    }
    
    func refreshDataView() {
        if isCompleted { refreshData(true) }
        else { refreshData(false) }
    }
    
    @objc func openCompletedTasks() {
        if isCompleted == true {
            self.navigationItem.title = "TASKS"
            setUpMenuButton("NotDone")
            isCompleted = false
            refreshData(false)
        } else {
            setUpMenuButton("Done")
            self.navigationItem.title = "COMPLETED TASKS"
            isCompleted = true
            refreshData(true)
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
            cell.setup(task: task, isCompleted: isCompleted)

            return cell
            
        case 1:
            let task = tasksByCourseName[indexPath.section][indexPath.row]
            let cell = taskTableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskTVC
            cell.setupByCourseName(task: task, isCompleted: isCompleted)

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
                return cell.contentView
            } else {
                return nil
            }
            
        case 1:
            let task = tasksByCourseName[section]
            let cell = taskTableView.dequeueReusableCell(withIdentifier: "TaskHeaderCell") as! TaskHeaderTVC
            
            if task.count > 0 {
                let course = courses.first(where: {$0.cid == task[0].cid})
                cell.setupByCourseName(course: course!)
                return cell.contentView
            } else {
                return nil
            }
            
        default:
            return UIView()
        }
    }//end viewForHeader
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch taskControls.selectedSegmentIndex {
        case 0:
            let tasks = tasksByDate[section]
            if tasks.count == 0 { return 0.0 }
            else { return 30.0 }
            
        case 1:
            let tasks = tasksByCourseName[section]
            if tasks.count == 0 { return 0.0 }
            else { return 30.0 }
            
        default:
            return 30.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch taskControls.selectedSegmentIndex {
        case 0:
            let task = tasksByDate[indexPath.section][indexPath.row]
            let cell = tableView.cellForRow(at: indexPath) as! TaskTVC
//            cell.buttonPressed(false)
            task.isSelected()
        case 1:
            let task = tasksByCourseName[indexPath.section][indexPath.row]
            let cell = tableView.cellForRow(at: indexPath) as! TaskTVC
//            cell.buttonPressed(false)
            task.isSelected()
        default:
             break
        }
        
        refreshDataView()
    }//end didSelectRow
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch taskControls.selectedSegmentIndex {
        case 0:
            let update = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
                let task = self.tasksByDate[indexPath.section][indexPath.row]
                let storyboard = UIStoryboard(name: "AddTask", bundle: nil)
                let vc = storyboard.instantiateInitialViewController() as! AddTaskVC
                vc.delegate = self
                vc.newTask = task
                vc.course = task.getCourse()
                vc.taskIndexToEdit = indexPath.row
                
                self.navigationController?.pushViewController(vc, animated: true)
                handler(true)
            }
            
            update.backgroundColor = Theme.Primary
            return UISwipeActionsConfiguration(actions: [update])
        case 1:
            let update = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
                let task = self.tasksByCourseName[indexPath.section][indexPath.row]
                let storyboard = UIStoryboard(name: "AddTask", bundle: nil)
                let vc = storyboard.instantiateInitialViewController() as! AddTaskVC
                vc.delegate = self
                vc.newTask = task
                vc.taskIndexToEdit = indexPath.row
                
                self.navigationController?.pushViewController(vc, animated: true)
                handler(true)
            }
            
            update.backgroundColor = Theme.Primary
            return UISwipeActionsConfiguration(actions: [update])
        default:
            return UISwipeActionsConfiguration(actions: [])
        }
    }//end leadingSwipe
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch taskControls.selectedSegmentIndex {
        case 0:
            let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
                let task = self.tasksByDate[indexPath.section][indexPath.row]
                
                
                if UniversityDB.instance.deleteTask(id: task.tid) {
                    self.tasksByDate[indexPath.section].remove(at: indexPath.row)
                    self.taskTableView.deleteRows(at: [indexPath], with: .fade)
                }
                handler(true)
            }
            
            delete.backgroundColor = Theme.Primary
            return UISwipeActionsConfiguration(actions: [delete])
        case 1:
            let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
                let task = self.tasksByCourseName[indexPath.section][indexPath.row]
                
                if UniversityDB.instance.deleteTask(id: task.tid) {
                    self.tasksByCourseName[indexPath.section].remove(at: indexPath.row)
                    self.taskTableView.deleteRows(at: [indexPath], with: .fade)
                }
                handler(true)
            }
            
            delete.backgroundColor = Theme.Primary
            return UISwipeActionsConfiguration(actions: [delete])
        default:
            return UISwipeActionsConfiguration(actions: [])
        }
    }//end trailingSwipe
}

extension TaskVC: AddTaskDelegate {
    func addTask(task: Task) {
        self.navigationController?.popViewController(animated: true)
        
//        switch taskControls.selectedSegmentIndex {
//        case 0:
//            self.tasksByDate.append(task)
//        case 1:
//            self.tasksByCourseName.append(task)
//        default:
//            break
//        }
        
        self.taskTableView.reloadData()
    }
    
    func updateTask(index: Int, task: Task) {
        self.navigationController?.popViewController(animated: true)
        self.taskTableView.reloadData()
        self.taskIndexToEdit = nil
    }
}
