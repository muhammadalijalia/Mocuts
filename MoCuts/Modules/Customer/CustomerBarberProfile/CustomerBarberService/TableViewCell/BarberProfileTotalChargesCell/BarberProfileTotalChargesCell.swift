//
//  BarberProfileTotalChargesCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 01/08/2021.
//

import UIKit

class BarberProfileTotalChargesCell: UITableViewCell {

    @IBOutlet weak var totalCharges: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = UIColor(hex: "#F1F7FE")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
