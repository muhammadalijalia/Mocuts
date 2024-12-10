//
//  BarberListingTableViewCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 03/08/2021.
//

import UIKit

class BarberListingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var viewAllText: UILabel!
    
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopAddress: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.cornerRadius = 5
        viewAll.layer.cornerRadius = 5
        self.viewAll.isHidden = true
        self.viewAllText.isHidden = true
        
        bgView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        bgView.layer.shadowOpacity = 1
        bgView.layer.shadowOffset = .zero
        bgView.layer.shadowRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
