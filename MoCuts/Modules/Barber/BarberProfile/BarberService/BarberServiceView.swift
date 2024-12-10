//
//  BarberServiceView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 11/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

protocol BarberServiceViewDelegate: AnyObject {
    func refreshService()
}

class BarberServiceView : BaseView, Routeable {
        
    @IBOutlet weak var tableView : UITableView!
    var refreshControl: UIRefreshControl!
    var barberObj : User_Model?
    var delegate: BarberServiceViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BarberServiceViewModel()
        setView()
        setupRefreshControl()
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(handleRefreshControl),
                                    for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    @objc func handleRefreshControl() {
        delegate?.refreshService()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.refreshControl.endRefreshing()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BarberServiceCell", bundle: nil), forCellReuseIdentifier: "BarberServiceCell")
        tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        tableView.separatorStyle = .none
    }
    
    func updateService(serviceId: Int, isEnable: Bool) {
        (viewModel as! BarberServiceViewModel).setBarberServiceData = { [weak self] service in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                dump(service)
            }
        }
    }
    
    @IBAction func addServiceBtn(_ sender : UIButton) {
        let vc : BarberAddNewServiceView = AppRouter.instantiateViewController(storyboard: .Barberprofile)
        vc.setNewServiceRoute = { [weak self] service in
            
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                guard let newService = service.data else { return }
                self.barberObj?.services?.append(newService)
                self.tableView.reloadData()
            }
        }
        self.route(to: vc, navigation: .push)
    }

}

extension BarberServiceView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = barberObj?.services?.count ?? 0
        return count == 0 ? 1 : count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (barberObj?.services?.count ?? 0) == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
            cell.noDataImage.image = UIImage(named: "service")
            cell.noDataMessage.text = "Oops! No services\nadded by barber yet!"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarberServiceCell", for: indexPath) as! BarberServiceCell
        let serviceObj = self.barberObj?.services?[indexPath.row]
        let time = serviceObj?.duration ?? 0
        
        cell.serviceName.text = serviceObj?.name ?? ""
        cell.servicePrice.text = "$ \(serviceObj?.price ?? 0)"
        if time < 60 {
            cell.serviceTime.text = "\(time) mins"
        }else{
            cell.serviceTime.text = "\(Float(time) / 60.0) hours"
        }
        
        if serviceObj?.is_active == 1 || serviceObj?.is_active == nil{
            cell.serviceName.isEnabled = true
            cell.serviceTime.isEnabled = true
            cell.servicePrice.isEnabled = true
        }else{
            cell.serviceName.isEnabled = false
            cell.serviceTime.isEnabled = false
            cell.servicePrice.isEnabled = false
        }
        
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
}

extension BarberServiceView : BarberServiceCellMethod {
    
    func showServiceMenu(indexPath: IndexPath?) {
        
        let indexPath = IndexPath(row: indexPath?.row ?? 0, section: indexPath?.section ?? 0)
        let cell = tableView.cellForRow(at: indexPath) as! BarberServiceCell
        
        let attributedString = NSAttributedString(string: "Menu", attributes: [
            NSAttributedString.Key.font : Theme.getAppMediumFont(withSize: 18),
            NSAttributedString.Key.foregroundColor : UIColor.black
        ])
        let alert = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        let subview = alert.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertContentView.layer.cornerRadius = 15
        alert.view.tintColor = Theme.appOrangeColor
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Edit Service", style: .default, handler: { _ in
            let vc : BarberEditServiceView = AppRouter.instantiateViewController(storyboard: .Barberprofile)
            
            let servObj = self.barberObj?.services?[indexPath.row]
            let time = servObj?.duration ?? 0
            vc.serviceTitleText = servObj?.name ?? ""
            vc.serviceFeeText = "$ \(servObj?.price ?? 0)"
            vc.serviceFee = "\(servObj?.price ?? 0)"
            vc.serviceDuration = "\(servObj?.duration ?? 0)"
            vc.serviceId = servObj?.id ?? 0
            vc.index = indexPath.row
            
            vc.setEditServiceRoute = { [weak self] service in
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    guard let service = service.data else { return }
                    self.barberObj?.services?.remove(at: indexPath.row)
                    self.barberObj?.services?.insert(service, at: indexPath.row)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
            
            vc.deleteServiceRoute = { [weak self] service, index in
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    self.barberObj?.services?.remove(at: index)
                    self.tableView.reloadData()
                    ToastView.getInstance().showToast(inView: self.view, textToShow: service.message ?? "",backgroundColor: Theme.appOrangeColor)
                }
            }
            
            if time < 60 {
                vc.serviceTimeText = "\(time) Mins"
            }else{
                vc.serviceTimeText = "\(Float(time) / 60.0) Hours"
            }
            self.route(to: vc, navigation: .push)
            
        }))
        
        let is_Active = self.barberObj?.services?[indexPath.row].is_active ?? 0
        let service_id = self.barberObj?.services?[indexPath.row].id ?? 0

        if is_Active == 0 {
            alert.addAction(UIAlertAction(title: "Enable Service", style: .default, handler: { _ in
                
                (self.viewModel as! BarberServiceViewModel).changeServiceStatus(serviceId: service_id, isEnable: true)
                
                (self.viewModel as! BarberServiceViewModel).setBarberServiceData = { [weak self] service in
                    DispatchQueue.main.async {
                        guard let self = self else {
                            return
                        }
                        self.barberObj?.services?[indexPath.row].is_active = service.data?.is_active ?? 0
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                    
                }
//
//                cell.serviceName.isEnabled = true
//                cell.serviceTime.isEnabled = true
//                cell.servicePrice.isEnabled = true
                
            }))
        } else {
            alert.addAction(UIAlertAction(title: "Disable Service", style: .default, handler: { _ in
                
                (self.viewModel as! BarberServiceViewModel).changeServiceStatus(serviceId: service_id, isEnable: false)
                
                (self.viewModel as! BarberServiceViewModel).setBarberServiceData = { [weak self] service in
                    DispatchQueue.main.async {
                        guard let self = self else {
                            return
                        }
                        self.barberObj?.services?[indexPath.row].is_active = service.data?.is_active ?? 0
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                    
                }
//                cell.serviceName.isEnabled = false
//                cell.serviceTime.isEnabled = false
//                cell.servicePrice.isEnabled = false
                
            }))
        }
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
