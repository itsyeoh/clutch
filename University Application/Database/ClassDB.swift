//
//  ClassDB.swift
//  University Application
//
//  Created by Jason Yeoh on 10/16/19.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation
import SQLite

extension UniversityDB {
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
}
