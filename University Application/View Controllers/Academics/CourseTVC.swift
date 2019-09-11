//
//  CourseTVC.swift
//  University Application
//
//  Created by Jason Yeoh on 25/08/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit

class CourseTVC: UITableViewCell {

    @IBOutlet weak var courseNameTextLabel: UILabel!
    @IBOutlet weak var locationTextLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    private var classCount: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hoursLabel.layer.masksToBounds = true
        hoursLabel.layer.cornerRadius = hoursLabel.frame.size.height/2
    }
    
    func setup(course: Course) {
        let count = UniversityDB.instance.getCourseClassesCount(ccid: course.cid)

        courseNameTextLabel.text = course.showCourseName()
        locationTextLabel.text = String(count) + " classes"
        hoursLabel.text = String(course.creditHours!)
    }
}
