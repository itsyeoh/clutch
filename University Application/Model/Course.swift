//
//  Course.swift
//  University App
//
//  Created by Jason Yeoh on 16/08/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation

class Course {
    let cid: Int64!
    var sid: Int64!
    var dept: String!
    var courseNum: Int!
    var creditHours: Int?
    
    init(sid: Int64, cid: Int64) {
        self.sid = sid
        self.cid = cid
        self.dept = ""
        self.courseNum = 0
        self.creditHours = 0
    }
    
    init(sid: Int64, cid: Int64, dept: String, courseNum: Int, creditHours: Int) {
        self.sid = sid
        self.cid = cid
        self.dept = dept
        self.courseNum = courseNum
        self.creditHours = creditHours
    }
    
    func showCourseName() -> String {
        return dept + " " + String(courseNum)
    }
}
