//
//  BarberOnMyWayCompleteView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 27/08/2021.
//

import Foundation
import UIKit
import Helpers
import CommonComponents

class BarberOnMyWayCompleteView: BaseView , Routeable {
    
    @IBOutlet weak var locationView : UIView!
    @IBOutlet weak var serviceDetailView : UIView!
    @IBOutlet weak var currentLocationField : UITextField!
    @IBOutlet weak var destinationField : UITextField!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var completeServiceBtn : UIButton!
    
    var isComplete : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setView()
        setTableView()
    }
    
    
    func setView() {
        
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, title: "On Going Service", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
        
        locationView.layer.cornerRadius = 5
        locationView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        locationView.layer.shadowOpacity = 1
        locationView.layer.shadowOffset = .zero
        locationView.layer.shadowRadius = 5
        
        serviceDetailView.layer.cornerRadius = 5
        serviceDetailView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        serviceDetailView.layer.shadowOpacity = 1
        serviceDetailView.layer.shadowOffset = .zero
        serviceDetailView.layer.shadowRadius = 5
        
        completeServiceBtn.layer.cornerRadius = 5
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TotalServiceCell", bundle: nil), forCellReuseIdentifier: "TotalServiceCell")
        tableView.register(UINib(nibName: "ServiceNameCell", bundle: nil), forCellReuseIdentifier: "ServiceNameCell")
        tableView.register(UINib(nibName: "TotalChargesCell", bundle: nil), forCellReuseIdentifier: "TotalChargesCell")
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
    }
    
    @IBAction func completeBtnAction(_ sender : UIButton) {
        
        //        if !isComplete {
        //            isComplete = true
        //            completeServiceBtn.backgroundColor = Theme.appOrangeColor
        //            completeServiceBtn.setTitle("        Pay Now        ", for: .normal)
        //        } else {
//        let vc : MyCardsView = AppRouter.instantiateViewController(storyboard: .wallet)
//        self.route(to: vc, navigation: .push)
        let vc : BarberRateView = AppRouter.instantiateViewController(storyboard: .Barberprofile)
        vc.screenCase = .barber
        self.route(to: vc, navigation: .modal)
        //        }
    }
}

extension BarberOnMyWayCompleteView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalServiceCell", for: indexPath) as! TotalServiceCell
            cell.serviceCount.text = "2 Services Selected"
            cell.totalTime.text = "(50 mins)"
            cell.totalTime.font = Theme.getAppFont(withSize: 14)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceNameCell", for: indexPath) as! ServiceNameCell
            cell.backgroundColor = .clear
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceNameCell", for: indexPath) as! ServiceNameCell
            cell.backgroundColor = .clear
            return cell
        }  else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalChargesCell", for: indexPath) as! TotalChargesCell
            cell.backgroundColor = .clear
            cell.totalCharges.text = "$20.00"
            cell.underLineView.isHidden = false
            return cell
        }
        return UITableViewCell()
    }
}
