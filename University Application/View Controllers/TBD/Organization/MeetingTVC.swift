//
//  OrgMeetingTVC.swift
//  University Application
//
//  Created by Jason Yeoh on 16/09/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit

class MeetingTVC: UITableViewCell {

    @IBOutlet weak var numMeetingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
