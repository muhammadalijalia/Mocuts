//
//  NoDataTableViewBackground.swift
//  MoCuts
//
//  Created by Ahmed Khan on 22/11/2021.
//

import UIKit

class NoDataTableViewBackground : UIView {
    
    @IBOutlet var noDataImageView: UIImageView!
    @IBOutlet var noDataLabel: UILabel!
    
    var noDataImage = "BarberShop" {
        didSet {
            noDataImageView.image = UIImage(named: noDataImage)
        }
    }
    
    var noDataText = "Oops! No today's services\nfound!" {
        didSet {
            noDataLabel.text = noDataText
        }
    }
}
