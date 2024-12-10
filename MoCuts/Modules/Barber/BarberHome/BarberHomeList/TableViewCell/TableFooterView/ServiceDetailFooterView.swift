//
//  ServiceDetailFooterView.swift
//  MoCuts
//
//  Created by Saif Ahmed  on 04/10/2021.
//

import UIKit

class ServiceDetailFooterView: UIView {
   
    @IBOutlet weak var subTotalCharges: UILabel!
    @IBOutlet weak var salesTaxCharges: UILabel!
    @IBOutlet weak var commisionCharges: UILabel!
    @IBOutlet weak var totalCharges: UILabel!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var comissionSV: UIStackView!
    @IBOutlet weak var salesTaxSV: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor(hex: "#F1F7FE")
        self.underLineView.isHidden = true
    }

}
