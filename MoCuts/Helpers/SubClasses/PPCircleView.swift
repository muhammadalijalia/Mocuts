//
//  PPCircleView.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 7/23/19.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import UIKit

/// This is default class of this app, Purpose of this class is to set round button
class PPCircleView: UIView, Circleable {
    
    override func layoutSubviews() {
        self.cirleView()
    }
}
class PPCircleImageView: UIImageView,Circleable {
    
    override func layoutSubviews() {
        self.cirleView()
    }
}

protocol Circleable where Self:UIView {
    func cirleView()
}
extension Circleable {
    func cirleView() {
        self.layer.cornerRadius = self.frame.width * 0.5
    }
}
