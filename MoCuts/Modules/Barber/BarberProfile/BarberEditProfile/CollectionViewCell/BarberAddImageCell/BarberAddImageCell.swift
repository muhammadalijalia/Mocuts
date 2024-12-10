//
//  BarberAddImageCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 23/08/2021.
//

import UIKit

class BarberAddImageCell: UICollectionViewCell {

    @IBOutlet weak var dottedView : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        DispatchQueue.main.async {
//            let frameSize = self.dottedView.frame.size
//            let shapeRect = CGRect(x:0 , y: 0, width: frameSize.width, height: frameSize.height)
//            
//            let customBorder = CAShapeLayer()
//            customBorder.strokeColor = UIColor(hex: "#04396C").cgColor
//            customBorder.lineDashPattern = [4, 4]
//            customBorder.frame = shapeRect
//            customBorder.fillColor = nil
//            customBorder.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 4, height: 4)).cgPath
//            self.dottedView.layer.addSublayer(customBorder)
//        }
    }
}
