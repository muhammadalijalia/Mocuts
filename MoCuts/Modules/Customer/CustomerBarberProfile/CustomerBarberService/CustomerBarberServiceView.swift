//
//  CustomerBarberServiceView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 25/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class CustomerBarberServiceView : BaseView, Routeable {
    
    @IBOutlet weak var tableView : SelfSizedTableView!
    @IBOutlet weak var requestServiceBtn : MoCutsAppButton!
    var filterServices: [SelectableService] = []
    var serviceModels: [CustomerServiceModel] = []
    var refreshControl = UIRefreshControl()
    var didLoadOnce = false
    var selectedTimeSlot: TimeSlot!
    var selectedDate = ""
    var barberProfile: BarberModel!
    var selectedItems: [SelectableService] {
        get {
            return filterServices.filter({ item in
                return item.isSelected
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        setTableView()
        setupViewModel()
        setupRefreshControl()
        setServiceRequestObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setView()
        if !didLoadOnce {
            getServices()
        }
    }
    
    func setupViewModel() {
        viewModel = CustomerBarberServiceViewModel()
        setServices()
    }
    
    func setServices() {
        (viewModel as! CustomerBarberServiceViewModel).onServicesRetrieval = { [weak self] services in
            guard let self = self else {
                return
            }
            self.didLoadOnce = true
            self.serviceModels.removeAll()
            self.filterServices.removeAll()
            self.serviceModels = services
            for service in services {
                if service.isActive == 1 {
                    let newService = SelectableService(serviceName: service.name ?? "",servicePrice: service.price ?? 0, isSelected: false, duration: service.duration ?? 0, id: String(service.id ?? 0))
                    self.filterServices.append(newService)
                }
            }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
        (viewModel as! CustomerBarberServiceViewModel).onError = { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
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
        self.requestServiceBtn.isHidden = true
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        refreshControl.beginRefreshing()
        getServices()
    }
    
    func getServices() {
        (viewModel as! CustomerBarberServiceViewModel).getServices(userId: String(barberProfile.id ?? 0))
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ServiceAddRemoveCell", bundle: nil), forCellReuseIdentifier: "ServiceAddRemoveCell")
        tableView.register(UINib(nibName: "ChooseDateTimeCell", bundle: nil), forCellReuseIdentifier: "ChooseDateTimeCell")
        tableView.register(UINib(nibName: "BarberProfileTotalServiceCell", bundle: nil), forCellReuseIdentifier: "BarberProfileTotalServiceCell")
        tableView.register(UINib(nibName: "BarberProfileServiceNameCell", bundle: nil), forCellReuseIdentifier: "BarberProfileServiceNameCell")
        tableView.register(UINib(nibName: "TotalChargesCell", bundle: nil), forCellReuseIdentifier: "TotalChargesCell")
        tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.maxHeight = 10
        print(self.tableView.contentSize.height)
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setButton() {
        self.requestServiceBtn.buttonColor = .orange
        self.requestServiceBtn.setText(text: "Request Services")
        let userModel = UserPreferences.userModel
        self.requestServiceBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            guard self.selectedTimeSlot != nil else {
                self.viewModel.showPopup = "Date/Time Required"
                return
            }
            guard userModel?.address ?? "" != "" else {
                let yesAction = UIAlertAction(title: "YES", style: .default, handler: { action in
                    let vc : EditProfileView = AppRouter.instantiateViewController(storyboard: .more)
                    self.route(to: vc, navigation: .push)
                })
                
                let noAction = UIAlertAction(title: "NO", style: .destructive, handler: nil)
                
                Utilities.shared.showAlert(title: "Alert", message: "Location required to request service(s). Edit profile now?", actions: [yesAction, noAction], alertStyle: .alert, defaultActionTitle: "Alert", isDefaultActionReq: false, vc: self, dismissTime: nil)
                return
            }
            
            var serviceIds = [String]()
            for item in self.selectedItems {
                serviceIds.append(String(item.id))
            }
            (self.viewModel as! CustomerBarberServiceViewModel).requestService(barberId: String(self.barberProfile.id ?? 0), availabilityId: String(self.selectedTimeSlot.id ?? 0), date: self.selectedDate, items: serviceIds)
        })
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.requestServiceBtn.isHidden = true
    }
    
    func setServiceRequestObservers() {
        (viewModel as! CustomerBarberServiceViewModel).onServiceRequestResponse = { [weak self] response in
            guard let self = self else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.routeBack(navigation: .popToRootVC)
            }
        }
        (viewModel as! CustomerBarberServiceViewModel).onServiceRequestError = { [weak self] error in
            guard let self = self else {
                return
            }
            if error == "Insufficient Amount in your wallet" {
                let yesAction = UIAlertAction(title: "YES", style: .default, handler: { action in
                    let vc: AddNewCardView = AppRouter.instantiateViewController(storyboard: .wallet)
                    self.route(to: vc, navigation: .push)
                })
                
                let noAction = UIAlertAction(title: "NO", style: .default, handler: nil)
                
                Utilities.shared.showAlert(title: error, message: "Add amount in your wallet?", actions: [yesAction, noAction], alertStyle: .alert, defaultActionTitle: "Alert", isDefaultActionReq: false, vc: self, dismissTime: nil)
            }
        }
    }
}

extension CustomerBarberServiceView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if didLoadOnce {
            if section == 0 {
                return filterServices.count == 0 ? 1 : filterServices.count
            } else if section == 1 {
                return filterServices.count == 0 ? 0 : 1
            } else if section == 2 {
                
                if selectedItems.count == 0 {
                    return 0
                } else {
                    return selectedItems.count + 2
                }
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            if filterServices.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                cell.noDataImage.image = UIImage(named: "service")
                cell.noDataMessage.text = "Oops! No services\nadded by barber yet!"
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceAddRemoveCell", for: indexPath) as! ServiceAddRemoveCell
            let data = filterServices[indexPath.row]
            
            cell.serviceName.text = data.serviceName
            cell.serviceDuration.text = Utilities.shared.getSecondsInWords(seconds: Double((data.duration) * 60))
            
            cell.servicePrice.text = "$ \(String(format: "%.2f", Double(data.servicePrice)))"
            if data.isSelected {
                cell.addRemoveBtn.setTitle("Remove", for: .normal)
                cell.addRemoveBtn.layer.borderColor = Theme.appOrangeColor.cgColor
                cell.addRemoveBtn.setTitleColor(Theme.appOrangeColor, for: .normal)
                cell.addRemoveBtn.layer.borderWidth = 1
            } else {
                cell.addRemoveBtn.setTitle("Add", for: .normal)
                cell.addRemoveBtn.layer.borderColor = Theme.appNavigationBlueColor.cgColor
                cell.addRemoveBtn.setTitleColor(Theme.appNavigationBlueColor, for: .normal)
                cell.addRemoveBtn.layer.borderWidth = 1
            }
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseDateTimeCell", for: indexPath) as! ChooseDateTimeCell
            if selectedTimeSlot == nil {
                cell.dateTimeLabel.text = "Choose Date/Time"
            } else {
                let startTimeDate = DateManager.shared.getDate(from: selectedTimeSlot.startTime ?? "", format: "HH:mm:ss")
                let endTimeDate = DateManager.shared.getDate(from: selectedTimeSlot.endTime ?? "", format: "HH:mm:ss")
                let startTime = DateManager.shared.getString(from: startTimeDate!, format: "hh:mm aa", needsZone:  false)
                let endTime = DateManager.shared.getString(from: endTimeDate!, format: "hh:mm aa", needsZone:  false)
                cell.dateTimeLabel.text = "\(selectedDate) AT \(startTime) - \(endTime)"
            }
            
            return cell
        } else if indexPath.section == 2 {
            var totalDuration = 0
            var subTotal = 0
            for item in selectedItems {
                totalDuration += item.duration
                subTotal += item.servicePrice
            }
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BarberProfileTotalServiceCell", for: indexPath) as! BarberProfileTotalServiceCell
                cell.serviceCount.text = "\(selectedItems.count) Services Selected"
                cell.totalTime.text = "(\(Utilities.shared.getSecondsInWords(seconds: Double(totalDuration * 60), isMins: true)))"
                cell.backgroundColor = UIColor(hex: "#F1F7FE")
                return cell
            }
            
            if selectedItems.count != 0 {
                if indexPath.row == selectedItems.count + 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TotalChargesCell", for: indexPath) as! TotalChargesCell
                    cell.comissionSV.isHidden = true
                    cell.subTotalCharges.text = "$ \(String(format: "%.2f", Double(subTotal)))"
                    cell.salesTaxCharges.text = "10.00 %"
                    let total = Double(subTotal) + Double(subTotal) * 0.1
                    cell.totalCharges.text = "$ \(String(format: "%.2f", total))"
                    return cell
                }
            }
            guard selectedItems.count != 0 else {
                return UITableViewCell()
            }
            let data = selectedItems[indexPath.row - 1]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BarberProfileServiceNameCell", for: indexPath) as! BarberProfileServiceNameCell
            cell.serviceName.text = data.serviceName
            cell.serviceCharges.text = "$ \(String(format: "%.2f", Double(data.servicePrice)))"
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return filterServices.count == 0 ? UITableView.automaticDimension : 70
        } else if indexPath.section == 1 {
            return 90
        } else {
            if indexPath.row == selectedItems.count + 1 {
                return UITableView.automaticDimension
            } else {
                return 44
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc : CustomerSelectDateTimeView = AppRouter.instantiateViewController(storyboard: .Customerbarberprofile)
            var duration = 0
            for selectedItem in selectedItems {
                duration += selectedItem.duration
            }
            vc.timeSlotSelectionCallback = { [weak self] timeSlot, slotDate in
                guard let self = self else {
                    return
                }
                self.selectedTimeSlot = timeSlot
                self.selectedDate = slotDate
                self.tableView.reloadData()
            }
            vc.userId = barberProfile.id ?? 0
            vc.duration = String(duration)
            self.route(to: vc, navigation: .push)
        }
    }
}

extension CustomerBarberServiceView : ServiceAddRemoveCellMethod {
    func serviceAddRemove(indexPath: IndexPath?) {
        
        if let indexPath = indexPath, indexPath.section == 0 {
            filterServices[indexPath.row].isSelected = !filterServices[indexPath.row].isSelected
            if selectedItems.count > 0 {
                requestServiceBtn.isHidden = false
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: requestServiceBtn.frame.height + 10, right: 0)
            } else {
                requestServiceBtn.isHidden = true
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            selectedTimeSlot = nil
            selectedDate = ""
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

struct SelectableService {
    var serviceName : String
    var servicePrice: Int
    var isSelected : Bool
    var duration: Int
    var id: String
}
