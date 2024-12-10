//
//  CustomerNotificationUnreadCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 10/08/2021.
//

import UIKit

class CustomerNotificationUnreadCell: UITableViewCell {
    
    @IBOutlet weak var unreadNotification : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        // Configure the view for the selected state
    }
    
}
