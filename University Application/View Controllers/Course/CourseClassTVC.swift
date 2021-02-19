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
    
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    private var daysLabel: [UILabel]!
    
    @IBOutlet weak var classView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        sundayLabel.layer.cornerRadius = sundayLabel.frame.width/2
        mondayLabel.layer.cornerRadius = mondayLabel.frame.width/2
        tuesdayLabel.layer.cornerRadius = tuesdayLabel.frame.width/2
        wednesdayLabel.layer.cornerRadius = wednesdayLabel.frame.width/2
        thursdayLabel.layer.cornerRadius = thursdayLabel.frame.width/2
        fridayLabel.layer.cornerRadius = fridayLabel.frame.width/2
        saturdayLabel.layer.cornerRadius = saturdayLabel.frame.width/2
        
        sundayLabel.layer.masksToBounds = true
        mondayLabel.layer.masksToBounds = true
        tuesdayLabel.layer.masksToBounds = true
        wednesdayLabel.layer.masksToBounds = true
        thursdayLabel.layer.masksToBounds = true
        fridayLabel.layer.masksToBounds = true
        saturdayLabel.layer.masksToBounds = true
        
        daysLabel = [sundayLabel, mondayLabel, tuesdayLabel, wednesdayLabel, thursdayLabel,
                     fridayLabel, saturdayLabel]
        
//        classView.roundCorners(corners: [.allCorners], radius: 10)
    }
    
    
    func setupDaysLabel(label: UILabel, isScheduled: Bool) {
        if isScheduled {
            label.backgroundColor = Theme.Primary
            label.textColor = .white
        } else {
            label.backgroundColor = Theme.Primary_2
            label.textColor = Theme.Primary
        }
    }
    
    func setup(aClass: Class) {
        typeLabel.text = aClass.getClassTypePrefix()
        dayTimeLabel.text = aClass.getClassTime()
        locationLabel.text = aClass.location
        
        var dayBoolArray = aClass.getClassDays()
        
        print(dayBoolArray)
        var index = 0
        for dayLabel in daysLabel {
            setupDaysLabel(label: dayLabel, isScheduled: dayBoolArray[index])
            index += 1
        }
    }

}
