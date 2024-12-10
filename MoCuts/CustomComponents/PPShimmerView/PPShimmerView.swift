//
//  ViewWithTextField.swift
//  MoCuts
//
//  Created by Appiskey
//  Copyright © 2020 Appiskey. All rights reserved.
//

import UIKit
import Shimmer

class PPShimmerView: UIView, NibFileOwnerLoadable {
    
    var isAnimating : Bool = false{
        didSet{
            self.shimmerView.isShimmering = self.isAnimating
        }
    }
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var shimmerView: FBShimmeringView!
    @IBOutlet weak var shimmerContentView: UIView!
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
        self.shimmerView.layer.cornerRadius = 5
        self.shimmerContentView.layer.cornerRadius = 5
        self.shimmerView.contentView = shimmerContentView
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
