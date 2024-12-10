//
//  ChoiceCell.swift
//  MoCuts
//
//  Created by Muhammad Farooq on 09/08/2024.
//

import UIKit

class ChoiceCell: UITableViewCell {
    static var identifier = "ChoiceCell"
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(choiceInfo: PaymentChoiceView.ChoiceInfo?) {
        if let icon = choiceInfo?.icon {
            imgIcon.image = UIImage(named: icon)
        }
        if let name = choiceInfo?.name {
            lblName.text = name
        }
    }
}
