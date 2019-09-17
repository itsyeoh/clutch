//
//  AddVC.swift
//  UniversityApplication
//
//  Created by Jason Yeoh on 05/09/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit
import Eureka

protocol AddSemesterDelegate {
    func addSemester(semester: Semester)
    func updateSemester(index: Int, semester: Semester)
}

class AddSemesterVC: FormViewController {
    var delegate: AddSemesterDelegate?
    var newSemester: Semester?
    var semesterIndexToEdit: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addSemester))
        
        form +++ Section("ADD SEMESTER") {
                $0.tag = "addSemester"
            }
            <<< PushRow<String>("season") {
                $0.title = "Season"
                $0.options = ["Fall","Spring","Summer", "Winter"]
                $0.value = "Fall"    // initially selected
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
            
            +++ Section("DATES")
            <<< DateInlineRow("startDate") {
                $0.title = "Start Date"
                $0.value = Date(timeIntervalSinceNow: 0)
                $0.add(rule: RuleRequired())
                let ruleRequiredViaClosure = RuleClosure<Date> { startDate in
                    let endDateRow: DateInlineRow? = self.form.rowBy(tag: "endDate")
                    let endDate = endDateRow?.value
                    
                    if endDate == nil {
                        return nil
                    }
                    if startDate == nil {
                        return ValidationError(msg: "Invalid date!")
                    }
                    
                    return (startDate! >= endDate!) ? ValidationError(msg: "Invalid date!") : nil
                }
                $0.add(rule: ruleRequiredViaClosure)
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                    
                    self.form.setValues(["endDate": Date(timeInterval: TimeInterval(60*60*24*7*16), since: row.value!)])
                })
            
            <<< DateInlineRow("endDate") {
                $0.title = "End Date"
                $0.value = Date(timeIntervalSinceNow: TimeInterval(60 * 60 * 24 * 7 * 16))
                $0.add(rule: RuleRequired())
                
                let ruleRequiredViaClosure = RuleClosure<Date> { endDate in
                    let startDateRow: DateInlineRow? = self.form.rowBy(tag: "startDate")
                    let startDate = startDateRow?.value

                    if startDate == nil {
                        return nil
                    }
                    if endDate == nil {
                        return ValidationError(msg: "Invalid date!")
                    }
                    
                    return (startDate! >= endDate!) ? ValidationError(msg: "Invalid date!") : nil
                }
                $0.add(rule: ruleRequiredViaClosure)
                
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                })
        
        if let index = semesterIndexToEdit {
            form.setValues(["season": newSemester?.season,
                            "startDate": newSemester?.startDate,
                            "endDate": newSemester?.endDate])
        }
    }
    
    
    @objc func addSemester() {
        // ERROR HANDLING
        if form.validate() == [] {
            let seasonRow: PushRow<String>? = form.rowBy(tag: "season")!
            let startDateRow: DateInlineRow? = form.rowBy(tag: "startDate")!
            let endDateRow: DateInlineRow? = form.rowBy(tag: "endDate")!
            
            let season = (seasonRow?.value)!
            let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: (startDateRow?.value)!)!
            let endDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: (endDateRow?.value)!)!
            
            if let index = semesterIndexToEdit {
                let semester = Semester(sid: newSemester!.sid, season: season, startDate: startDate, endDate: endDate)
                
                if UniversityDB.instance.updateSemester(id: semester.sid, newSemester: semester) {
                    delegate?.updateSemester(index: index, semester: semester)
                }
                
            } else {
                if let id = UniversityDB.instance.addSemester(cseason: season, cstartDate: startDate, cendDate: endDate) {
                    let semester = Semester(sid: id, season: season, startDate: startDate, endDate: endDate)
                    delegate?.addSemester(semester: semester)
                }
            }//end else
        }//end validation
    }//end addSemester
}
