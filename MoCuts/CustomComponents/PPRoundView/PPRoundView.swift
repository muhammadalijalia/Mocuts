//
//  ViewWithTextField.swift
//  MoCuts
//
//  Created by Appiskey
//  Copyright © 2017 Appiskey. All rights reserved.
//

import UIKit

class PPRoundView: UIView,NibFileOwnerLoadable {
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
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
        
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.mainView.layer.cornerRadius = self.frame.width * 0.5
        self.mainView.clipsToBounds = true
    }
    
    var isSelected: Bool = false {
        didSet {
            //            let theme = AppTheme.currentTheme()
            //            if isSelected {
            //                
            //                self.mainView.backgroundColor = theme.primary
            //                self.numberLabel.textColor = theme.primaryBackground
            //                self.mainView.layer.borderColor = UIColor.clear.cgColor
            //                self.mainView.layer.borderWidth = 0.0
            //            } else {
            //                self.mainView.backgroundColor = theme.primaryBackground
            //                self.numberLabel.textColor = theme.primaryTextColor
            //                self.mainView.layer.borderColor = theme.primaryTextColor.cgColor
            //                self.mainView.layer.borderWidth = 1.0
            //            }
        }
    }
    
    var viewTag: Int = 0
    
    func setButton(tag: Int, isSelected: Bool) {
        self.viewTag = tag
        self.isSelected = isSelected
        self.numberLabel.text = "\(tag)"
    }
}
