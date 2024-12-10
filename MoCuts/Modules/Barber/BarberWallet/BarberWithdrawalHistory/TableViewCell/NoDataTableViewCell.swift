//
//  NoDataTableViewCell.swift
//  MoCuts
//
//  Created by Ahmed Khan on 04/11/2021.
//

import UIKit

class NoDataTableViewCell: UITableViewCell {

    @IBOutlet var noDataMessage: UILabel!
    @IBOutlet var noDataImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
