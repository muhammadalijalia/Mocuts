//
//  FAQQuestionCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 24/08/2021.
//

import UIKit

class FAQQuestionCell: UITableViewCell {

    @IBOutlet var questionText : UILabel!
    
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