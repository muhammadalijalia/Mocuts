//
//  ChooseDateTimeCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 25/08/2021.
//

import UIKit

class ChooseDateTimeCell: UITableViewCell {

    @IBOutlet weak var mainView : UIView!
    @IBOutlet var dateTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.mainView.layer.borderWidth = 1
        self.mainView.layer.borderColor = Theme.appTextFieldPlaceHolderColor.cgColor
        self.mainView.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
