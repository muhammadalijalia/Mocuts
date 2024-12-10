//
//  BarberServiceRequestView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 09/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import FirebaseFirestore

class BarberServiceRequestView: BaseView, Routeable {
    
    @IBOutlet weak var dateNTimeLabel: UILabel!
    @IBOutlet weak var customerImgView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var requestTypeLbl: UILabel!
    
    @IBOutlet weak var tableView : SelfSizedTableView!
    @IBOutlet weak var acceptServiceBtn : MoCutsAppButton!
    @IBOutlet weak var rejectServiceBtn : MoCutsAppButton!
    @IBOutlet weak var navView : UIView!
    
    var serviceRequestCallBack: ((BarberBaseModel) -> ())?
    
    enum ServicesState {
        case request
        case today
        case upcoming
    }
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    var jobType: ServicesState?
    
    var serviceObject: BarberBaseModel!
    var reportTypes = [ReportType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        tableView.maxHeight = 400
        viewModel = BarberServiceRequestViewModel()
        reportsSetup()
    }
    
    func reportsSetup() {
        setOnReportTypes()
        (viewModel as! BarberServiceRequestViewModel).getReportTypes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewsAndData()
    }
    
    func setViewsAndData() {
        setView()
        setButton()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.tableView.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func setOnReportTypes() {
        (viewModel as! BarberServiceRequestViewModel).setReportTypes = { [weak self] response in
            guard let self = self else {
                return
            }
            self.reportTypes = response
        }
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TotalServiceCell", bundle: nil), forCellReuseIdentifier: "TotalServiceCell")
        tableView.register(UINib(nibName: "ServiceNameCell", bundle: nil), forCellReuseIdentifier: "ServiceNameCell")
        tableView.register(UINib(nibName: "TotalChargesCell", bundle: nil), forCellReuseIdentifier: "TotalChargesCell")
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layer.cornerRadius = 5
    }
    func getStatus(with statusCode:Int) -> String {
        if statusCode > 25 {
            return "Completed"
        } else {
            switch statusCode {
            case 5:
                return "Requested"
            case 6:
                return "Rejected"
            case 10:
                return "Accepted"
            case 11:
                return "On the Way"
            case 15:
                return "Arrived"
            case 16:
                return "Unserved"
            case 20:
                return "Barber Cancelled"
            case 25:
                return "User Cancelled"
            default:
                return "Unknown"
            }
        }
    }
    
    func setView() {
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.addAnimatingGradient()
        }
        
        customerImgView.layer.cornerRadius = 5
        
        if jobType == .request {
            requestTypeLbl.text = "Service Request"
//            typeLbl.text = "Requested"
        } else if jobType == .today {
            requestTypeLbl.text = "Today's Services"
        } else if jobType == .upcoming {
            requestTypeLbl.text = "Service Details"
//            typeLbl.text = "Accepted"
        }
        typeLbl.text = getStatus(with: serviceObject.status ?? -1)
        let img = serviceObject.user?.image_url ?? ""
        let name = serviceObject.user?.name ?? ""
        let rating = serviceObject.user?.average_rating ?? 0
        let encodeAddress = serviceObject.user?.address ?? ""
        let address = encodeAddress.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
        
        let date = Utilities.convertDateFormater(serviceObject.date ?? "", oldFormat: "yyyy-MM-dd", newFormat: "MM/dd/yyyy")
        let startTime = DateFormatterHelper.get12HrsTime(from: DateFormatterHelper.convertStringToDate(format: .onlyTimeWithSecond, stringToConvert: serviceObject.availability?.start_time ?? "") ?? Date())
        let endTime = DateFormatterHelper.get12HrsTime(from: DateFormatterHelper.convertStringToDate(format: .onlyTimeWithSecond, stringToConvert: serviceObject.availability?.end_time ?? "") ?? Date())
        
        let dateNtime = "\(date) - \(startTime) - \(endTime)"
        
        customerImgView.sd_setImage(with: URL(string: img), placeholderImage: UIImage())
        nameLabel.text = name
        ratingLabel.text = String(format: rating == 0 ? "%.1f" : "%.2f", rating)
        addressLabel.text = address
        dateNTimeLabel.text = dateNtime
    }
    
