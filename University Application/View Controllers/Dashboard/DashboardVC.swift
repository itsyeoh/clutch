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

    fileprivate weak var calendar: FSCalendar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In loadView or viewDidLoad
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        self.calendar = calendar    // In loadView(Recommended) or viewDidLoad
        // Do any additional setup after loading the view.
    }
}

extension DashboardVC: FSCalendarDataSource, FSCalendarDelegate {
    
}
