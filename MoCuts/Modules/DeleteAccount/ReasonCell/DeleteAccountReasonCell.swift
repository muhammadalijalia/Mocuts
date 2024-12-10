//
//  DeleteAccountReasonCell.swift
//  PoshOnTheGo
//
//  Created by Ahmed on 21/02/2023.
//

import UIKit

class DeleteAccountReasonCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stateBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(title: String, isSelected: Bool) {
        titleLabel.text = title
        stateBtn.isSelected = isSelected
    }
}
