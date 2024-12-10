//
//  BarberHomeListCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 06/08/2021.
//

import UIKit

class BarberHomeListCell: UITableViewCell {

    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var customerName : UILabel!
    @IBOutlet weak var customerService : UILabel!
    @IBOutlet weak var serviceDate : UILabel!
    @IBOutlet weak var customerImage : UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
