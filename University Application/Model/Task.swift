//
//  Task.swift
//  University Application
//
//  Created by Jason Yeoh on 30/08/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation


class Task {
    let tid: Int64!
    var cid: Int64!
    var taskName: String!
    var taskType: String!
    var taskDate: Date!
    var taskTime: Date!
    var description: String?
    var isChecked: Bool!
    
    init(cid: Int64, tid: Int64) {
        self.cid = cid
        self.tid = tid
        self.taskName = ""
        self.taskType = ""
        self.taskDate = Date()
        self.taskTime = Date()
        self.description = ""
        self.isChecked = false
    }
    
    init(cid: Int64, tid: Int64, taskName: String, taskType: String, taskDate: Date, taskTime: Date,
         description: String? = nil, isChecked: Bool) {
        self.cid = cid
        self.tid = tid
        self.taskName = taskName
        self.taskType = taskType
        self.taskDate = taskDate
        self.taskTime = taskTime
        self.description = description
        self.isChecked = isChecked
    }
    
    func getDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return dateFormatter.string(from: self.taskDate)
    }
    
    func getWeekDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE • MMM dd, yyyy"
        
        return dateFormatter.string(from: self.taskDate).uppercased()
    }
    
    func getWeekDayToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE • MMM dd, yyyy"
        
        return dateFormatter.string(from: self.taskDate).uppercased()
    }
    
    func getCourse() -> Course {
        return UniversityDB.instance.searchCourse(id: self.cid)!
    }
}
