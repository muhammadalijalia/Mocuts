//
//  PPGenericTextView.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 16/08/2020.
//  Copyright © 2020 Appiskey. All rights reserved.
//

import UIKit

class PPGenericTextView: CustomNibView {
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var bottomLine: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        txtView.text = "Placeholder"
        txtView.textColor = UIColor.lightGray
    }
    

    
    
    private func commitInit(){
        Bundle.main.loadNibNamed("PPGenericComponent", owner: self, options: nil)
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
        self.lblName.textColor = Theme.appOrangeColor
        self.bottomLine.backgroundColor = Theme.appOrangeColor
    }
    

}
