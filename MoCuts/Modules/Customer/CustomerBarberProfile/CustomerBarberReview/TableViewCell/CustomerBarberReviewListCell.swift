//
//  CustomerBarberReviewListCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 16/08/2021.
//

import UIKit

class CustomerBarberReviewListCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var review: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
