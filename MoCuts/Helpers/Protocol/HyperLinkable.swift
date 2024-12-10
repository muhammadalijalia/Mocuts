//
//  HyperLinkable.swift
//  MoCuts
//
//  Created by Mohammad Zawwar Mohammad Zawwar on 16/08/2018.
//  Copyright © 2018 APPISKEY. All rights reserved.
//

import Foundation
import UIKit

protocol HyperLinkable {
    
    func setTermsAndCondition (textView : UITextView, text: String, attributedString: [HyeperLink], textColor: UIColor, hyperlinkColor: UIColor) 
}
extension HyperLinkable where Self: UIViewController {
    
    /// Private funciton to setTerms and condition
    func setTermsAndCondition (textView : UITextView, text: String, attributedString: [HyeperLink], textColor: UIColor, hyperlinkColor: UIColor) {
        
        let str = text
        let attributedStringColor = [NSAttributedString.Key.foregroundColor : textColor]
        var attributedStr = NSMutableAttributedString(string: str, attributes: attributedStringColor)
        
        for attribs in attributedString {
            attributedStr = makeHyperLink(string: attributedStr, hyperLink: attribs )
        }
        textView.attributedText = attributedStr
        textView.textAlignment = .left
        textView.font = Theme.getAppFont(withSize: 15)
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor : hyperlinkColor]
    }
    /// Make hyperlinks to some part of text in textview.
    private func makeHyperLink(string: NSMutableAttributedString, hyperLink: HyeperLink) -> NSMutableAttributedString {
        
        let foundRange = string.mutableString.range(of: hyperLink.subString)
        
        let dic : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.underlineStyle : NSNumber(value: 1),
            NSAttributedString.Key.link : hyperLink.url
        ]
        string.addAttributes(dic, range: foundRange)
        return string
    }
    
}
struct HyeperLink {
    var subString : String
    var url : String
    
    init(subString: String, url: String) {
        self.subString = subString
        self.url = url
    }
}
