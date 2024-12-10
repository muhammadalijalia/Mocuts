//
//  BarberPortfolioImageCell.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 23/08/2021.
//

import UIKit

protocol BarberPortfolioImageCellMethod : AnyObject {
    func deleteImage(indexPath : IndexPath?)
}

class BarberPortfolioImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imagePet: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var roundView: UIView!
    
    weak var delegate : BarberPortfolioImageCellMethod?
    var indexPath : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.activity.isHidden = false
        self.deleteButton.isHidden = true
        self.deleteButton.isUserInteractionEnabled = true
        self.imagePet.isHidden = true
        self.activity.startAnimating()
        self.backgroundColor = .clear
    }
    
    @IBAction func deleteImageAction(_ sender : UIButton) {
        delegate?.deleteImage(indexPath: self.indexPath)
    }
}
