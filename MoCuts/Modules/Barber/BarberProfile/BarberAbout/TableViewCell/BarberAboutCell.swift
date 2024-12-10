//
//  BarberAboutCell.swift
//  MoCuts
//
//  Created by Abdul Basit on 20/10/2021.
//

import UIKit

class BarberAboutCell: UITableViewCell {

    @IBOutlet weak var barberDescriptionLbl: UILabel!
    @IBOutlet weak var galleryCV: UICollectionView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var descriptionNoDataViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.galleryCV.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
