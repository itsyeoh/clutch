//
//  SemesterTVC.swift
//  University Application
//
//  Created by Jason Yeoh on 25/08/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit

class SemesterTVC: UITableViewCell {

    @IBOutlet weak var previewSeasonTextLabel: UILabel!
    @IBOutlet weak var previewYearTextLabel: UILabel!
    @IBOutlet weak var seasonTextLabel: UILabel!
    @IBOutlet weak var datesTextLabel: UILabel!
    
    override func awakeFromNib() {
        
//        self.roundCorners(corners: [.topLeft, .topRight], radius: 10)
//        super.awakeFromNib()
    }
    
    func setup(semester: Semester) {
        previewSeasonTextLabel.text = String(semester.season.uppercased().prefix(2))
        previewYearTextLabel.text = semester.getDateToYearString(date: semester.startDate)
        seasonTextLabel.text = semester.getSeasonTextLabel()
        datesTextLabel.text = semester.getDateToString(date: semester.startDate) + " to " +
                              semester.getDateToString(date:semester.endDate)
    }
}
