//
//  BarberTimeSlotCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 16/08/2021.
//

import UIKit

class BarberTimeSlotCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var timeSlotLabel : UILabel!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.layer.cornerRadius = 5
        self.bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor(hex: "#04396C").cgColor
    }
}
