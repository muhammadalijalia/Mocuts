//
//  FAQAnswerCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 24/08/2021.
//

import UIKit

protocol FAQAnswerCellMethod : AnyObject {
    func expandCell(index : Int)
}

class FAQAnswerCell: UITableViewCell {

    @IBOutlet weak var answerText : UILabel!
    @IBOutlet weak var seeMoreBtn : UIButton!

    weak var delegate : FAQAnswerCellMethod?
    var index : Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.answerText.sizeToFit()
        self.answerText.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func seeMoreBtnAction(_ sender : UIButton) {
        delegate?.expandCell(index: self.index)
    }
}
