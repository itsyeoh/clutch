//
//  CourseClass.swift
//  University Application
//
//  Created by Jason Yeoh on 13/09/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation

class CourseClass {
    var dept: String!
    var courseNum: Int!
    var creditHours: Int?
    var classType: ClassType!
    var startTime: Date!
    var endTime: Date!
    var days = [Day]()
    var location: String!
   
    init(dept: String, courseNum: Int, creditHours: Int, classType: String,
         startTime: Date, endTime: Date, days: String, location: String) {
        self.dept = dept
        self.courseNum = courseNum
        self.creditHours = creditHours
        self.classType = ClassType(rawValue: classType)!
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        
        for index in days {
            if let day = Day(rawValue: String(index)) {
                self.days.append(day)
            }
        }
    }
    
    init(dept: String, courseNum: Int, creditHours: Int, classType: String,
         startTime: Date, endTime: Date, days: [Day], location: String) {
        self.dept = dept
        self.courseNum = courseNum
        self.creditHours = creditHours
        self.classType = ClassType(rawValue: classType)!
        self.startTime = startTime
        self.endTime = endTime
        self.days = days
        self.location = location
    }
    
}
