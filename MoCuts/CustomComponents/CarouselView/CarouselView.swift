//
//  CarouselView.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 02/06/2020.
//  Copyright © 2020 Appiskey. All rights reserved.
//

import Foundation
import UIKit

class CarouselView: UIView {
    
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopAddress: UILabel!
    @IBOutlet weak var shopImage: UIImageView!
    
    
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        
    }
    
    func xibSetup() {
        
        
    }
    
}
extension UIView {
    func roundCorners(usingCorners corners: UIRectCorner, cornertRadius: CGSize) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornertRadius)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
