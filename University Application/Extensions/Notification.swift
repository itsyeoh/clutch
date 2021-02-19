//
//  Notification.swift
//  University Application
//
//  Created by Jason Yeoh on 16/09/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation
import UserNotifications

class Notification {
    static func getWeekdayToString(weekday: Int) -> String {
        switch weekday {
        case 1:
            return "S"
        case 2:
            return "M"
        case 3:
            return "T"
        case 4:
            return "W"
        case 5:
            return "R"
        case 6:
            return "F"
        case 7:
            return "S"
        default:
            return "M"
        }
    }
    
//    static func getNotification() {
//        let weekday = Calendar.current.component(.weekday, from: Date())
//        let day = Notification.getWeekdayToString(weekday: weekday)
//        let courseClasses = UniversityDB.instance.getCourseClassesByDate(date: Date(), day: day)
//        
//        let content = UNMutableNotificationContent()
//        content.title = courseClasses[0].dept
//        content.body = "Chika lang baks"
//        
//        var dateComponents = DateComponents()
//        dateComponents.calendar = Calendar.current
//        
//        dateComponents.hour = 22
//        dateComponents.minute = 22
//        dateComponents.second = 15
//        
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        let uuidString = UUID().uuidString
//        let request = UNNotificationRequest(identifier: uuidString,
//                                            content: content, trigger: trigger)
//        
//        // Schedule the request with the system.
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.add(request) { (error) in
//            if error != nil {
//                // Handle any errors.
//            }
//        }
//        
//    }
}
