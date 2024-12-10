//
//  BarberNotificationCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 10/08/2021.
//

import UIKit

class BarberNotificationCell: UITableViewCell {

    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var notificationTile : UILabel!
    @IBOutlet weak var lastTime : UILabel!
    @IBOutlet weak var profileImage : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
        }
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
