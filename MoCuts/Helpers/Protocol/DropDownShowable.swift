//
//  CameraPermitable.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 11/2/18.
//  Copyright © 2018 Appiskey. All rights reserved.
//

import Foundation
import DropDown

/// POP Way to show location date pop in event listing
protocol DropDownShowable {
    
    /// Find selected index
    var selectedIndex : Int? {get}
    func getDropDown(_ sender: AnchorView) -> DropDown
    var dataSource : [String] {get set}
}

extension DropDownShowable {
    
    /// send drop down to caller only to open/close
    func getDropDown(_ sender: AnchorView) -> DropDown {
        
        let dropDown = DropDown()
        dropDown.anchorView = sender
        
        dropDown.dataSource = dataSource
        
        dropDown.cellNib = UINib(nibName: "OptionDropdownCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? OptionDropdownCell else { return }
            
            // Setup your custom UI components
            cell.tickImage.isHidden = self.selectedIndex != index
            cell.bottomLine.isHidden = index == (self.dataSource.count - 1)
            //     cell.optionLabel.textColor = AppTheme.currentTheme().primaryTextColor
        }
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.show()
        dropDown.dismissMode = .automatic
        let senderWidth = sender.plainView.frame.width - 30
        dropDown.width =  senderWidth > 150 ? senderWidth : 150
        
        dropDown.cornerRadius = 4.0
        
        return dropDown
    }
}
