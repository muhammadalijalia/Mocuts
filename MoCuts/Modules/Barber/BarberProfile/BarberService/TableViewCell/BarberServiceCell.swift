//
//  BarberServiceCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 16/08/2021.
//

import UIKit

protocol BarberServiceCellMethod : AnyObject {
    func showServiceMenu(indexPath : IndexPath?)
}

class BarberServiceCell: UITableViewCell {

    @IBOutlet weak var serviceName : UILabel!
    @IBOutlet weak var serviceTime : UILabel!
    @IBOutlet weak var servicePrice : UILabel!
    
    weak var delegate : BarberServiceCellMethod?
    var indexPath : IndexPath?
    var serviceDisabled : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func serviceMenu(_ sender : UIButton) {
        delegate?.showServiceMenu(indexPath: self.indexPath)
    }
}
