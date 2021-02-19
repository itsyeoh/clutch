//
//  SemesterDB.swift
//  University App
//
//  Created by Jason Yeoh on 16/08/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import SQLite

class UniversityDB {
    static let instance = UniversityDB()
    internal let db: Connection?
    
    // SEMESTER
    internal let semesters = Table("semesters")
    internal let sid = Expression<Int64>("sid")
    internal let season = Expression<String>("season")
    internal let startDate = Expression<Date>("startDate")
    internal let endDate = Expression<Date>("endDate")
    
    // COURSE
    internal let courses = Table("courses")
    internal let c_sid = Expression<Int64>("c_sid")
    internal let cid = Expression<Int64>("cid")
    internal let dept = Expression<String>("dept")
    internal let courseNum = Expression<Int>("courseNum")
    internal let creditHours = Expression<Int>("creditHours")
    
    // CLASS
    internal let classes = Table("classes")
    internal let c_cid = Expression<Int64>("c_cid")
    internal let clid = Expression<Int64>("clid")
    internal let classType = Expression<String>("classType")
    internal let startTime = Expression<Date>("startTime")
    internal let endTime = Expression<Date>("endTime")
    internal let days = Expression<String>("days")
    internal let location = Expression<String>("location")

    
    // TASK
    internal let tasks = Table("tasks")
    internal let t_cid = Expression<Int64>("t_cid")
    internal let tid = Expression<Int64>("tid")
    internal let taskName = Expression<String>("taskName")
    internal let taskType = Expression<String>("taskType")
    internal let taskDate = Expression<Date>("taskDate")
    internal let taskTime = Expression<Date>("taskTime")
    internal let description = Expression<String>("description")
    internal let isChecked = Expression<Bool>("isChecked")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/Loc_Data")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        
        createSemesterTable()
        createCourseTable()
        createClassTable()
        createTaskTable()
    }
}
