//
//  BarberTodayServiceView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 09/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class BarberTodayServiceView: BaseView, Routeable {

    @IBOutlet weak var cosmosView : UIImageView!
    @IBOutlet weak var tableView : SelfSizedTableView!
    @IBOutlet weak var onTheWayBtn : MoCutsAppButton!
    @IBOutlet weak var navView : UIView!
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    var inputs : [String] = ["dbfjkbadsjkbcbajksbdjcbjkdsbjcbjldsbjlcbjldsn", "dbfjkbaddsvbjnsjdsjkbcbajksbdjcbjkdsbjcbdbcbsjcdbsdjbvojjldsbjlcbjldsn", "dbfjkbaddsvbjnsjdvbsjbjovcdsbojvonkodcnwoncdsjkbcbajksbdjcbjkdsbjcbdbcbsjcdbsdjbvojjldsbjlcbjldsn"]

    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel = GetStartedViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setView()
        self.setButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.maxHeight = 400
        tableView.reloadData()
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.addAnimatingGradient()
        }
        self.cosmosView.layer.cornerRadius = 5
        self.tableView.layer.cornerRadius = 5
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TotalServiceCell", bundle: nil), forCellReuseIdentifier: "TotalServiceCell")
        tableView.register(UINib(nibName: "ServiceNameCell", bundle: nil), forCellReuseIdentifier: "ServiceNameCell")
        tableView.register(UINib(nibName: "TotalChargesCell", bundle: nil), forCellReuseIdentifier: "TotalChargesCell")
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    private func addAnimatingGradient() {
        
        self.navView.backgroundColor = UIColor.clear
        let gradientOne = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.5).cgColor
        let gradientTwo = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.001).cgColor
        gradientSet.append([gradientOne, gradientTwo])
        gradient.frame = self.navView.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.locations = [0.0, 1.0]
        gradient.drawsAsynchronously = true
        self.navView.layer.insertSublayer(gradient, at :0)
    }
    
    func setButton() {
        self.onTheWayBtn.buttonColor = .blue
        self.onTheWayBtn.setText(text: "On The Way")
        self.onTheWayBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            let vc : BarberOnMyWayView = AppRouter.instantiateViewController(storyboard: .Barbertrack)
            self.route(to: vc, navigation: .push)
        })
    }
    
    @IBAction func backBtnTapped(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reportBtnAction(_ sender : UIButton) {
        let attributedString = NSAttributedString(string: "Report Profile", attributes: [
            NSAttributedString.Key.font : Theme.getAppMediumFont(withSize: 18),
            NSAttributedString.Key.foregroundColor : UIColor.black
        ])
        
        let alert = UIAlertController(title: "Report Profile", message: nil, preferredStyle: .actionSheet)
        
        let subview = alert.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertContentView.layer.cornerRadius = 15
        alert.view.tintColor = Theme.appOrangeColor
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Inappropriate Messages", style: .default, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: "Fake Profile", style: .default, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: "Not A Professional", style: .default, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: "Others", style: .default, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


extension BarberTodayServiceView : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalServiceCell", for: indexPath) as! TotalServiceCell
            cell.serviceCount.text = "4 Services Selected"
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceNameCell", for: indexPath) as! ServiceNameCell
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceNameCell", for: indexPath) as! ServiceNameCell
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceNameCell", for: indexPath) as! ServiceNameCell
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceNameCell", for: indexPath) as! ServiceNameCell
            return cell
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalChargesCell", for: indexPath) as! TotalChargesCell
            cell.totalCharges.text = "$40.00"
            return cell
        }
        return UITableViewCell()
    }
}
