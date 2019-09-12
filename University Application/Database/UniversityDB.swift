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
    private let db: Connection?
    
    private let semesters = Table("semesters")
    private let sid = Expression<Int64>("sid")
    private let season = Expression<String>("season")
    private let startDate = Expression<Date>("startDate")
    private let endDate = Expression<Date>("endDate")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/LocalUniData_")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        
        createSemesterTable()
        createCourseTable()
        createClassTable()
        createTaskTable()
    }
    
    // SEMESTERS
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
    
    func deleteSemester(id: Int64) -> Bool {
        do {
            let semester = semesters.filter(id == sid)
            try db!.run(semester.delete())
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
    
    
    // COURSES
    private let courses = Table("courses")
    private let c_sid = Expression<Int64>("sid")
    private let cid = Expression<Int64>("cid")
    private let dept = Expression<String>("dept")
    private let courseNum = Expression<Int>("courseNum")
    private let creditHours = Expression<Int>("creditHours")
    
    
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
            try db!.run(course.delete())
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
    
    // CLASSES
    private let classes = Table("classes")
    private let c_cid = Expression<Int64>("cid")
    private let clid = Expression<Int64>("clid")
    private let classType = Expression<String>("classType")
    private let startTime = Expression<Date>("startTime")
    private let endTime = Expression<Date>("endTime")
    private let days = Expression<String>("days")
    private let location = Expression<String>("location")


    // ** CRUD OPERATIONS **
    func createClassTable() {
        do {
            try db!.run(classes.create(ifNotExists: true) { table in
                table.column(clid, primaryKey: true)
                table.column(c_cid)
                table.column(classType)
                table.column(startTime)
                table.column(endTime)
                table.column(days)
                table.column(location)
            })
        } catch {
            print("Unable to create table")
        }
    }


    func addClass(ccid: Int64, cclassType: ClassType, cstartTime: Date, cendTime: Date, cdays: String, clocation: String) -> Int64? {
        do {
            let insert = classes.insert(c_cid <- ccid, classType <- cclassType.rawValue, startTime <- cstartTime,
                                        endTime <- cendTime, days <- cdays, location <- clocation)
            let clid = try db!.run(insert)

            return clid
        } catch {
            print("Insert failed")
            return -1
        }
    }
    
    func getClasses() -> [Class] {
        var classes = [Class]()

        do {
            for newClass in try db!.prepare(self.classes) {
                classes.append(Class(cid: newClass[c_cid],
                                     clid: newClass[clid],
                                     classType: newClass[classType],
                                     startTime: newClass[startTime],
                                     endTime: newClass[endTime],
                                     days: newClass[days],
                                     location: newClass[location]))
            }
        } catch {
            print("Select failed")
        }

        return classes
    }

    func deleteClass(id: Int64) -> Bool {
        do {
            let selectedClass = classes.filter(id == clid)
            try db!.run(selectedClass.delete())
            return true
        } catch {
            print("Delete failed")
        }
        return false
    }

    func updateClass(id: Int64, newClass: Class) -> Bool {
        let selectedClass = classes.filter(id == clid)
        do {
            let update =  selectedClass.update([
                c_cid <- newClass.cid,
                classType <- newClass.classType.rawValue,
                startTime <- newClass.startTime,
                endTime <- newClass.endTime,
                days <- newClass.getDaysToStrings(),
                location <- newClass.location
                ])

            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }

        return false
    }
    
    func getCourseClasses(ccid: Int64) -> [Class] {
        var courseClasses = [Class]()
        
        do {
            let query = classes.filter(ccid == c_cid)
            
            for aClass in try db!.prepare(query) {
                courseClasses.append( Class(
                    cid: aClass[c_cid],
                    clid: aClass[clid],
                    classType: aClass[classType],
                    startTime: aClass[startTime],
                    endTime: aClass[endTime],
                    days: aClass[days],
                    location: aClass[location]))
            }
        } catch {
            print("Select failed")
        }
        
        return courseClasses
    }
 
    func getCourseClassesCount(ccid: Int64) -> Int {
        var count: Int?
        
        do {
            count = try db!.scalar(classes.filter(ccid == c_cid).count)
        } catch {
            print("Select failed")
        }
        
        return count!
    }
    
    
    
    // TASK
    private let tasks = Table("tasks")
    private let t_cid = Expression<Int64>("cid")
    private let tid = Expression<Int64>("tid")
    private let taskName = Expression<String>("taskName")
    private let taskType = Expression<String>("taskType")
    private let taskDate = Expression<Date>("taskDate")
    private let taskTime = Expression<Date>("taskTime")
    private let description = Expression<String>("description")
    private let isChecked = Expression<Bool>("isChecked")
    
    func createTaskTable() {
        do {
            try db!.run(tasks.create(ifNotExists: true) { table in
                table.column(tid, primaryKey: true)
                table.column(t_cid)
                table.column(taskName)
                table.column(taskType)
                table.column(taskDate)
                table.column(taskTime)
                table.column(description)
                table.column(isChecked)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addTask(ccid: Int64, ctaskName: String, ctaskType: String, ctaskDate: Date, ctaskTime: Date,
                 cdescription: String) -> Int64? {
        do {
            let insert = tasks.insert(t_cid <- ccid, taskName <- ctaskName, taskType <- ctaskType,
                                      taskDate <- ctaskDate, taskTime <- ctaskTime,
                                      description <- cdescription, isChecked <- false)
            let tid = try db!.run(insert)
            return tid
        } catch {
            print("Insert failed")
            return -1
        }
    }

    func getTasks() -> [Task] {
        var tasks = [Task]()
        
        do {
            for task in try db!.prepare(self.tasks) {
                tasks.append(Task(cid: task[t_cid],
                                  tid: task[tid],
                                  taskName: task[taskName],
                                  taskType: task[taskType],
                                  taskDate: task[taskDate],
                                  taskTime: task[taskTime],
                                  description: task[description],
                                  isChecked: task[isChecked]))
            }
        } catch {
            print("Select failed")
        }
        
        return tasks
    }

    func deleteTask(id: Int64) -> Bool {
        do {
            let selectedTask = tasks.filter(id == tid)
            try db!.run(selectedTask.delete())
            return true
        } catch {
            print("Select failed")
        }
        return false
    }

    func updateTask(id: Int64, newTask: Task) -> Bool {
        let selectedTask = tasks.filter(id == tid)
        do {
            let update = selectedTask.update([
                t_cid <- newTask.cid,
                taskName <- newTask.taskName,
                taskType <- newTask.taskType,
                taskDate <- newTask.taskDate,
                taskTime <- newTask.taskTime,
                description <- newTask.description ?? "",
                isChecked <- newTask.isChecked])
            
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    // Get tasks based on clusters of distinct dates
    func getTasksByDate() -> [[Task]] {
        var courseTasks = [[Task]]()
        
        do { 
            let datesTable = tasks.select(taskDate).order(taskDate.asc).group(taskDate.date)
            // SELECT DISTINCT taskDate FROM tasks
            
            for dateRow in try db!.prepare(datesTable) {
                let taskTable = tasks.filter(taskDate.date == dateRow[taskDate].date)
                var taskLists = [Task]()
                
                for task in try db!.prepare(taskTable) {
                    taskLists.append( Task(
                        cid: task[t_cid],
                        tid: task[tid],
                        taskName: task[taskName],
                        taskType: task[taskType],
                        taskDate: task[taskDate],
                        taskTime: task[taskTime],
                        description: task[description],
                        isChecked: task[isChecked]))
                }
                
                courseTasks.append(taskLists)
            }
        } catch {
            print("Select failed")
        }
        
        return courseTasks
    }
    
    
    // Get tasks based on clusters of distinct course names
    func getTasksByCourseName() -> [[Task]] {
        var courseTasks = [[Task]]()
        
        do {
            let courseNamesTable = tasks.select(t_cid).group(t_cid).order(dept.asc, courseNum.asc)
            // SELECT Dept, CourseNum FROM tasks
            
            for cnRow in try db!.prepare(courseNamesTable) {
                let taskTable = tasks.filter(t_cid == cnRow[t_cid])
                var taskLists = [Task]()
                
                for task in try db!.prepare(taskTable) {
                    taskLists.append( Task(
                        cid: task[t_cid],
                        tid: task[tid],
                        taskName: task[taskName],
                        taskType: task[taskType],
                        taskDate: task[taskDate],
                        taskTime: task[taskTime],
                        description: task[description],
                        isChecked: task[isChecked]))
                }
                
                courseTasks.append(taskLists)
            }
        } catch {
            print("Select failed")
        }
        
        return courseTasks
    }

    
    
    func getCourseTasks(tcid: Int64) -> [Task] {
        var courseTasks = [Task]()
        
        do {
            let query = tasks.filter(t_cid == tcid)
            
            for task in try db!.prepare(query) {
                courseTasks.append( Task(
                    cid: task[t_cid],
                    tid: task[tid],
                    taskName: task[taskName],
                    taskType: task[taskType],
                    taskDate: task[taskDate],
                    taskTime: task[taskTime],
                    description: task[description],
                    isChecked: task[isChecked]))
            }
        } catch {
            print("Select failed")
        }
        
        return courseTasks
    }
    
    func getCourseTasksCount(ccid: Int64) -> Int {
        var count: Int?

        do {
            count = try db!.scalar(tasks.filter(ccid == t_cid).count)
        } catch {
            print("Select failed")
        }

        return count!
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
    
    
    
}
