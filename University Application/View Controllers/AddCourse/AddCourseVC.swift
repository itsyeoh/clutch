//
//  AddCourseVC.swift
//  UniversityApplication
//
//  Created by Jason Yeoh on 05/09/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit
import Eureka

protocol AddCourseDelegate {
    func addCourse(course: Course)
    func updateCourse(section: Int, row: Int, course: Course)
}

class AddCourseVC: FormViewController {
    private var semesters = [Semester]()
    private var semesterList = [Int64:String]()
    var delegate: AddCourseDelegate?
    var courseSectionToEdit: Int?
    var courseRowToEdit: Int?
    var newCourse: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addCourse))
        
        semesters = UniversityDB.instance.getSemesters()
        for semester in semesters {
            semesterList[semester.sid] = semester.getSeasonTextLabel()
        }

        form +++ Section("ADD COURSE")
            <<< PushRow<String>("semesterRow") {
                let semesterNames = [String](semesterList.values)
                
                $0.title = "Semester"
                $0.options = semesterNames
                $0.value = semesterNames[0]    // initially selected
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                }})
            
            +++ Section("COURSE NAME")
            <<< TextRow("deptRow") {
                $0.title = "Department"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                }})
            
            <<< IntRow("courseNumRow") {
                $0.title = "Course Number"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                }})
            
            +++ Section("CREDIT HOURS")
            <<< IntRow("hourRow") {
                $0.title = "Credit Hours"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                }})
        
        
        if let sec = courseSectionToEdit {
            if let row = courseRowToEdit {
                let course = newCourse!
                                
                form.setValues(["semesterRow": semesterList[course.sid],
                                "deptRow": course.dept,
                                "courseNumRow": course.courseNum,
                                "hourRow": course.creditHours])
            }
        }
    }
    
    @objc func addCourse() {
        if form.validate() == [] {
            let semesterRow: PushRow<String>? = form.rowBy(tag: "semesterRow")!
            let deptRow: TextRow? = form.rowBy(tag: "deptRow")!
            let courseNumRow: IntRow? = form.rowBy(tag: "courseNumRow")!
            let hourRow: IntRow? = form.rowBy(tag: "hourRow")
            
            let csid = semesterList.filter{ $0.value == (semesterRow?.value)! }.map{ $0.0 }.first!
            let dept = (deptRow?.value)!
            let courseNumber = (courseNumRow?.value)!
            let creditHours = (hourRow?.value)!
            
            if let sec = courseSectionToEdit {
                if let row = courseRowToEdit {
                    let course = Course(sid: csid, cid: newCourse!.cid, dept: dept, courseNum: courseNumber, creditHours: creditHours)
                    
                    if UniversityDB.instance.updateCourse(id: course.cid, newCourse: course) {
                        delegate?.updateCourse(section: sec, row: row, course: course)
                    }
                }//end if row..
            } else {
                if let id = UniversityDB.instance.addCourse(csid: csid, cdept: dept, ccourseNum: courseNumber,
                                                            ccreditHours: creditHours) {
                    let course = Course(sid: csid, cid: id, dept: dept, courseNum: courseNumber, creditHours: creditHours)
                    delegate?.addCourse(course: course)
                }
            }
            
        }
    }
}

//public protocol PresenterRowType: TypedRowType {
//    
//    associatedtype PresentedControllerType : UIViewController, TypedRowControllerType
//    
//    /// Defines how the view controller will be presented, pushed, etc.
//    var presentationMode: PresentationMode<PresentedControllerType>? { get set }
//    
//    /// Will be called before the presentation occurs.
//    var onPresentCallback: ((FormViewController, PresentedControllerType) -> Void)? { get set }
//}
//
//open class SelectorRow<Cell: CellType>: OptionsRow<Cell>, PresenterRowType where Cell: BaseCell {
//    
//    
//    /// Defines how the view controller will be presented, pushed, etc.
//    open var presentationMode: PresentationMode<SelectorViewController<SelectorRow<Cell>>>?
//    
//    /// Will be called before the presentation occurs.
//    open var onPresentCallback: ((FormViewController, SelectorViewController<SelectorRow<Cell>>) -> Void)?
//    
//    required public init(tag: String?) {
//        super.init(tag: tag)
//    }
//    
//    /**
//     Extends `didSelect` method
//     */
//    open override func customDidSelect() {
//        super.customDidSelect()
//        guard let presentationMode = presentationMode, !isDisabled else { return }
//        if let controller = presentationMode.makeController() {
//            controller.row = self
//            controller.title = selectorTitle ?? controller.title
//            onPresentCallback?(cell.formViewController()!, controller)
//            presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
//        } else {
//            presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
//        }
//    }
//    
//    /**
//     Prepares the pushed row setting its title and completion callback.
//     */
//    open override func prepare(for segue: UIStoryboardSegue) {
//        super.prepare(for: segue)
//        guard let rowVC = segue.destination as Any as? SelectorViewController<SelectorRow<Cell>> else { return }
//        rowVC.title = selectorTitle ?? rowVC.title
//        rowVC.onDismissCallback = presentationMode?.onDismissCallback ?? rowVC.onDismissCallback
//        onPresentCallback?(cell.formViewController()!, rowVC)
//        rowVC.row = self
//    }
//}
//
//
//public final class CustomPushRow<T: Equatable>: SelectorRow<PushSelectorCell<T>>, RowType {
//    
//    public required init(tag: String?) {
//        super.init(tag: tag)
//        presentationMode = .show(controllerProvider: ControllerProvider.callback {
//            return SelectorViewController<T>(){ _ in }
//            }, onDismiss: { vc in
//                _ = vc.navigationController?.popViewController(animated: true)
//        })
//    }
//}
