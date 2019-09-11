//
//  CourseClassTVC.swift
//  University Application
//
//  Created by Jason Yeoh on 29/08/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit

class CourseClassTVC: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dayTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(aClass: Class) {
        typeLabel.text = aClass.getClassTypePrefix()
        dayTimeLabel.text = aClass.getClassTimeAndDay()
        locationLabel.text = aClass.location
    }

}
