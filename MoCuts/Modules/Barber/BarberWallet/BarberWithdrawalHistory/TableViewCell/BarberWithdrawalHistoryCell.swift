//
//  BarberWithdrawalHistoryCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 17/08/2021.
//

import UIKit

class BarberWithdrawalHistoryCell: UITableViewCell {

    @IBOutlet weak var withdrawalDate : UILabel!
    @IBOutlet weak var withdrawalTime : UILabel!
    @IBOutlet weak var withdrawalAmount : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
