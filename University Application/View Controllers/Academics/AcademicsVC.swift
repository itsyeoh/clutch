//
//  AcademicsVC.swift
//  University Application
//
//  Created by Jason Yeoh on 25/08/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit

class AcademicsVC: UIViewController {

    @IBOutlet weak var semesterTableView: UITableView!
    private var semesters = [Semester]()
    private var courses = [[Course]]()
    private var semesterIsExpanded = [Bool]()
    
    @IBOutlet weak var academicsLabel: UILabel!
    var courseSectionToEdit: Int?
    var courseRowToEdit: Int?
    var semesterIndexToEdit: Int?
    var isPastSemesterSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "ACADEMICS"
        
        semesterTableView.dataSource = self
        semesterTableView.delegate = self
        
        setupAddButton()
        setUpMenuButton("NotDone")
        displayCompletedSemesters()
    }
    
    @objc func displayCompletedSemesters() {
        if !isPastSemesterSelected {
            courses = [[Course]]()
            academicsLabel.text = "Semesters"
            semesters = UniversityDB.instance.getCurrentSemesters()
            isPastSemesterSelected = true
            setUpMenuButton("NotDone")

            for sem in semesters {
                print(sem.getSeasonTextLabel())
                semesterIsExpanded.append(true)
                courses.append( UniversityDB.instance.getSemesterCourses(ssid: sem.sid) )
            }
            semesterTableView.reloadData()
        } else {
            courses = [[Course]]()
            academicsLabel.text = "Past Semesters"
            semesters = UniversityDB.instance.getPastSemesters()
            isPastSemesterSelected = false
            setUpMenuButton("Done")
            
            for sem in semesters {
                semesterIsExpanded.append(true)
                courses.append( UniversityDB.instance.getSemesterCourses(ssid: sem.sid) )
            }
            
            
            semesterTableView.reloadData()
        }
    }
    
    func setupAddButton() {
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named: "Add"), for: .normal)
        
        menuBtn.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
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
        
        menuBtn.addTarget(self, action: #selector(displayCompletedSemesters), for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        semesterTableView.reloadData()
    }
    
    @objc func addButtonClicked() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // [ADD SEMESTER OPTION]
        alert.addAction(UIAlertAction(title: "Add Semester", style: .default, handler: {(action) in
            let storyboard = UIStoryboard(name: "AddSemester", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! AddSemesterVC
            vc.delegate = self
        
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        // [ADD COURSE OPTION]
        alert.addAction(UIAlertAction(title: "Add Course", style: .default, handler: {(action) in
            let storyboard = UIStoryboard(name: "AddCourse", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! AddCourseVC
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }//end addButtonClicked
}

extension AcademicsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return semesters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("At \(section) -> \(courses[section].count)")

        return semesterIsExpanded[section] ? (courses[section].count + 1) : 1
//        return courses[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("At \(indexPath.section), \(indexPath.row)")

        if indexPath.row == 0 {
            let semester = semesters[indexPath.section]
            let cell = semesterTableView.dequeueReusableCell(withIdentifier: "SemesterCell") as! SemesterTVC
            cell.setup(semester: semester)
            return cell
        }
        else {
            let course = courses[indexPath.section][indexPath.row - 1]
            let cell = semesterTableView.dequeueReusableCell(withIdentifier: "CourseCell") as! CourseTVC
            cell.setup(course: course)
            return cell
        }
        
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let semester = semesters[section]
//        let cell = semesterTableView.dequeueReusableCell(withIdentifier: "SemesterCell") as! SemesterTVC
//        cell.setup(semester: semester)
//        return cell.contentView
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63.0
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 63.0
//    }
    
    // Course dashboard
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Section - Semester
        if indexPath.row == 0 {
            semesterIsExpanded[indexPath.section] = !semesterIsExpanded[indexPath.section]
            semesterTableView.reloadSections([indexPath.section], with: .automatic)
        }
        // Row - Course
        else {
            let course = self.courses[indexPath.section][indexPath.row - 1]
            let storyboard = UIStoryboard(name: "Course", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! CourseVC
            vc.course = course
            vc.semesterName = self.semesters[indexPath.section].getSeasonTextLabel()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // Supports edit/update
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row == 0 {
            let update = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
                let semester = self.semesters[indexPath.section]
                let storyboard = UIStoryboard(name: "AddSemester", bundle: nil)
                let vc = storyboard.instantiateInitialViewController() as! AddSemesterVC
                vc.delegate = self
                vc.newSemester = semester
                vc.semesterIndexToEdit = indexPath.section
                
                self.navigationController?.pushViewController(vc, animated: true)
                handler(true)
            }
            
            update.backgroundColor = Theme.Secondary
            return UISwipeActionsConfiguration(actions: [update])
        } else {
            let update = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
                let course = self.courses[indexPath.section][indexPath.row - 1]
                let storyboard = UIStoryboard(name: "AddCourse", bundle: nil)
                let vc = storyboard.instantiateInitialViewController() as! AddCourseVC
                vc.delegate = self
                vc.newCourse = course
                vc.courseSectionToEdit = indexPath.section
                vc.courseRowToEdit = indexPath.row
                
                self.navigationController?.pushViewController(vc, animated: true)
                handler(true)
            }
            
            update.backgroundColor = Theme.Secondary
            return UISwipeActionsConfiguration(actions: [update])
        }
    }
    
    // Supports deletion
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row == 0 {
            let delete = UIContextualAction(style: .destructive, title: "Delete")
            { (contextualAction, view, actionPerformed: @escaping (Bool)->()) in
                
                let alert = UIAlertController(title: "Delete Semester", message: "Sure ka beks?", preferredStyle: .alert)
                
                alert.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                    actionPerformed(false)
                })))
                
                alert.addAction((UIAlertAction(title: "Delete", style: .destructive, handler: { (alertAction) in
                    // Perform delete
                    let semester = self.semesters[indexPath.section]
                    
                    if UniversityDB.instance.deleteSemester(id: semester.sid) {
                        self.semesters.remove(at: indexPath.section)
                        self.courses.remove(at: indexPath.section)
                        self.semesterIsExpanded.remove(at: indexPath.section)
                        self.semesterTableView.deleteSections([indexPath.section], with: .automatic)
                    }
                    actionPerformed(true)
                })))
                
                self.present(alert, animated: true)
            }
            
            delete.backgroundColor = Theme.Primary
            return UISwipeActionsConfiguration(actions: [delete])
            

        } else {
            let delete = UIContextualAction(style: .destructive, title: "Delete")
            { (contextualAction, view, actionPerformed: @escaping (Bool)->()) in
                
                let alert = UIAlertController(title: "Delete Course", message: "Sure ka baks?", preferredStyle: .alert)
                
                alert.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                    actionPerformed(false)
                })))
                
                alert.addAction((UIAlertAction(title: "Delete", style: .destructive, handler: { (alertAction) in
                    // Perform delete
                    let course = self.courses[indexPath.section][indexPath.row - 1]
                    
                    if UniversityDB.instance.deleteCourse(id: course.cid) {
                        self.courses[indexPath.section].remove(at: indexPath.row)                        
                        self.semesterTableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    actionPerformed(true)
                })))
                
                self.present(alert, animated: true)
            }
            
            delete.backgroundColor = Theme.Primary
            return UISwipeActionsConfiguration(actions: [delete])
        }
        
    }
}


extension AcademicsVC: AddSemesterDelegate, AddCourseDelegate {
    func addSemester(semester: Semester) {
        self.navigationController?.popViewController(animated: true)
        self.semesters.append(semester)
        self.semesterIsExpanded.append(true)
        self.courses.append([])
        self.semesterTableView.reloadData()
    }
    
    func updateSemester(index: Int, semester: Semester) {
        self.navigationController?.popViewController(animated: true)
        self.semesters[index] = semester
        self.semesterIndexToEdit = nil
        self.semesterTableView.reloadData()
    }
    
    func addCourse(course: Course) {
        self.navigationController?.popViewController(animated: true)
        self.courses[Int(course.sid) - 1].append(course)
        self.semesterTableView.reloadData()
    }
    
    func updateCourse(section: Int, row: Int, course: Course) {
        self.navigationController?.popViewController(animated: true)
        self.courses[section][row] = course
        self.courseRowToEdit = nil
        self.courseSectionToEdit = nil
        self.semesterTableView.reloadData()
    }
}
