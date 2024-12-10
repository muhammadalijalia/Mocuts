//
//  TotalServiceCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 01/08/2021.
//

import UIKit

class TotalServiceCell: UITableViewCell {

    @IBOutlet weak var serviceCount : UILabel!
    @IBOutlet weak var totalTime : UILabel!

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
