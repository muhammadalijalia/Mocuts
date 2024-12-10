//
//  ServiceAddRemoveCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 25/08/2021.
//

import UIKit

protocol ServiceAddRemoveCellMethod : AnyObject {
    func serviceAddRemove(indexPath : IndexPath?)
}

class ServiceAddRemoveCell: UITableViewCell {
    
    @IBOutlet weak var serviceName : UILabel!
    @IBOutlet weak var serviceDuration : UILabel!
    @IBOutlet weak var servicePrice : UILabel!
    @IBOutlet weak var addRemoveBtn : UIButton!
    
    weak var delegate : ServiceAddRemoveCellMethod?
    var indexPath : IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.addRemoveBtn.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addRemoveBtnAction(_ sender : UIButton) {
        self.delegate?.serviceAddRemove(indexPath: indexPath)
    }
}
