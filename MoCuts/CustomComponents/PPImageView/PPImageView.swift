//
//  PPImageView.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 30/07/2020.
//  Copyright © 2020 Appiskey. All rights reserved.
//

import UIKit
import SDWebImage
class PPImageView: UIView,NibFileOwnerLoadable {
    
    @IBOutlet weak var mainView: UIView!
       @IBOutlet weak var profileImage: PPCircleImageView!
       @IBOutlet weak var smallImage: UIImageView!
       @IBOutlet weak var circleView: PPCircleView!
       
       //let theme = AppTheme.currentTheme()
       var viewModel = PPImageViewModel()
       var action: (() -> Void)? = nil
       var currentImage: UIImage? = nil
       
       var currentCase: ScreenCase = .normal
       
       enum ScreenCase {
           case create
           case edit
           case normal
       }
       
       override init(frame: CGRect) {
           // 1. setup any properties here
           
           // 2. call super.init(frame:)
           super.init(frame: frame)
           
           // 3. Setup view from .xib file
           loadNibContent()
           
           xibSetup()
       }
       
       required init?(coder aDecoder: NSCoder) {
           // 1. setup any properties here
           
           // 2. call super.init(coder:)
           super.init(coder: aDecoder)
           
           // 3. Setup view from .xib file
           loadNibContent()
           
           xibSetup()
       }
       
       
       func xibSetup() {
           bindWithError()
           bindWithScreenDesign()
       }
       
       @IBAction func profileButtonTapped(_ sender: Any) {
           self.action?()
       }
       
       func setDefault(with screenCase: PPImageView.ScreenCase, action:(() -> Void)? = nil) {
           self.currentCase = screenCase
        self.mainView.backgroundColor = Theme.appOrangeColor
           if self.currentImage != nil{
               self.profileImage.image = self.currentImage
           }else{
               self.profileImage.image = UIImage(named: "pet1")
           }
           self.action = action
           viewModel.setView(currentCase: currentCase)
       }
       
       func setError(){
           self.mainView.backgroundColor = UIColor.red
       }
       
       func setNormal(withImage image: UIImage){
           self.mainView.backgroundColor = Theme.appOrangeColor
           self.profileImage.image = image
           self.currentImage = image
       }
       
       func bindWithError() {
           viewModel.setError = {
               self.setError()
           }
       }
       
       func bindWithScreenDesign() {
           viewModel.setScreenDesign = { isVisible, name in
               DispatchQueue.main.async {
                   self.smallImage.image = UIImage(named: name)
                   self.smallImage.isHidden = !isVisible
               }
           }
       }
       
    
       func setImage(with url:String) {
           
           if url == "" {
               DispatchQueue.main.async {
                   self.profileImage.image = UIImage(named: "avatar_default")!
               }
           } else {
               DispatchQueue.main.async {
                  // self.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                   self.profileImage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "avatar_default"))
               }
           }
       }

}
class PPImageViewModel {
    
    var isImageSelected: Bool = false
    var setError : (() -> Void)?
    var setScreenDesign : ((Bool, String) -> Void)?
    
    func validate() -> Bool {
        if !isImageSelected {
            self.setError?()
            return false
        } else {
            return true
        }
    }
    
    func setView(currentCase: PPImageView.ScreenCase) {
        
        switch currentCase {
        case .create:
            setScreenDesign?(true, "camera")
        case .edit:
            setScreenDesign?(true, "edit")
        case .normal:
            setScreenDesign?(false, "")
            
        }
    }
    
}
