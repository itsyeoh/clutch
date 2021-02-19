//
//  Class.swift
//  University App
//
//  Created by Jason Yeoh on 16/08/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation

class Class {
    let clid: Int64!
    var cid: Int64!
    var classType: ClassType!
    var startTime: Date!
    var endTime: Date!
    var days = [Day]()
    var location: String
    
    init(cid: Int64, clid: Int64) {
        self.cid = cid
        self.clid = clid
        classType = .Lecture
        startTime = Date()
        endTime = Date()
        days = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday]
        location = ""
    }
    
    init(cid: Int64, clid: Int64, classType: String, startTime: Date, endTime: Date,
         days: String, location: String) {
        self.cid = cid
        self.clid = clid
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
    
    init(cid: Int64, clid: Int64, classType: ClassType, startTime: Date, endTime: Date,
         days: [Day], location: String) {
        self.cid = cid
        self.clid = clid
        self.classType = classType
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        self.days = days
    }
    
    func getDaysToStrings() -> String {
        var dayString = ""
        let selectedDays = days.sorted()
        
        for day in selectedDays {
            dayString += day.rawValue
        }
        
        return dayString
    }
    
    func getClassTypePrefix() -> String {
        return String(self.classType.rawValue.uppercased().prefix(3))
    }
    
    func getTimeToString(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        return dateFormatter.string(from: time)
    }
    
    func getClassDays() -> [Bool] {
        var days: [Day] = [.Sunday, .Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday]
        var selectedDays = self.days.sorted()
        var index = 0
        var lastIndex = selectedDays.count - 1
        var boolArray: [Bool] = []
        
        for day in days {
            if lastIndex >= index {
                if selectedDays[index] == day {
                    boolArray.append(true)
                    index += 1
                } else {
                    boolArray.append(false)
                }
            } else {
                boolArray.append(false)
            }
        }
        
        return boolArray
    }
    
    func getClassTime() -> String {
        let startTime = getTimeToString(time: self.startTime)
        let endTime = getTimeToString(time: self.endTime)
        let dayString = getDaysToStrings()
        
        return "\(startTime) - \(endTime)"
    }
    
}

enum ClassType: String {
    case Lecture = "Lecture"
    case Laboratory = "Laboratory"
    case Discussion = "Discussion"
}

enum Day: String, Comparable {
    case Monday = "M"
    case Tuesday = "T"
    case Wednesday = "W"
    case Thursday = "R"
    case Friday = "F"
    case Saturday = "S"
    case Sunday = "U"
    
    private var sortOrder: Int {
        switch self {
        case .Monday:
            return 0
        case .Tuesday:
            return 1
        case .Wednesday:
            return 2
        case .Thursday:
            return 3
        case .Friday:
            return 4
        case .Saturday:
            return 5
        case .Sunday:
            return 6
        }
    }
    
    static func ==(lhs: Day, rhs: Day) -> Bool {
        return lhs.sortOrder == rhs.sortOrder
    }
    
    static func <(lhs: Day, rhs: Day) -> Bool {
        return lhs.sortOrder < rhs.sortOrder
    }
}
