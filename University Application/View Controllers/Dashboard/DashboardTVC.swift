//
//  DashboardTVC.swift
//  University Application
//
//  Created by Jason Yeoh on 13/09/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit

class DashboardTVC: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deptLabel: UILabel!
    @IBOutlet weak var courseNumLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        return dateFormatter.string(from: date)
    }
    
    func getTimeToString(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        
        return dateFormatter.string(from: time)
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
    
    func setup(courseClass: CourseClass, date: Date) {
        let day = getWeekdayToString(weekday: Calendar.current.component(.weekday, from: date))

        dayLabel.text = day
        dateLabel.text = getDateToString(date: date).uppercased()
        deptLabel.text = courseClass.dept
        courseNumLabel.text = String(courseClass.courseNum)
        locationLabel.text = courseClass.location
        startTimeLabel.text = getTimeToString(time: courseClass.startTime)
        endTimeLabel.text = getTimeToString(time: courseClass.endTime)
    }
}
