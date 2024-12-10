//
//  BarberTimeSwitchCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 31/08/2021.
//

import UIKit

protocol BarberTimeSwitchCellDelegate {
    func switchValueChangedHandler(cell: BarberTimeSwitchCell, switchState: Bool)
}

class BarberTimeSwitchCell: UITableViewCell {

    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var switchOutlet : UISwitch!
    @IBOutlet weak var timeText : UILabel!
    
    var delegate: BarberTimeSwitchCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 4
        switchOutlet.addTarget(self, action: #selector(switchIsChanged), for: UIControl.Event.valueChanged)

    }
    
    @objc func switchIsChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            self.delegate?.switchValueChangedHandler(cell: self, switchState: true)
        } else {
            self.delegate?.switchValueChangedHandler(cell: self, switchState: false)
        }
    }
    
    func changeSwitchState(switchs: UISwitch){
        if switchs.isOn {
            switchOutlet.thumbTintColor = UIColor(red: 64/255, green: 141/255, blue: 122/255, alpha: 1)
        } else {
            switchOutlet.thumbTintColor =  UIColor(red: 218/255, green: 62/255, blue: 50/255, alpha: 1)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        if switchOutlet.isOn {
//        } else {
//        }
    }
    
}
