//
//  MyCardCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 06/08/2021.
//

import UIKit

class MyCardCell: UITableViewCell {

    @IBOutlet weak var cardImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.cardImage.contentMode = .scaleAspectFill
        self.cardImage.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
