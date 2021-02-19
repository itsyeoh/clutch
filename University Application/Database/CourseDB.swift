//
//  CourseDB.swift
//  University Application
//
//  Created by Jason Yeoh on 10/16/19.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation
import SQLite

extension UniversityDB {
       func createCourseTable() {
           do {
               try db!.run(courses.create(ifNotExists: true) { table in
                   table.column(cid, primaryKey: true)
                   table.column(c_sid)
                   table.column(dept)
                   table.column(courseNum)
                   table.column(creditHours)
               })
           } catch {
               print("Unable to create table")
           }
       }
       
       // ** CRUD OPERATIONS **
       func addCourse(csid: Int64, cdept: String, ccourseNum: Int, ccreditHours: Int) -> Int64? {
           do {
               let insert = courses.insert(c_sid <- csid, dept <- cdept, courseNum <- ccourseNum, creditHours <- ccreditHours)
               let cid = try db!.run(insert)
               
               return cid
           } catch {
               print("Insert failed \(error)")
               return -1
           }
       }
       
       func getCourses() -> [Course] {
           var courses = [Course]()
           
           do {
               for course in try db!.prepare(self.courses) {
                   courses.append(Course(
                       sid: course[c_sid],
                       cid: course[cid],
                       dept: course[dept],
                       courseNum: course[courseNum],
                       creditHours: course[creditHours]))
               }
           } catch {
               print("Select failed")
           }
           
           return courses
       }
       
       func getSemesterCourses(ssid: Int64) -> [Course] {
           var semesterCourses = [Course]()
           
           do {
               let query = courses.filter(ssid == c_sid)
               
               for course in try db!.prepare(query) {
                   semesterCourses.append( Course(
                       sid: course[c_sid],
                       cid: course[cid],
                       dept: course[dept],
                       courseNum: course[courseNum],
                       creditHours: course[creditHours]))
               }
           } catch {
               print("Select failed")
           }
           
           return semesterCourses
       }
       
       func deleteCourse(id: Int64) -> Bool {
           do {
               let course = courses.filter(id == cid)
               let aClass = classes.filter(id == c_cid)
               let task = tasks.filter(id == t_cid)
               
               try db!.run(course.delete())
               try db!.run(aClass.delete())
               try db!.run(task.delete())
               
               return true
           } catch {
               print("Delete failed")
           }
           return false
       }
       
       
       func updateCourse(id: Int64, newCourse: Course) -> Bool {
           let course = courses.filter(id == cid)
           do {
               let update = course.update([
                   c_sid <- newCourse.sid,
                   dept <- newCourse.dept,
                   courseNum <- newCourse.courseNum,
                   creditHours <- newCourse.creditHours!
                   ])
               if try db!.run(update) > 0 {
                   return true
               }
           } catch {
               print("Update failed: \(error)")
           }
           return false
       }
       
       func searchCourse(id: Int64) -> Course? {
           var selectedCourse: Course?
           
           do {
               let query = try db!.prepare(courses.filter(id == cid))
               
               for course in query {
                   selectedCourse = Course(sid: course[c_sid],
                                           cid: course[cid],
                                           dept: course[dept],
                                           courseNum: course[courseNum],
                                           creditHours: course[creditHours])
               }
               
               return selectedCourse
           } catch {
               print("Select failed")
           }
           
           return selectedCourse
       }
       
       func getCourseClassesByDate(date: Date, day: String) -> [CourseClass] {
           var courseClasses = [CourseClass]()
           
           do {
               let query = semesters.select([courses[dept], courses[courseNum],
                                             courses[creditHours], classes[classType],
                                             classes[classType], classes[startTime],
                                             classes[endTime], classes[days],
                                             classes[location], courses[cid]])
                                    .join(courses, on: sid == courses[c_sid])
                                    .join(classes, on: cid == classes[c_cid])
                                    .filter(startDate <= date && endDate >= date)
                                    .filter(days.like("%" + day + "%"))
                                    .order(classes[startTime] .asc)
               
               for cClass in try db!.prepare(query) {
                   courseClasses.append( CourseClass(
                       cid: cClass[cid],
                       dept: cClass[dept],
                       courseNum: cClass[courseNum],
                       creditHours: cClass[creditHours],
                       classType: cClass[classType],
                       startTime: cClass[startTime],
                       endTime: cClass[endTime],
                       days: cClass[days],
                       location: cClass[location]) )
               }
           } catch {
               print("Select failed")
           }
           
           return courseClasses
       }
       
       func getCourseByID(id: Int64) -> Course {
           var selectedCourse: Course!
           
           do {
               let query = courses.filter(cid == id)
               
               for course in try db!.prepare(query) {
                   selectedCourse = Course(sid: course[c_sid],
                                           cid: course[cid],
                                           dept: course[dept],
                                           courseNum: course[courseNum],
                                           creditHours: course[creditHours])
               }
           } catch {
               print("Select failed")
           }
           
           return selectedCourse
       }
}
