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
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        statusLabel.layer.cornerRadius = statusLabel.frame.height/2
//        statusLabel.layer.masksToBounds = true
//        statusLabel.lineBreakMode = .byClipping
//        
//        self.roundCorners(corners: [.allCorners], radius: 10)
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
//        self.contentView.frame = contentView.frame.inset(by: margins)
//    }
    
    func setup(task: Task) {
        nameLabel.text = task.taskName
        dateLabel.text = task.getDateToString()
        statusLabel.text = task.isChecked ? "A" : "IP"
    }
}
