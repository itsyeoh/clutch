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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dashboardTableView.dataSource = self
//        dashboardTableView.delegate = self
        calendar.dataSource = self
        calendar.delegate = self
    }
}

extension DashboardVC: FSCalendarDataSource, FSCalendarDelegate {
    
}
