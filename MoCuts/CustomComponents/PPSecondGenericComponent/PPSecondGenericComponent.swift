//
//  PPSecondGenericComponent.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 22/06/2020.
//  Copyright © 2020 Appiskey. All rights reserved.
//

import UIKit

class PPSecondGenericComponent: CustomNibView {

   @IBOutlet weak var txtField: UITextField!
       @IBOutlet weak var lblName: UILabel!
       @IBOutlet weak var bottomLine: UIView!
       @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgLeading: NSLayoutConstraint!
    
       override init(frame: CGRect) {
           super.init(frame: frame)
           
       }
       
       private func commitInit(){
           Bundle.main.loadNibNamed("PPSecondGenericComponent", owner: self, options: nil)
           addSubview(contentView)
           contentView.frame = self.bounds
           contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]

       }
       required init?(coder aDecoder: NSCoder) {
              // 1. setup any properties here
              
              // 2. call super.init(coder:)
              super.init(coder: aDecoder)
             
              // 3. Setup view from .xib file
              //loadNibContent()
         
              xibSetup()
          }
          
       func xibSetup(){
           //self.lblName.textColor = Theme.blackHeadingColor
//           self.bottomLine.backgroundColor = Theme.grayColorLight
           self.txtField.attributedPlaceholder = NSAttributedString(string: "PlaceHolder",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: Theme.appOrangeColor])
       }

}
