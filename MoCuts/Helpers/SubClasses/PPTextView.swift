//
//  PPTextView.swift
//  MoCuts
//
//  Created by Appiskey's iOS Dev on 9/14/19.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import UIKit

class PPTextView: UITextView, PlaceHolderable {
    
    //let theme = AppTheme.currentTheme()
    var placeHolder = "Write your message here..."
    var placeHolderColor = UIColor.lightGray
    var themeColor: UIColor = .black
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    func commonInit() {
        self.keyboardAppearance = .light
//        self.tintColor = Theme.aquaColorDark
//        self.backgroundColor = Theme.aquaColorDark
//        self.layer.borderColor = Theme.aquaColorDark.cgColor
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.font = Theme.getAppFont(withSize: 15)
        self.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        
        themeColor = Theme.appOrangeColor
        setPlaceHolder()
    }
}
