//
//  OrgTaskTVC.swift
//  University Application
//
//  Created by Jason Yeoh on 16/09/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import UIKit

class OTaskTVC: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
