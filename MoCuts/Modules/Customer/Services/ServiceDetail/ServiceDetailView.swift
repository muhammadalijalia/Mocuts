//
//  ServiceDetailView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 01/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class ServiceDetailView: BaseView, Routeable {
    
    @IBOutlet weak var dateNTimeLabel: UILabel!
    @IBOutlet weak var customerImgView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var navTitle : UILabel!
    
    @IBOutlet weak var navView : UIView!
    @IBOutlet weak var tableView : SelfSizedTableView!
    @IBOutlet weak var cancelServiceBtn : MoCutsAppButton!
    
    var jobType: ServicesState?
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    var reportTypes = [ReportType]()
    var serviceObject: BarberBaseModel!
    var serviceRequestCallBack: ((BarberBaseModel) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.maxHeight = 400
        self.setTableView()
        viewModel = ServiceDetailViewModel()
        reportsSetup()
    }
    
    func reportsSetup() {
        setOnReportTypes()
        (viewModel as! ServiceDetailViewModel).getReportTypes()
        self.setButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setViewsAndData()
    }
    
    func setViewsAndData() {
        self.setView()
        self.tableView.maxHeight = CGFloat(50 + (serviceObject.job_services?.count ?? 0) * 44 + 150)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func setOnReportTypes() {
        (viewModel as! ServiceDetailViewModel).setReportTypes = { [weak self] response in
            guard let self = self else {
                return
            }
            self.reportTypes = response
        }
    }
    
    func setTableView() {
        self.tableView.layer.cornerRadius = 5
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ServiceNameCell", bundle: nil), forCellReuseIdentifier: "ServiceNameCell")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.addAnimatingGradient()
        }
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        
        if jobType == .pending {
            self.navTitle.text = "Service Details"
//            self.typeLbl.text = "Requested"
        } else if jobType == .today {
            self.navTitle.text = "Today's Services"
//            self.typeLbl.text = "Accepted"
        } else if jobType == .upcoming {
            self.navTitle.text = "Services"
//            self.typeLbl.text = "Accepted"
        }
        self.typeLbl.text = getStatus(with: serviceObject.status ?? 0)
        
        let img = serviceObject.barber?.image_url ?? ""
        let name = serviceObject.barber?.name ?? ""
        let rating = serviceObject.barber?.average_rating ?? 0
        let encodeAddress = serviceObject.barber?.address ?? ""
        let address = encodeAddress.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
        
        let date = Utilities.convertDateFormater(serviceObject.date ?? "", oldFormat: "yyyy-MM-dd", newFormat: "MM/dd/yyyy")
        let startTime = DateFormatterHelper.get12HrsTime(from: DateFormatterHelper.convertStringToDate(format: .onlyTimeWithSecond, stringToConvert: serviceObject.availability?.start_time ?? "") ?? Date())
        let endTime = DateFormatterHelper.get12HrsTime(from: DateFormatterHelper.convertStringToDate(format: .onlyTimeWithSecond, stringToConvert: serviceObject.availability?.end_time ?? "") ?? Date())
        
        let dateNtime = "\(date) - \(startTime) - \(endTime)"
        
        self.customerImgView.sd_setImage(with: URL(string: img), placeholderImage: UIImage())
        self.nameLabel.text = name
        
        self.ratingLabel.text = String(format: rating == 0 ? "%.1f" : "%.2f", rating)
        self.addressLabel.text = address
        self.dateNTimeLabel.text = dateNtime
    }
    func getStatus(with statusCode:Int) -> String {
        if statusCode > 25 {
            cancelServiceBtn.isHidden = true
            return "Completed"
        } else {
            switch statusCode {
            case 5:
                return "Requested"
            case 6:
                cancelServiceBtn.isHidden = true
                return "Rejected"
            case 10:
                return "Accepted"
            case 11:
                return "On the Way"
            case 15:
                return "Arrived"
            case 16:
                cancelServiceBtn.isHidden = true
                return "Unserved"
            case 20:
                cancelServiceBtn.isHidden = true
                return "Barber Cancelled"
            case 25:
                cancelServiceBtn.isHidden = true
                return "User Cancelled"
            default:
                cancelServiceBtn.isHidden = true
                return "Unknown"
            }
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
        self.cancelServiceBtn.buttonColor = .orange
        self.cancelServiceBtn.setText(text: "Cancel Service")
        self.cancelServiceBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to cancel the service?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default) { action -> Void in
                
                (self.viewModel as! ServiceDetailViewModel).setCancelRoute = { [weak self] in
                    
                    DispatchQueue.main.async {
                        guard let self = self else {
                            return
                        }
                        self.serviceObject.status = 25
                        self.serviceRequestCallBack?(self.serviceObject)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                (self.viewModel as! ServiceDetailViewModel).cancelService(serviceID: self.serviceObject.id ?? 0, params: ["status":"25"]
                )
            })
            alertController.addAction(UIAlertAction(title: "No", style: .cancel)
            { action -> Void in
                // Put your code here
            })
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    @IBAction func backBtnAction(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreButtonAction(_ sender : UIButton) {
        
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
        
        for reportType in reportTypes {
            alert.addAction(UIAlertAction(title: reportType.name, style: .default, handler: { action in
                
                for reportType in self.reportTypes {
                    if reportType.name == action.title {
                        (self.viewModel as! ServiceDetailViewModel).sendReport(toId: String(self.serviceObject.user_id ?? 0), reportTypeId: String(reportType.id ?? 0), message: "Reported")
                    }
                }
            }))
        }
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getTotalTimeTakenInMins() -> Int{
        let servicesArray = self.serviceObject.job_services ?? []
        var time: Int = 0
        for serv in servicesArray {
            time += serv.duration ?? 0
        }
        return time
    }
}


extension ServiceDetailView : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let serviceCount = self.serviceObject.job_services?.count ?? 0
        return serviceCount
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: ServerDetailHeaderView = ServerDetailHeaderView.fromNib();
        let totalTimeTaken = self.getTotalTimeTakenInMins()
        let serviceCount = self.serviceObject.job_services?.count ?? 0
        
        view.serviceCount.text = "\(serviceCount) Services Selected"
        if totalTimeTaken <= 59{
            view.totalTime.text = "(\(totalTimeTaken) mins)"
        }else {
            view.totalTime.text = "(\(totalTimeTaken / 60) hours)"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceNameCell", for: indexPath) as! ServiceNameCell
        
        let services = self.serviceObject.job_services?[indexPath.row]
        let serviceName = services?.service?.name ?? ""
        let serviceCharges = services?.service?.price ?? 0
        
        cell.serviceName.text = serviceName
        cell.serviceCharges.text = "$ \(serviceCharges).00"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view: ServiceDetailFooterView = ServiceDetailFooterView.fromNib();
        
        let subTotal = Double(self.serviceObject.sub_total ?? 0)
        let salesTax = Double(self.serviceObject.sales_tax ?? 0)
        let total = Double(subTotal) + Double(subTotal) * (salesTax / 100)
        view.comissionSV.isHidden = true
        view.salesTaxSV.isHidden = false
        view.subTotalCharges.text = "$ \(String(format: "%.2f", subTotal))"
        view.salesTaxCharges.text = "\(String(format: "%.2f", salesTax) )%"
        view.totalCharges.text = "$ \(String(format: "%.2f", total))"
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150.0
    }
}
