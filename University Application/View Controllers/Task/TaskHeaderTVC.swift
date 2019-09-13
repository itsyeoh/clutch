//
//  TaskHeaderTVC.swift
//  University Application
//
//  Created by Jason Yeoh on 01/09/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit

class TaskHeaderTVC: UITableViewCell {
    @IBOutlet weak var titleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(task: Task) {
        titleButton.setTitle(task.getWeekDateToString(), for: .normal)
    }
    
    func setupByCourseName(course: Course) {
        titleButton.setTitle(course.showCourseName(), for: .normal)
    }
    
    func setupEmpty() {
        self.contentView.backgroundColor = .clear
        titleButton.setTitle("", for: .normal)
    }
}
