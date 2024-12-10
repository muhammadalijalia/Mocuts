//
//  ScholarShipTextView.swift
//  Scholarship
//
//  Copyright © 2017 PNC. All rights reserved.
//

import UIKit
//import CommonComponents

//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//

///This custom TextView is use in whole app UITextView
///It can automatically assign app font to UITextView

//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//
class AppTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupFont()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupFont()
    }
    
    func setupFont(){
        if self.font!.isBold{
            self.font = Theme.getAppBoldFont(withSize: self.font!.pointSize)
        }else if self.font!.isMedium{
            self.font = Theme.getAppMediumFont(withSize: self.font!.pointSize)
        }else{
            self.font = Theme.getAppFont(withSize: self.font!.pointSize)
        }
    }
    
    func setPadding(left: CGFloat? = nil, right: CGFloat? = nil){
        if let left = left {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        
        if let right = right {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}
