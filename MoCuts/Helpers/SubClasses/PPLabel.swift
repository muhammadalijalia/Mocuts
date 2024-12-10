//
//  PPLabel.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 31/12/2019.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import Foundation
import UIKit

class PPLabel: PPShimmerView{
    var label : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    override func xibSetup() {
        super.xibSetup()
        self.label = UILabel.init(frame: self.mainView.frame)
        self.mainView.addSubview(self.label)
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    func makeLabel(){
        
    }
}
