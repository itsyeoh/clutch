//
//  WidgetTVC.swift
//  UniBakla Widget
//
//  Created by Jason Yeoh on 16/09/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit

class WidgetTVC: UITableViewCell {

    @IBOutlet weak var deptLabel: UILabel!
    @IBOutlet weak var courseNumLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(courseClass: CourseClass) {
        
    }

}
