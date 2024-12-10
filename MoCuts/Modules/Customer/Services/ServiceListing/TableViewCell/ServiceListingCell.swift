//
//  ServiceListingCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 31/07/2021.
//

import UIKit

class ServiceListingCell: UITableViewCell {

    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var shopName : UILabel!
    @IBOutlet weak var serviceName : UILabel!
    @IBOutlet weak var dateTime : UILabel!
    @IBOutlet weak var shopImage : UIImageView!
    @IBOutlet weak var trackService : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 5
        trackService.layer.cornerRadius = 2
        trackService.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
