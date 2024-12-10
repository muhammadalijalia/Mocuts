//
//  FilterServiceCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 24/08/2021.
//

import UIKit

class FilterServiceCell: UICollectionViewCell {
    
    @IBOutlet weak var serviceName : UILabel!
    @IBOutlet weak var mainView : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mainView.layer.borderWidth = 1
        self.mainView.layer.borderColor = Theme.appNavigationBlueColor.cgColor
        self.mainView.layer.cornerRadius = 4
    }
}
