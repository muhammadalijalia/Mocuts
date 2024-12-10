//
//  BarberMoreItemListingCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 27/07/2021.
//

import UIKit

class BarberMoreItemListingCell: UITableViewCell {
    
    @IBOutlet weak var iconImage : UIImageView!
    @IBOutlet weak var itemTitle : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.itemTitle.font = Theme.getAppFont(withSize: 15)
        self.iconImage.image = UIImage(named: "MyProfileIcon")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
