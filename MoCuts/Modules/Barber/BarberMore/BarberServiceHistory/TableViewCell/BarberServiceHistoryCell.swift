//
//  BarberServiceHistoryCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 05/08/2021.
//

import UIKit

class BarberServiceHistoryCell: UITableViewCell {

    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var shopName : UILabel!
    @IBOutlet weak var serviceName : UILabel!
    @IBOutlet weak var dateTime : UILabel!
    @IBOutlet weak var shopImage : UIImageView!
    @IBOutlet weak var statusBtn : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.backgroundColor = UIColor(hex: "#EDFFFB")
        bgView.layer.cornerRadius = 5
        statusBtn.layer.cornerRadius = 2
        self.selectionStyle = .none
//        trackService.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
