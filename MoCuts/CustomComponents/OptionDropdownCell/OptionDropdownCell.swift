//
//  OptionDropdownCell.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 11/2/18.
//  Copyright © 2018 Appiskey. All rights reserved.
//

import UIKit
import DropDown

class OptionDropdownCell: DropDownCell {
    
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var bottomLine: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
