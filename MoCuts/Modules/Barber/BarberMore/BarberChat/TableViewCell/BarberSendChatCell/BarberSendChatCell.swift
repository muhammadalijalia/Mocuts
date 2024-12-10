//
//  BarberSendChatCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 17/08/2021.
//

import UIKit

class BarberSendChatCell: UITableViewCell {

    @IBOutlet weak var chatImage : UIImageView!
//    @IBOutlet weak var chatText : UILabel!
    @IBOutlet weak var sendTime : UILabel!
    @IBOutlet weak var chatTextView: UITextView!
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
