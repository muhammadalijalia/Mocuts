//
//  TotalChargesCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 01/08/2021.
//

import UIKit

class TotalChargesCell: UITableViewCell {

    @IBOutlet weak var subTotalCharges: UILabel!
    @IBOutlet weak var salesTaxCharges: UILabel!
    @IBOutlet weak var commisionCharges: UILabel!
    @IBOutlet weak var totalCharges: UILabel!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var comissionSV: UIStackView!
    @IBOutlet weak var salesTaxSV: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = UIColor(hex: "#F1F7FE")
        self.underLineView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
