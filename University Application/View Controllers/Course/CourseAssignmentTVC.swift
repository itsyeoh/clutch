//
//  CourseAssignmentTVC.swift
//  University Application
//
//  Created by Jason Yeoh on 29/08/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit

class CourseAssignmentTVC: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(task: Task) {
        nameLabel.text = task.taskName
        dateLabel.text = task.getDateToString()
    }
}
