//
//  ChatHeader.swift
//  MoCuts
//
//  Created by Ahmed Khan on 09/11/2021.
//

import Foundation
import UIKit

@objc protocol ChatHeaderDelegate: AnyObject {
    @objc func itemTapped()
}

class ChatHeader: UIView {

    var delegate: ChatHeaderDelegate?
    @IBOutlet var timeLabel: UILabel!
    
    var time: String = "" {
        didSet {
            timeLabel.text = time
        }
    }
    
    @IBAction func itemTapped() {
        delegate?.itemTapped()
    }
}
