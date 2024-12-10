//
//  CustomerBarberAboutView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 25/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

protocol CustomerBarberAboutViewDelegate: AnyObject {
    func refreshData()
}

class CustomerBarberAboutView : BaseView, Routeable {
    
    @IBOutlet weak var barberDescription : UITextView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var refreshControl = UIRefreshControl()
    var delegate: CustomerBarberAboutViewDelegate?
    
    var barberAboutDescription = "" {
        didSet {
            if barberDescription != nil {
                barberDescription.text = barberAboutDescription
                barberDescription.alpha = barberDescription.text == "" ? 0 : 1
                noDataView.alpha = barberDescription.text == "" ? 1 : 0
                refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setView()
        refreshControl.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        if #available(iOS 10.0, *) {
            scrollView.refreshControl = refreshControl
        } else {
            scrollView.addSubview(refreshControl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        barberDescription.text = barberAboutDescription
        barberDescription.alpha = barberDescription.text == "" ? 0 : 1
        noDataView.alpha = barberDescription.text == "" ? 1 : 0
    }
    
    @objc func refreshHandler() {
        delegate?.refreshData()
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
