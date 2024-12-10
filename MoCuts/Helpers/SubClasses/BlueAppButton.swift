
//
//  ScholarShipButton.swift
//  Scholarship
//
//  Copyright © 2017 PNC. All rights reserved.
//

import Foundation
import UIKit
//import CommonComponents

//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//

///This custom button is use in whole app button
///It can automatically assign app font to button

//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//
class BlueAppButton : UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initiate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func initiate() {
        //        self.titleLabel?.font = Theme.getAppMediumFont(withSize: self.titleLabel!.font.pointSize)
        self.titleLabel?.font = Theme.getAppMediumFont(withSize: 15)
        self.titleLabel?.textAlignment = .left
    }
    
    func setTextColor(color: UIColor) {
        self.setTitleColor(color, for: UIControl.State.normal)
    }
    
    func setColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    func setImage(string: String) {
        self.setImage(UIImage(named: string), for: UIControl.State.normal)
    }
    
    func setUIImage(image: UIImage) {
        self.setImage(image, for: UIControl.State.normal)
    }
    
    func setTitleLbl(string : String, color: UIColor=Theme.appOrangeColor) {
        self.setTitle(string, for: .normal)
        self.titleLabel?.textAlignment = .left
        self.setTitleColor(color, for: UIControl.State.normal)
    }
    
    func setBackgroudColor(color: UIColor=Theme.appOrangeColor.withAlphaComponent(0.8)) {
        self.backgroundColor = color
    }
}
