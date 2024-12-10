//
//  BarberSettingPushNotificationCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 03/08/2021.
//

import UIKit

class BarberSettingPushNotificationCell: UITableViewCell {

    @IBOutlet weak var itemTitle : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.itemTitle.font = Theme.getAppFont(withSize: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
