//
//  ScholarShipLabel.swift
//  Scholarship
//
//  Copyright © 2017 PNC. All rights reserved.
//

import Foundation
import UIKit
import Swift

//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//

///This custom label is use in whole app label
///It can automatically assign app font to label

//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//

class AppLabel: UILabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setFont()
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.setFont()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setFont(){
        if self.font!.isBold {
            self.font = Theme.getAppBoldFont(withSize: self.font!.pointSize)
        } else if self.font!.isMedium {
            self.font = Theme.getAppMediumFont(withSize: self.font!.pointSize)
        } else {
            self.font = Theme.getAppFont(withSize: self.font!.pointSize)
        }
    }
}


extension UIFont {
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isMedium: Bool {
        if(fontName.contains("Medium")){
            return true
        }else{
            return false
        }
    }
    
    var isRegular: Bool {
        if(fontName.contains("Regular")){
            return true
        }else{
            return false
        }
    }
    
}
