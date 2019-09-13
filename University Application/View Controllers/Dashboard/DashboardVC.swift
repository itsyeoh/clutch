//
//  DashboardVC.swift
//  University Application
//
//  Created by Jason Yeoh on 11/09/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit
import FSCalendar

class DashboardVC: UIViewController {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dashboardTableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    private var courseClasses = [CourseClass]()
    private var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "DASHBOARD"
        
        dashboardTableView.dataSource = self
        dashboardTableView.delegate = self
        calendar.dataSource = self
        calendar.delegate = self
        
        let weekday = Calendar.current.component(.weekday, from: Date())
        let day = getWeekdayToString(weekday: weekday)

        courseClasses = UniversityDB.instance.getCourseClassesByDate(date: Date(), day: day)
    }
    
    func getWeekdayToString(weekday: Int) -> String {
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
    
    func getDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        
        return dateFormatter.string(from: date)
    }
}

extension DashboardVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if courseClasses.count == 0 {
            tableView.setEmptyMessage("NO CLASSES TODAY BAKS!")
        } else {
            tableView.restore()
        }
        return courseClasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let courseClass = courseClasses[indexPath.row]
        let cell = dashboardTableView.dequeueReusableCell(withIdentifier: "DashboardCell") as! DashboardTVC
        cell.setup(courseClass: courseClass, date: selectedDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
}

extension DashboardVC: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let cal = Calendar.current
        let day = getWeekdayToString(weekday: Calendar.current.component(.weekday, from: date))
        courseClasses = UniversityDB.instance.getCourseClassesByDate(date: date, day: day)
        dashboardTableView.reloadData()
        selectedDate = date

        if cal.isDateInYesterday(date) {
            dayLabel.text = "Yesterday"
        } else if cal.isDateInToday(date) {
            dayLabel.text = "Today"
        } else if cal.isDateInTomorrow(date) {
            dayLabel.text = "Tomorrow"
        } else {
            dayLabel.text = getDateToString(date: date)
        }
    }
}
