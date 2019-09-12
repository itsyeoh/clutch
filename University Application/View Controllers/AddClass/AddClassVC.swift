//
//  AddClassVC.swift
//  UniversityApplication
//
//  Created by Jason Yeoh on 05/09/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation
import Eureka

protocol AddClassDelegate {
    func addClass(aClass: Class)
    func updateClass(index: Int, aClass: Class)
}

class AddClassVC: FormViewController {
    var newClass: Class?
    var course: Course?
    var delegate: AddClassDelegate?
    var classIndexToEdit: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addClass))
        
        form +++ Section("")
            <<< PushRow<String>("typeRow") {
                $0.title = "Type"
                $0.options = ["Lecture", "Laboratory", "Discussion"]
                $0.value = "Lecture"    // initially selected
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                }})
            
            +++ Section("TIME & DAY")
            <<< TimeInlineRow("startTimeRow") {
                $0.title = "Start Time"
                $0.value = Date(timeIntervalSinceNow: 0)
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange                
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                }})
            
            <<< TimeInlineRow("endTimeRow") {
                $0.title = "End Time"
                $0.value = Date(timeIntervalSinceNow: 60 * 60)
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                }})
//            <<< PushRow<RepeatInterval>("Repeat") {
//                $0.title = $0.tag
//                $0.options = RepeatInterval.allCases
//                $0.value = .Never
//                }.onPresent({ (_, vc) in
//                    vc.enableDeselection = false
//                    vc.dismissOnSelection = false
//                })
            
            <<< WeekDayRow("daysRow"){
                $0.title = "Days"
                $0.value = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday]
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                }})
        
            +++ Section("Location")
            <<< TextRow("locationRow") {
                $0.title = "Location"
                $0.placeholder = "SELE 2249"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                }})

        // Plug in all values for an existing class
        if let index = classIndexToEdit {
            let aClass = newClass!
            
            form.setValues(["typeRow": aClass.classType.rawValue, "startTimeRow": aClass.startTime,
                            "endTimeRow": aClass.endTime, "daysRow": Set(aClass.days),
                            "locationRow": aClass.location] )
        }
    }
    
    @objc func addClass() {
        if form.validate() == [] {
            let typeRow: PushRow<String>? = form.rowBy(tag: "typeRow")
            let startTimeRow: TimeInlineRow? = form.rowBy(tag: "startTimeRow")
            let endTimeRow: TimeInlineRow? = form.rowBy(tag: "endTimeRow")
            let daysRow: WeekDayRow? = form.rowBy(tag: "daysRow")
            let locationRow: TextRow? = form.rowBy(tag: "locationRow")
            
            let cid = (course?.cid)!
            let classType = ClassType(rawValue: typeRow!.value!)!
            let startTime = (startTimeRow?.value)!
            let endTime = (endTimeRow?.value)!
            let days = Array(daysRow!.value!)
            let location = (locationRow?.value)!
            
            var dayString = ""
            
            for day in days {
                dayString += day.rawValue
            }
            
            // Update Class
            if let index = classIndexToEdit {
                let aClass = Class(cid: cid, clid: newClass!.clid, classType: classType, startTime: startTime,
                                     endTime: endTime, days: days, location: location)
                if UniversityDB.instance.updateClass(id: aClass.clid, newClass: aClass) {
                    delegate?.updateClass(index: index, aClass: aClass)
                }
            } else { // Add Class
                if let id = UniversityDB.instance.addClass(ccid: cid, cclassType: classType, cstartTime: startTime,
                                                           cendTime: endTime, cdays: dayString, clocation: location) {
                    let aClass = Class(cid: cid, clid: id, classType: classType, startTime: startTime,
                                       endTime: endTime, days: days, location: location)
                    delegate?.addClass(aClass: aClass)
                }
            }//end insert/update selection
        }//end validation
    }//end addClass()
    
}
