//
//  NibFileOwnerLoadable.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 7/25/19.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import Foundation
import UIKit

public protocol NibFileOwnerLoadable: UIView {}

public extension NibFileOwnerLoadable {
    
    /**
     Returns a `UIView` object instantiated from nib
     */
    func instantiateFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }
    
    /**
     * Load the content of the first view in the XIB.
     * Then add this as subview with constraints
     */
    func loadNibContent() {
        guard let view = instantiateFromNib() else {
            fatalError("Failed to instantiate \(String(describing: Self.self)).xib")
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        let views = ["view": view]
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .alignAllLastBaseline, metrics: nil, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .alignAllLastBaseline, metrics: nil, views: views)
        addConstraints(verticalConstraints + horizontalConstraints)
    }
}
