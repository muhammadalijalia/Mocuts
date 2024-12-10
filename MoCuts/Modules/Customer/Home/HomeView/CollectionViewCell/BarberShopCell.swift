//
//  BarberShopCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 02/08/2021.
//

import UIKit

class BarberShopCell: UICollectionViewCell {

    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopAddress: UILabel!
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet var ratingLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var viewAllText: UILabel!
    @IBOutlet weak var noBarberView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bgView.backgroundColor = .white
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 5
        viewAll.layer.cornerRadius = 5
        noBarberView.layer.cornerRadius = 5
        viewAll.isHidden = true
        viewAllText.isHidden = true
        noBarberView.isHidden = true
        bgView.backgroundColor = .white
        bgView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        bgView.layer.shadowOpacity = 1
        bgView.layer.shadowOffset = .zero
        bgView.layer.shadowRadius = 5
        
        noBarberView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        noBarberView.layer.shadowOpacity = 1
        noBarberView.layer.shadowOffset = .zero
        noBarberView.layer.shadowRadius = 5
    }
}
