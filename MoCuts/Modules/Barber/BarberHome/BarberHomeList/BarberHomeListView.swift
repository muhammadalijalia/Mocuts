//
//  BarberHomeListView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 06/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import SDWebImage

class BarberHomeListView: BaseView, Routeable {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var todayTab : UIView!
    @IBOutlet weak var todayText : UILabel!
    @IBOutlet weak var upcomingTab : UIView!
    @IBOutlet weak var upcomingText : UILabel!
    @IBOutlet weak var requestTab : UIView!
    @IBOutlet weak var requestText : UILabel!
    var refreshControl: UIRefreshControl!
    var limit = 10
    private var page = 1
    private var total = 0
    private var jobsArray: [BarberBaseModel] = [BarberBaseModel]()
    private var barberId: Int?
    var hasLoadedOnce = false
    enum ServicesState {
        case request
        case today
        case upcoming
    }
    
    var serviceState : ServicesState = .request
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel = BarberHomeListViewModel()
        barberId = UserPreferences.userModel?.id ?? 0
        setupRefreshControl()
        setJobsLists()
        self.jobsArray.removeAll()
    }
    
    func setupTableView() {
        self.tableView.estimatedRowHeight = 1000
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "BarberHomeListCell", bundle: nil), forCellReuseIdentifier: "BarberHomeListCell")
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
    
    func refreshData() {
        DispatchQueue.main.async {
            self.removeNoDataLabelOnTableView(tableView: self.tableView)
            self.tableView.reloadData()
        }
        
        switch serviceState {
        case .request:
            (self.viewModel as! BarberHomeListViewModel).getJobs(barberID: "\(self.barberId ?? 0)", isRequested: true, limit: self.limit, offset: 1)
        case .today:
            (self.viewModel as! BarberHomeListViewModel).getJobs(barberID: "\(self.barberId ?? 0)", isToday: true, limit: self.limit, offset: 1)
        case .upcoming:
            (self.viewModel as! BarberHomeListViewModel).getJobs(barberID: "\(self.barberId ?? 0)", isUpcoming: true, limit: self.limit, offset: 1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setView()
        refreshData()
    }
    
    func setJobsLists() {
        (self.viewModel as! BarberHomeListViewModel).setJobsRoute = { [weak self] jobModel in
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
            self.hasLoadedOnce = true
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
            
        }
        (self.viewModel as! BarberHomeListViewModel).setFailureRoute = { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.hasLoadedOnce = true
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func notificationButton() {
        let vc : BarberNotificationView = AppRouter.instantiateViewController(storyboard: .Barbernotification)
        self.route(to: vc, navigation: .push)
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.backgroundColor = .white
        let rightBarImage = UIBarButtonItem(image: UIImage(named: "NotificationIcon"), style: .plain, target: self, action: #selector(notificationButton))
        Helper.getInstance.setNavigationBar(leftBarItem: nil, rightBarItem: rightBarImage, title: "Home", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        todayTab.layer.cornerRadius = 5
        upcomingTab.layer.cornerRadius = 5
        requestTab.layer.cornerRadius = 5
        
        if serviceState == .today {
            setTodayHighlighted()
        } else if serviceState == .upcoming {
            setUpcomingHighlighted()
        } else if serviceState == .request {
            setRequestHighighted()
        }
    }
    
    func setTodayHighlighted() {
        serviceState = .today
        todayTab.backgroundColor = UIColor(hex: "#FFF3F2")
        todayText.textColor = Theme.appOrangeColor
        
        upcomingTab.backgroundColor = .clear
        upcomingText.textColor = UIColor(hex: "#666666")
        
        requestTab.backgroundColor = .clear
        requestText.textColor = UIColor(hex: "#666666")
    }
    
    func setUpcomingHighlighted() {
        serviceState = .upcoming
        upcomingTab.backgroundColor = UIColor(hex: "#FFF3F2")
        upcomingText.textColor = Theme.appOrangeColor
        
        todayTab.backgroundColor = .clear
        todayText.textColor = UIColor(hex: "#666666")
        
        requestTab.backgroundColor = .clear
        requestText.textColor = UIColor(hex: "#666666")
    }
    
    func setRequestHighighted() {
        serviceState = .request
        requestTab.backgroundColor = UIColor(hex: "#FFF3F2")
        requestText.textColor = Theme.appOrangeColor
        
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
    
    @IBAction func todayBtn(_ sender : UIButton) {
        setTodayHighlighted()
        self.jobsArray.removeAll()
        self.hasLoadedOnce = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.removeNoDataLabelOnTableView(tableView: self.tableView)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            (self.viewModel as! BarberHomeListViewModel).getJobs(barberID: "\(self.barberId ?? 0)", isToday: true, limit: self.limit, offset: 1)
        }
    }
    
    @IBAction func upcomingBtn(_ sender : UIButton) {
        setUpcomingHighlighted()
        self.jobsArray.removeAll()
        self.hasLoadedOnce = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.removeNoDataLabelOnTableView(tableView: self.tableView)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            (self.viewModel as! BarberHomeListViewModel).getJobs(barberID: "\(self.barberId ?? 0)", isUpcoming: true, limit: self.limit, offset: 1)
        }
    }
    
    @IBAction func requestBtn(_ sender : UIButton) {
        setRequestHighighted()
        self.jobsArray.removeAll()
        self.hasLoadedOnce = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.removeNoDataLabelOnTableView(tableView: self.tableView)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            (self.viewModel as! BarberHomeListViewModel).getJobs(barberID: "\(self.barberId ?? 0)", isRequested: true, limit: self.limit, offset: 1)
        }
    }
}

extension BarberHomeListView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.jobsArray.count == 0 && !viewModel.isLoading && hasLoadedOnce {
            var message = ""
            switch serviceState {
            case .request:
                message = "Oops! No requested services\nfound!"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarberHomeListCell", for: indexPath) as! BarberHomeListCell
        cell.customerImage.layer.cornerRadius = 4
        if serviceState == .request {
            cell.bgView.backgroundColor = UIColor(hex: "#F2F3F9")
        } else if serviceState == .today || serviceState == .upcoming {
            cell.bgView.backgroundColor = UIColor(hex: "#EDF8FF")
        }
        
        let jobModel = self.jobsArray[indexPath.row]
        
        let img = jobModel.user?.image_url ?? ""
        let name = jobModel.user?.name ?? ""
        let services = self.getUserServices(services: jobModel.job_services ?? [])
        let rating = jobModel.user?.average_rating ?? 0
       
        let date = Utilities.convertDateFormater(jobModel.date ?? "", oldFormat: "yyyy-MM-dd", newFormat: "MM/dd/yyyy")
        let startTime = DateFormatterHelper.get12HrsTime(from: DateFormatterHelper.convertStringToDate(format: .onlyTimeWithSecond, stringToConvert: jobModel.availability?.start_time ?? "") ?? Date())
        let endTime = DateFormatterHelper.get12HrsTime(from: DateFormatterHelper.convertStringToDate(format: .onlyTimeWithSecond, stringToConvert: jobModel.availability?.end_time ?? "") ?? Date())
        
        let dateNtime = "\(date) - \(startTime) - \(endTime)"
        
        cell.customerImage?.sd_setImage(with: URL(string: img), placeholderImage: UIImage())
        cell.customerName.text = name
        cell.customerService.text = services
        
        cell.ratingLabel.text = String(format: rating == 0 ? "%.1f" : "%.2f", rating)
        cell.serviceDate.text = dateNtime
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == jobsArray.count - 1 {
            if jobsArray.count < total {
                DispatchQueue.main.async {
                    self.removeNoDataLabelOnTableView(tableView: self.tableView)
                }
                switch serviceState {
                case .request:
                    (self.viewModel as! BarberHomeListViewModel).getJobs(barberID: "\(self.barberId ?? 0)", isRequested: true, limit: self.limit, offset: (page + 1))
                case .today:
                    (self.viewModel as! BarberHomeListViewModel).getJobs(barberID: "\(self.barberId ?? 0)", isToday: true, limit: self.limit, offset: (page + 1))
                case .upcoming:
                    (self.viewModel as! BarberHomeListViewModel).getJobs(barberID: "\(self.barberId ?? 0)", isUpcoming: true, limit: self.limit, offset: (page + 1))
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let serviceObj = self.jobsArray[indexPath.row]
        if serviceState == .request {
            let vc : BarberServiceRequestView = AppRouter.instantiateViewController(storyboard: .Barberhome)
            vc.serviceObject = serviceObj
            vc.jobType = .request
            vc.serviceRequestCallBack = { [weak self] obj in
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    let lastCount = self.jobsArray.count
                    self.jobsArray.removeAll(where: { $0.id == obj.id })
                    let newCount = self.jobsArray.count
                    if lastCount != newCount {
                        self.total = self.total - (lastCount - newCount)
                    }
                    self.tableView.reloadData()
                }
            }
            vc.hidesBottomBarWhenPushed = true
            self.route(to: vc, navigation: .push)
        } else if serviceState == .today {
            
            if [JobStatus.ARRIVED, JobStatus.ON_THE_WAY].contains(serviceObj.status) {
                let vc : BarberOnMyWayView = AppRouter.instantiateViewController(storyboard: .Barbertrack)
                vc.serviceObject = serviceObj
                vc.serviceRequestCallBack = { [weak self] obj in
                    DispatchQueue.main.async {
                        guard let self = self else {
                            return
                        }
                        self.jobsArray[indexPath.row] = obj
                    }
                }
                self.route(to: vc, navigation: .push)
            } else {
                let vc : BarberServiceRequestView = AppRouter.instantiateViewController(storyboard: .Barberhome)
                vc.serviceObject = serviceObj
                vc.jobType = .today
                vc.hidesBottomBarWhenPushed = true
                vc.serviceRequestCallBack = { [weak self] obj in
                    
                    DispatchQueue.main.async {
                        guard let self = self else {
                            return
                        }
                        if obj.status != 11 {
                            let lastCount = self.jobsArray.count
                            self.jobsArray.removeAll(where: { $0.id == obj.id })
                            let newCount = self.jobsArray.count
                            if lastCount != newCount {
                                self.total = self.total - (lastCount - newCount)
                            }
                        } else {
                            self.jobsArray[indexPath.row] = obj
                        }
                        self.tableView.reloadData()
                    }
                }
                self.route(to: vc, navigation: .push)
            }
        } else if serviceState == .upcoming {
            let vc : BarberServiceRequestView = AppRouter.instantiateViewController(storyboard: .Barberhome)
            vc.serviceObject = serviceObj
            vc.hidesBottomBarWhenPushed = true
            vc.jobType = .upcoming
            self.route(to: vc, navigation: .push)
        }
    }
}
