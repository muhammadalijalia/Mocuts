//
//  SettingPushNotificationCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 03/08/2021.
//

import UIKit
protocol SettingPushNotificationCellDelegate: AnyObject {
    func switchTapped(isOn: Bool)
}

class SettingPushNotificationCell: UITableViewCell {

    @IBOutlet weak var itemTitle : UILabel!
    @IBOutlet weak var switcher: UISwitch!
    var delegate: SettingPushNotificationCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.itemTitle.font = Theme.getAppFont(withSize: 15)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func switchTapped() {
        delegate?.switchTapped(isOn: switcher.isOn)
    }
}
