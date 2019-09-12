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
}

class AddSemesterVC: FormViewController {
    var delegate: AddSemesterDelegate?
    
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
            
            <<< DateInlineRow("startDate") {
                $0.title = "Start Date"
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
    }
    
    
    @objc func addSemester() {
        // ERROR HANDLING
        if form.validate() == [] {
            let seasonRow: PushRow<String>? = form.rowBy(tag: "season")!
            let startDateRow: DateInlineRow? = form.rowBy(tag: "startDate")!
            let endDateRow: DateInlineRow? = form.rowBy(tag: "endDate")!
            
            let season = (seasonRow?.value)!
            let startDate = (startDateRow?.value)!
            let endDate = (endDateRow?.value)!
            
            if let id = UniversityDB.instance.addSemester(cseason: season, cstartDate: startDate, cendDate: endDate) {
                let semester = Semester(sid: id, season: season, startDate: startDate, endDate: endDate)
                delegate?.addSemester(semester: semester)
            }
        }
    }
    
//    func calculateTimeDifference(startDate: Date, endDate: Date) -> String {
//        let timeDifference = userCalendar.dateComponents(requestedComponents, from: startDate, to: endDate)
//        let yr = timeDifference.year!
//        let mo = timeDifference.month!
//        let we = timeDifference.day! / 7
//        let da = timeDifference.day! - (we*7)
//
//        if da < 0 {
//            durationLabel.textColor = Theme.Secondary
//            return "Duration: INVALID"
//        } else {
//            durationLabel.textColor = Theme.Primary
//
//            let yrString = (yr != 0) ? "\(yr) years" : ""
//            let moString = (mo != 0) ? "\(mo) months" : ""
//            let weString = (we != 0) ? "\(we) weeks" : ""
//            let daString = (da != 0) ? "\(da) days" : ""
//
//
//            return "Duration: " + yrString + " " + moString + " " + weString + " " + daString
//        }
//    }
}
