//
//  UIViewController.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 7/10/19.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import Foundation
import UIKit
//import MMDrawerController

// MARK: - UIViewController extension
extension UIViewController {
    
    /// To get Drawer Side Menu.
    ///
    /// - Returns: returns bar button of side menu
//    func sideMenuButton () -> UIBarButtonItem {
//
//        let leftDrawerButton = MMDrawerBarButtonItem(target: self, action: #selector(self.openDrawer))
//        leftDrawerButton?.tintColor = UIColor.black
//        leftDrawerButton?.image = UIImage(named: "menu")
//
//        return leftDrawerButton!
//    }
//
//    @objc func openDrawer () {
//        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
//    }
//    @objc func closeDrawer (completion: ((Bool) -> Void)? = nil) {
//        self.mm_drawerController.closeDrawer(animated: true, completion: completion)
//    }
//    /// Function to enable sidemenu in viewcontroller
//    func enableSideMenu() {
//        if self.mm_drawerController != nil {
//            self.mm_drawerController.openDrawerGestureModeMask = .bezelPanningCenterView
//        }
//    }
//
//    /// Function to disable sidemenu in viewcontroller
//    func disableSideMenu() {
//        if self.mm_drawerController != nil {
//            self.mm_drawerController.openDrawerGestureModeMask = .init(rawValue: 0)
//        }
//    }
}


extension UITableViewCell{
    func formatMobile(mobileNumber : String) -> Bool{
       
        var numberTemp : String = mobileNumber
        numberTemp = numberTemp.replacingOccurrences(of: " ", with: "")
        print(mobileNumber)
        if numberTemp.isNumeric == true{
            
            if numberTemp.charactersArray.count > 0{
           
                if numberTemp.charactersArray.count > 1{
                    
                    if numberTemp.charactersArray.count > 11{
                        return false
                    }else{
                        if numberTemp.charactersArray.count == 11{
                            //self.clearError()
                            return false
                            
                        }
                    }
                }
            }
        }else{
            if numberTemp.charactersArray.count >= 11{
                return false
            }
            return false
        }
        return true
    }
}

