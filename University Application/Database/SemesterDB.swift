//
//  SemesterDB.swift
//  University Application
//
//  Created by Jason Yeoh on 10/16/19.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation
import SQLite

extension UniversityDB {
    // CREATE SEMESTER TABLE
    func createSemesterTable() {
        do {
            try db!.run(semesters.create(ifNotExists: true) { table in
                table.column(sid, primaryKey: true)
                table.column(season)
                table.column(startDate)
                table.column(endDate)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    // ** CRUD OPERATIONS **
    func addSemester(cseason: String, cstartDate: Date, cendDate: Date) -> Int64? {
        do {
            let insert = semesters.insert(season <- cseason, startDate <- cstartDate, endDate <- cendDate)
            let sid = try db!.run(insert)
            
            return sid
        } catch {
            print("Insert failed \(error)")
            return -1
        }
    }
    
    func getSemesters() -> [Semester] {
        var semesters = [Semester]()
        
        do {
            for semester in try db!.prepare(self.semesters) {
                semesters.append(Semester(
                    sid: semester[sid],
                    season: semester[season],
                    startDate: semester[startDate],
                    endDate: semester[endDate]))
            }
        } catch {
            print("Select failed")
        }
        
        return semesters
    }
    
    func getPastSemesters() -> [Semester] {
        var semesters = [Semester]()
        
        do {
            let query = self.semesters.filter(endDate <= Date())
            for semester in try db!.prepare(query) {
                semesters.append(Semester(
                    sid: semester[sid],
                    season: semester[season],
                    startDate: semester[startDate],
                    endDate: semester[endDate]))
            }
        } catch {
            print("Select failed")
        }
        
        return semesters
    }
    
    func getCurrentSemesters() -> [Semester] {
        var semesters = [Semester]()
        
        do {
            let query = self.semesters.filter(endDate > Date())
            for semester in try db!.prepare(query) {
                semesters.append(Semester(
                    sid: semester[sid],
                    season: semester[season],
                    startDate: semester[startDate],
                    endDate: semester[endDate]))
            }
        } catch {
            print("Select failed")
        }
        
        return semesters
    }
    
    func deleteSemester(id: Int64) -> Bool {
        do {
            let semester = semesters.filter(id == sid)
            let course = courses.filter(id == c_sid)
            
            for crs in try db!.prepare(course) {
                UniversityDB.instance.deleteCourse(id: crs[cid])
            }
            
            try db!.run(semester.delete())
            try db!.run(course.delete())
            
            return true
        } catch {
            print("Delete failed")
        }
        return false
    }
    
    func updateSemester(id: Int64, newSemester: Semester) -> Bool {
        let semester = semesters.filter(id == sid)
        do {
            let update = semester.update([
                season <- newSemester.season,
                startDate <- newSemester.startDate,
                endDate <- newSemester.endDate
                ])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        return false
    }
}
