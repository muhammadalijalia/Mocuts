//
//  NavigationController.swift
//  MoCuts
//
//  Created by Ahmed Khan on 06/12/2021.
//

import Foundation
class NavigationController: UINavigationController, UIGestureRecognizerDelegate {

    /// Custom back buttons disable the interactive pop animation
    /// To enable it back we set the recognizer to `self`
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

}
