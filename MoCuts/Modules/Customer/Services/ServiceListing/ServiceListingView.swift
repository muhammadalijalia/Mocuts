//
//  ServiceListingView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class ServiceListingView: BaseView, Routeable {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var todayTab : UIView!
    @IBOutlet weak var todayText : UILabel!
    @IBOutlet weak var upcomingTab : UIView!
    @IBOutlet weak var upcomingText : UILabel!
    @IBOutlet weak var pendingTab : UIView!
    @IBOutlet weak var pendingText : UILabel!
    var refreshControl: UIRefreshControl!
    var limit = 10
    private var page = 1
    private var total = 0
    private var jobsArray: [BarberBaseModel] = [BarberBaseModel]()
    private var userId: Int?
    
    
    var serviceState : ServicesState = .today
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = UserPreferences.userModel?.id ?? 0
        viewModel = ServiceListingViewModel()
        setJobsLists()
        setupTableView()
        setupRefreshControl()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setView()
        refreshData()
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ServiceListingCell", bundle: nil), forCellReuseIdentifier: "ServiceListingCell")
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(handleRefreshControl),
                                 for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    @objc func handleRefreshControl() {
        jobsArray.removeAll()
        tableView.reloadData()
        refreshData()
    }
    
    
    func setJobsLists() {
        (self.viewModel as! ServiceListingViewModel).setJobsRoute = { [weak self] jobModel in
            
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.page = jobModel.page ?? 1
                self.total = jobModel.total ?? 0
                let jobs = jobModel.data ?? []
                
                if jobModel.page == 1 {
                    self.jobsArray = jobs
                } else {
                    self.jobsArray.append(contentsOf: jobs)
                }
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
        (self.viewModel as! ServiceListingViewModel).setFailureRoute = { [weak self] error in
            
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    func refreshData() {
        DispatchQueue.main.async {
            self.removeNoDataLabelOnTableView(tableView: self.tableView)
            self.tableView.reloadData()
        }
        
        switch serviceState {
        case .pending:
            (self.viewModel as! ServiceListingViewModel).getJobs(userId: String(userId ?? 0), isPending: true, isToday: false, isUpcoming: false, limit: self.limit, offset: 1)
        case .today:
            (self.viewModel as! ServiceListingViewModel).getJobs(userId: String(userId ?? 0), isPending: false, isToday: true, isUpcoming: false, limit: self.limit, offset: 1)
        case .upcoming:
            (self.viewModel as! ServiceListingViewModel).getJobs(userId: String(userId ?? 0), isPending: false, isToday: false, isUpcoming: true, limit: self.limit, offset: 1)
        }
    }
    
    @objc func notificationButton() {
        let vc : CustomerNotificationView = AppRouter.instantiateViewController(storyboard: .Customernotification)
        self.route(to: vc, navigation: .push)
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        let rightBarImage = UIBarButtonItem(image: UIImage(named: "NotificationIcon"), style: .plain, target: self, action: #selector(notificationButton))
        Helper.getInstance.setNavigationBar(leftBarItem: nil, rightBarItem: rightBarImage, title: "Ongoing Services", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        todayTab.layer.cornerRadius = 5
        upcomingTab.layer.cornerRadius = 5
        pendingTab.layer.cornerRadius = 5
        
        if serviceState == .today {
            setTodayHighlighted()
        } else if serviceState == .upcoming {
            setUpcomingHighlighted()
        } else if serviceState == .pending {
            setPendingHighighted()
        }
    }
    
    func setTodayHighlighted() {
        self.navigationItem.title = "Ongoing Services"
        serviceState = .today
        todayTab.backgroundColor = UIColor(hex: "#FFF3F2")
        todayText.textColor = Theme.appOrangeColor
        
        upcomingTab.backgroundColor = .clear
        upcomingText.textColor = UIColor(hex: "#666666")
        
        pendingTab.backgroundColor = .clear
        pendingText.textColor = UIColor(hex: "#666666")
    }
    
    func setUpcomingHighlighted() {
        self.navigationItem.title = "Services"
        serviceState = .upcoming
        upcomingTab.backgroundColor = UIColor(hex: "#FFF3F2")
        upcomingText.textColor = Theme.appOrangeColor
        
        todayTab.backgroundColor = .clear
        todayText.textColor = UIColor(hex: "#666666")
        
        pendingTab.backgroundColor = .clear
        pendingText.textColor = UIColor(hex: "#666666")
    }
    
    func setPendingHighighted() {
        self.navigationItem.title = "Services"
        serviceState = .pending
        pendingTab.backgroundColor = UIColor(hex: "#FFF3F2")
        pendingText.textColor = Theme.appOrangeColor
        
        upcomingTab.backgroundColor = .clear
        upcomingText.textColor = UIColor(hex: "#666666")
        
        todayTab.backgroundColor = .clear
        todayText.textColor = UIColor(hex: "#666666")
    }
    
    func getUserServices(services: [Job_Services]) -> String{
        var serivcesName = ""
        for (i,o) in services.enumerated() {
            if i < services.count - 1 {
                serivcesName += "\(o.service?.name ?? ""), "
            }else {
                serivcesName += "\(o.service?.name ?? "")"
            }
        }
        
        return serivcesName
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
                return "Track"
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
    
    func goToOnMyWayView(serviceObj: BarberBaseModel, index: Int) {
        let vc : CustomerOnMyWayView = AppRouter.instantiateViewController(storyboard: .Customertrack)
        vc.serviceObject = serviceObj
        vc.serviceRequestCallBack = { [weak self] obj in
            print("updated")
            guard let self = self else {
                return
            }
            self.jobsArray[index] = obj
        }
        self.route(to: vc, navigation: .push)
    }
    
    func goToServiceDetailsView(serviceObj: BarberBaseModel, jobType: ServicesState, callBack: ((BarberBaseModel) -> ())?) {
        let vc : ServiceDetailView = AppRouter.instantiateViewController(storyboard: .services)
        vc.hidesBottomBarWhenPushed = true
        vc.jobType = jobType
        vc.serviceObject = serviceObj
        vc.serviceRequestCallBack = callBack
        self.route(to: vc, navigation: .push)
    }
    
    @IBAction func todayBtn(_ sender : UIButton) {
        setTodayHighlighted()
        self.jobsArray.removeAll()
        //self.tableView.reloadData()
        self.removeNoDataLabelOnTableView(tableView: self.tableView)
        (self.viewModel as! ServiceListingViewModel).getJobs(userId: String(userId ?? 0), isPending: false, isToday: true, isUpcoming: false, limit: self.limit, offset: 1)
    }
    
    @IBAction func upcomingBtn(_ sender : UIButton) {
        setUpcomingHighlighted()
        self.jobsArray.removeAll()
        //self.tableView.reloadData()
        self.removeNoDataLabelOnTableView(tableView: self.tableView)
        (self.viewModel as! ServiceListingViewModel).getJobs(userId: String(userId ?? 0), isPending: false, isToday: false, isUpcoming: true, limit: self.limit, offset: 1)
    }
    
    @IBAction func pendingBtn(_ sender : UIButton) {
        setPendingHighighted()
        self.jobsArray.removeAll()
        //self.tableView.reloadData()
        self.removeNoDataLabelOnTableView(tableView: self.tableView)
        (self.viewModel as! ServiceListingViewModel).getJobs(userId: String(userId ?? 0), isPending: true, isToday: false, isUpcoming: false, limit: self.limit, offset: 1)
    }
}


extension ServiceListingView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.jobsArray.count == 0 && !viewModel.isLoading {
            var message = ""
            switch serviceState {
            case .pending:
                message = "Oops! No pending services\nfound!"
            case .today:
                message = "Oops! No today's services\nfound!"
            case .upcoming:
                message = "Oops! No upcoming services\nfound!"
            }
            showNoDataLabelOnTableView(tableView: tableView, customText: message, image: "BarberShop")
        } else {
            removeNoDataLabelOnTableView(tableView: tableView)
        }
        return self.jobsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceListingCell", for: indexPath) as! ServiceListingCell
        cell.trackService.isHidden = false
        let jobModel = self.jobsArray[indexPath.row]
        let date = Utilities.convertDateFormater(jobModel.date ?? "", oldFormat: "yyyy-MM-dd", newFormat: "MM/dd/yyyy")
        let startTime = DateFormatterHelper.get12HrsTime(from: DateFormatterHelper.convertStringToDate(format: .onlyTimeWithSecond, stringToConvert: jobModel.availability?.start_time ?? "") ?? Date())
        let endTime = DateFormatterHelper.get12HrsTime(from: DateFormatterHelper.convertStringToDate(format: .onlyTimeWithSecond, stringToConvert: jobModel.availability?.end_time ?? "") ?? Date())
        var dateNtime = ""
        switch serviceState {
        case .pending, .upcoming:
            cell.bgView.backgroundColor = UIColor(hex: "#F2F3F9")
            dateNtime = "\(date) - \(startTime) - \(endTime)"
        case .today:
            cell.bgView.backgroundColor = UIColor(hex: "#EDF8FF")
            dateNtime = "\(startTime) - \(endTime)"
        }
        
        let img = jobModel.barber?.image_url ?? ""
        let name = jobModel.barber?.name ?? ""
        let services = self.getUserServices(services: jobModel.job_services ?? [])
        let status = jobModel.status ?? -1
        
        cell.shopImage?.sd_setImage(with: URL(string: img), placeholderImage: UIImage())
        cell.shopName.text = name
        cell.serviceName.text = "Services: \(services)"

        cell.dateTime.text = dateNtime
        cell.trackService.setTitle("  \(getStatus(with: status))  ", for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let serviceObj = self.jobsArray[indexPath.row]
        if serviceState == .today {
            if [JobStatus.ARRIVED, JobStatus.ON_THE_WAY, JobStatus.BARBER_MARKED_COMPLETED, JobStatus.BARBER_REVIEWED].contains(serviceObj.status) {
                goToOnMyWayView(serviceObj: serviceObj, index: indexPath.row)
            } else {
                goToServiceDetailsView(serviceObj: serviceObj, jobType: .today, callBack: { obj in
                    if obj.status != 11 {
                        DispatchQueue.main.async {
                            let lastCount = self.jobsArray.count
                            self.jobsArray.removeAll(where: { $0.id == obj.id })
                            let newCount = self.jobsArray.count
                            if lastCount != newCount {
                                self.total = self.total - (lastCount - newCount)
                            }
                            self.tableView.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.jobsArray[indexPath.row] = obj
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        } else if serviceState == .upcoming {
            goToServiceDetailsView(serviceObj: serviceObj, jobType: .upcoming, callBack: nil)
            
        } else if serviceState == .pending {
            goToServiceDetailsView(serviceObj: serviceObj, jobType: .pending, callBack: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == jobsArray.count - 1 {
            if jobsArray.count < total {
                DispatchQueue.main.async {
                    self.removeNoDataLabelOnTableView(tableView: self.tableView)
                }
                
                switch serviceState {
                case .pending:
                    (self.viewModel as! ServiceListingViewModel).getJobs(userId: String(userId ?? 0), isPending: true, isToday: false, isUpcoming: false, limit: self.limit, offset: page + 1)
                case .today:
                    (self.viewModel as! ServiceListingViewModel).getJobs(userId: String(userId ?? 0), isPending: false, isToday: true, isUpcoming: false, limit: self.limit, offset: page + 1)
                case .upcoming:
                    (self.viewModel as! ServiceListingViewModel).getJobs(userId: String(userId ?? 0), isPending: false, isToday: false, isUpcoming: true, limit: self.limit, offset: page + 1)
                }
            }
        }
    }
}
