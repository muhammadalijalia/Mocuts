//
//  CardCell.swift
//  MoCuts
//
//  Created by Ahmed Khan on 29/11/2021.
//

import UIKit
protocol CardCellDelegate: AnyObject {
    func bgTapped(cell: CardCell)
}

class CardCell: UITableViewCell {
    @IBOutlet var bgView: UIView!
    @IBOutlet var cardBrandHeadingLbl: UILabel!
    @IBOutlet var cardExpiryHeadingLbl: UILabel!
    @IBOutlet var cardNumberHeadingLbl: UILabel!
    @IBOutlet var cardBrandLbl: UILabel!
    @IBOutlet var cardExpiryLbl: UILabel!
    @IBOutlet var cardNumberLbl: UILabel!
    var delegate: CardCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 6
        bgView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        bgView.layer.borderWidth = 1
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bgTapped))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(singleTapGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        
        // Configure the view for the selected state
    }
    
    func updateData(expiry: String, name: String, number: String) {
        cardBrandLbl.text = name
        cardExpiryLbl.text = expiry
        cardNumberLbl.text = number
    }
    
    func toggleBackground(isSelected: Bool) {
        if isSelected {
            bgView.backgroundColor = Theme.appOrangeColor
            cardBrandHeadingLbl.textColor = .white
            cardExpiryHeadingLbl.textColor = .white
            cardNumberHeadingLbl.textColor = .white
            cardBrandLbl.textColor = .white
            cardExpiryLbl.textColor = .white
            cardNumberLbl.textColor = .white
        } else {
            bgView.backgroundColor = .white
            cardBrandHeadingLbl.textColor = .black
            cardExpiryHeadingLbl.textColor = .black
            cardNumberHeadingLbl.textColor = .black
            cardBrandLbl.textColor = .black
            cardExpiryLbl.textColor = .black
            cardNumberLbl.textColor = .black
        }
    }
    
    @objc func bgTapped() {
        delegate?.bgTapped(cell: self)
    }
}