    private func addAnimatingGradient() {
        
        navView.backgroundColor = UIColor.clear
        let gradientOne = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.5).cgColor
        let gradientTwo = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.001).cgColor
        gradientSet.append([gradientOne, gradientTwo])
        gradient.frame = navView.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.locations = [0.0, 1.0]
        gradient.drawsAsynchronously = true
        navView.layer.insertSublayer(gradient, at :0)
    }
    
    func setButton() {
        
        if serviceObject.status == JobStatus.REQUESTED {
            acceptServiceBtn.buttonColor = .green
            acceptServiceBtn.setText(text: "Accept")
            acceptServiceBtn.setAction(actionP: {[weak self] in
                guard let self = self else {
                    return
                }
                let userModel = UserPreferences.userModel
                guard userModel?.address != "" else {
                    let yesAction = UIAlertAction(title: "YES", style: .default, handler: { action in
                        let vc : BarberEditProfileView = AppRouter.instantiateViewController(storyboard: .Barberprofile)
                        self.route(to: vc, navigation: .push)
                    })
                    
                    let noAction = UIAlertAction(title: "NO", style: .destructive, handler: nil)
                    
                    Utilities.shared.showAlert(title: "Alert", message: "Location required to schedule service(s). Edit profile now?", actions: [yesAction, noAction], alertStyle: .alert, defaultActionTitle: "Alert", isDefaultActionReq: false, vc: self, dismissTime: nil)
                    return
                }
                let alertController = UIAlertController(title: nil, message: "Are you sure you want to accept the service?", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Yes", style: .default)
                                          { [weak self] action -> Void in
                    guard let self = self else {
                        return
                    }
                    (self.viewModel as! BarberServiceRequestViewModel).setAcceptRoute = { [weak self] in
                        DispatchQueue.main.async {
                            guard let self = self else {
                                return
                            }
                            self.serviceObject.status = 10
                            self.serviceRequestCallBack?(self.serviceObject)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    (self.viewModel as! BarberServiceRequestViewModel).acceptService(serviceID: self.serviceObject.id ?? 0, params: ["status":"10"])
                })
                alertController.addAction(UIAlertAction(title: "No", style: .cancel)
                                          { action -> Void in
                    // Put your code here
                })
                self.present(alertController, animated: true, completion: nil)
            })
            
            rejectServiceBtn.buttonColor = .orange
            rejectServiceBtn.setText(text: "Sorry Can't")
            rejectServiceBtn.setAction(actionP: {[weak self] in
                guard let self = self else {
                    return
                }
                let alertController = UIAlertController(title: nil, message: "Are you sure you reject the service?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Yes", style: .default)
                                          { [weak self] action -> Void in
                    guard let self = self else {
                        return
                    }
                    (self.viewModel as! BarberServiceRequestViewModel).setAcceptRoute = { [weak self] in
                        DispatchQueue.main.async {
                            guard let self = self else {
                                return
                            }
                            self.serviceObject.status = 6
                            self.serviceRequestCallBack?(self.serviceObject)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    (self.viewModel as! BarberServiceRequestViewModel).acceptService(serviceID: self.serviceObject.id ?? 0, params: ["status":"6"])
                })
                alertController.addAction(UIAlertAction(title: "No", style: .cancel)
                                          { action -> Void in
                    // Put your code here
                })
                self.present(alertController, animated: true, completion: nil)
            })
        } else {
            acceptServiceBtn.buttonColor = .orange
            acceptServiceBtn.setText(text: "Cancel")
            acceptServiceBtn.setAction(actionP: {[weak self] in
                guard let self = self else {
                    return
                }
                let alertController = UIAlertController(title: nil, message: "Are you sure you want to cancel the service?", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] action -> Void in
                    guard let self = self else {
                        return
                    }
                    (self.viewModel as! BarberServiceRequestViewModel).setAcceptRoute = { [weak self] in
                        DispatchQueue.main.async {
                            guard let self = self else {
                                return
                            }
                            self.serviceObject.status = 20
                            self.serviceRequestCallBack?(self.serviceObject)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    (self.viewModel as! BarberServiceRequestViewModel).acceptService(serviceID: self.serviceObject.id ?? 0, params: ["status":"20"])
                })
                alertController.addAction(UIAlertAction(title: "No", style: .cancel)
                                          { action -> Void in
                    // Put your code here
                })
                self.present(alertController, animated: true, completion: nil)
            })

            rejectServiceBtn.buttonColor = .blue
            rejectServiceBtn.setText(text: "On The Way")
            rejectServiceBtn.setAction(actionP: {[weak self] in
                guard let self = self else {
                    return
                }
                if self.jobType == .upcoming {
                    self.viewModel.showPopup = "Cannot track an upcoming order"
                    return
                }
                (self.viewModel as! BarberServiceRequestViewModel).setAcceptRoute = { [weak self] in
                    DispatchQueue.main.async {
                        guard let self = self else {
                            return
                        }
                        self.serviceObject.status = 11
                        self.serviceRequestCallBack?(self.serviceObject)
                        let vc : BarberOnMyWayView = AppRouter.instantiateViewController(storyboard: .Barbertrack)
                        vc.serviceObject = self.serviceObject
                        self.route(to: vc, navigation: .push)
                    }
                }
                (self.viewModel as! BarberServiceRequestViewModel).acceptService(serviceID: self.serviceObject.id ?? 0, params: ["status":"11"])
            })
        }
        
        if serviceObject.status > 11 {
            acceptServiceBtn.isHidden = true
            rejectServiceBtn.isHidden = true
        }
    }
    
    private func getTotalTimeTakenInMins() -> Int{
        let servicesArray = serviceObject.job_services ?? []
        var time: Int = 0
        for serv in servicesArray {
            time += serv.duration ?? 0
        }
        return time
    }
    
    @IBAction func backBtnTapped(_ sender : UIButton) {
        navigationController?.popViewController(animated: true)
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
        
        for reportType in reportTypes {
            alert.addAction(UIAlertAction(title: reportType.name, style: .default, handler: { [weak self] action in
                guard let self = self else {
                    return
                }
                for reportType in self.reportTypes {
                    if reportType.name == action.title {
                        (self.viewModel as! BarberServiceRequestViewModel).sendReport(toId: String(self.serviceObject.user_id ?? 0), reportTypeId: String(reportType.id ?? 0), message: "Reported")
                    }
                }
            }))
        }
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func addFireStoreStructure(order: BarberBaseModel)
    {
        let db = Firestore.firestore()

        var ref: DocumentReference? = nil
        
        //For User
        ref = db.collection("User").document(order.user?.id?.description ?? "")
        ref?.setData(["status": "Online", "user_id": order.user?.id?.description ?? ""])
        let jobRef = ref?.collection("Job").document(order.id?.description ?? "")
        jobRef?.setData(["jobId": order.id?.description ?? ""])
        let nurseRef = jobRef?.collection("Friend").document(UserPreferences.userModel?.id?.description ?? "")
        nurseRef?.setData(["friend_id": UserPreferences.userModel?.id ?? "","count": "0", "order_status": "InProgress","status": "Gone"])
        nurseRef?.collection("Chat").addDocument(data: ["message":"","sender_id": order.user?.id?.description ?? "","serverTimeStamp": FieldValue.serverTimestamp(), "timeStamp": Date().currentTimeStamp()])

        //For Barber
        ref = db.collection("User").document(UserPreferences.userModel?.id?.description ?? "")
        ref?.setData(["status": "Online", "user_id": UserPreferences.userModel?.id?.description ?? ""])
        let nurseJobRef = ref?.collection("Job").document(order.id?.description ?? "")
        nurseJobRef?.setData(["jobId": order.id?.description ?? "", "latitude": Double(UserPreferences.userModel?.latitude ?? "") ?? 0.0 ,"longitude": Double(UserPreferences.userModel?.longitude ?? "") ?? 0.0])
        let userRef = nurseJobRef?.collection("Friend").document(order.user?.id?.description ?? "")
        userRef?.setData(["friend_id": order.user?.id?.description ?? "","count": "0", "order_status": "InProgress","status": "Gone"])
        userRef?.collection("Chat").addDocument(data: ["message":"","sender_id": UserPreferences.userModel?.id?.description ?? "","serverTimeStamp": FieldValue.serverTimestamp(), "timeStamp": Date().currentTimeStamp()])
    }
}


extension BarberServiceRequestView : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let serviceCount = serviceObject.job_services?.count ?? 0
        return serviceCount
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: ServerDetailHeaderView = ServerDetailHeaderView.fromNib();
        let totalTimeTaken = getTotalTimeTakenInMins()
        let serviceCount = serviceObject.job_services?.count ?? 0
        
        view.serviceCount.text = "\(serviceCount) Services Selected"
        if totalTimeTaken <= 59{
            view.totalTime.text = "(\(totalTimeTaken) mins)"
        } else {
            view.totalTime.text = "(\(totalTimeTaken / 60) hours)"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceNameCell", for: indexPath) as! ServiceNameCell
        
        let services = serviceObject.job_services?[indexPath.row]
        
        let serviceName = services?.service?.name ?? ""
        let serviceCharges = services?.service?.price ?? 0
        
        cell.serviceName.text = serviceName
        cell.serviceCharges.text = "$ \(serviceCharges).00"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view: ServiceDetailFooterView = ServiceDetailFooterView.fromNib();
        
        let subTotal = Double(serviceObject.sub_total ?? 0)
        let commision = Double(serviceObject.commission ?? 0)
        view.salesTaxSV.isHidden = true
        view.subTotalCharges.text = "$ \(String(format: "%.2f", subTotal))"
        view.commisionCharges.text = "\(String(format: "%.2f", commision))%"
        view.totalCharges.text = "$ \(String(format: "%.2f", (subTotal - ((commision/100.0) * subTotal))))"
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150.0
    }
}
