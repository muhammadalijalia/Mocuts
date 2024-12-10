//
//  TabBarView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 26/07/2021.
//

import Foundation
import UIKit

class TabBarView: UITabBarController {
    var whiteView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBar.barTintColor = .white
        self.tabBar.isTranslucent = false
        NotificationCenter.default.addObserver(self, selector: #selector(toggleWhiteView), name: Notification.Name(rawValue: "toggleWhiteView"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.itemPositioning = .centered
        if !UIDevice.current.hasNotch {
            tabBar.frame = CGRect(x: 0, y: self.view.frame.height - tabBar.frame.size.height - 5, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
            if whiteView != nil {
                if whiteView.alpha == 0 {
                    return
                }
                whiteView.alpha = 0
                whiteView.removeFromSuperview()
            }
            whiteView = UIView(frame: CGRect(x: tabBar.frame.minX, y: tabBar.frame.minY + 5, width: tabBar.frame.width, height: tabBar.frame.height + 5))
            whiteView.backgroundColor = .white
            self.view.addSubview(whiteView)
            self.view.bringSubviewToFront(tabBar)
        }
    }
    
    @objc func toggleWhiteView(_ notification: NSNotification) {
        if let toggle = notification.userInfo?["toggle"] as? Bool, whiteView != nil {
            whiteView.alpha = toggle ? 1 : 0
            whiteView.isHidden = !toggle
            if !toggle {
                self.view.sendSubviewToBack(whiteView)
            }
        }
    }
}
