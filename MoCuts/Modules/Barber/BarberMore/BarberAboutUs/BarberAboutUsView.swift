//
//  BarberAboutUsView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 27/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class BarberAboutUsView: BaseView, Routeable {
    
    @IBOutlet weak var textView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GetStartedViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setView()
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, title: "About Us", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
    }
}
