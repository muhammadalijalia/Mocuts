//
//  PlaceHolderable.swift
//  MoCuts
//
//  Created by Appiskey's iOS Dev on 9/14/19.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import Foundation
import UIKit

protocol PlaceHolderable {
    
    var placeHolder: String { get set }
    var placeHolderColor: UIColor { get set }
    var themeColor: UIColor { get set }
    
    func setPlaceHolder()
    func textFieldDidBeign(_ textField: UITextView)
    func textFieldDidEnd(_ textField: UITextView)
}

extension PlaceHolderable where Self : UITextView {
    
    func setPlaceHolder() {
        self.text = placeHolder
        self.textColor = placeHolderColor
    }
    func textFieldDidBeign(_ textField: UITextView) {
        if self.textColor == placeHolderColor {
            self.text = ""
            self.textColor = themeColor
        }
    }
    func textFieldDidEnd(_ textField: UITextView) {
        if self.text.isEmpty {
            setPlaceHolder()
        }
    }
}
