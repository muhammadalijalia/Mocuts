//
//  Theme.swift
//  MoCuts
//
//  Created by Mohammad Zawwar Mohammad Zawwar on 11/06/2018.
//  Copyright © 2018 Appiskey. All rights reserved.
//

import Foundation
import UIKit

class Theme {
    
    static var appOrangeColor : UIColor { return UIColor(hex: "DC3C2A") }
    static var appYellowColor : UIColor { return UIColor(hex: "AD6700") }
    
    static var appButtonBlueColor : UIColor { return UIColor(hex: "04396C") }
    static var appButtonGreenColor : UIColor { return UIColor(hex: "3C8E7A") }

    static var appNavigationBlueColor : UIColor { return UIColor(hex: "04396C") }
    static var appTextFieldPlaceHolderColor : UIColor { return UIColor(hex: "666666") }
    
    static func getAppOrangeButton(withAlpha alpha: CGFloat) -> UIColor{
        return appOrangeColor.withAlphaComponent(alpha)
    }
    static func getAppFont(withSize: CGFloat) -> UIFont {
        return UIFont(name: Constants.regularFont, size: withSize)!
    }
    static func getAppMediumFont(withSize: CGFloat) -> UIFont {
        return UIFont(name: Constants.mediumFont, size: withSize)!
    }
    static func getAppBoldFont(withSize: CGFloat) -> UIFont {
        return UIFont(name: Constants.boldFont, size: withSize)!
    }
}

/// Theme class to handle colors in app.

