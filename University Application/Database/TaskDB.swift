//
//  TaskDB.swift
//  University Application
//
//  Created by Jason Yeoh on 10/16/19.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation
import SQLite

extension UniversityDB {
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
    
    func updateTaskByChecking(id: Int64, checkVar: Bool) -> Bool {
        let selectedTask = tasks.filter(id == tid)
        do {
            let update = selectedTask.update([isChecked <- checkVar])
            
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    // Get tasks based on clusters of distinct dates
    func getTasksByDate(checkVar: Bool) -> [[Task]] {
        var courseTasks = [[Task]]()
        
        do {
            let datesTable = tasks.select(taskDate).order(taskDate.asc).group(taskDate.date)
            // SELECT DISTINCT taskDate FROM tasks
            
            for dateRow in try db!.prepare(datesTable) {
                let taskTable = tasks.filter(taskDate.date == dateRow[taskDate].date)
                                     .filter(isChecked == checkVar)
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
    func getTasksByCourseName(checkVar: Bool) -> [[Task]] {
        var courseTasks = [[Task]]()
        
        do {
            let courseNamesTable = tasks.select(t_cid).group(t_cid).order(dept.asc, courseNum.asc)
            // SELECT Dept, CourseNum FROM tasks
            
            for cnRow in try db!.prepare(courseNamesTable) {
                let taskTable = tasks.filter(t_cid == cnRow[t_cid]).filter(isChecked == checkVar)
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
}
