//
//  BarberReceiveChatCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 17/08/2021.
//

import UIKit

class BarberReceiveChatCell: UITableViewCell {

    @IBOutlet weak var chatImage : UIImageView!
    @IBOutlet weak var chatText : UITextView!
    @IBOutlet weak var receiveTime : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
