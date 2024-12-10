//
//  CustomerNotificationView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 10/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class CustomerNotificationView: BaseView, Routeable {
    
    @IBOutlet weak var tableView : UITableView!
    private var notifications: [NotificationModel] = [NotificationModel]()
    private var unreadCount = 0
    private var page = 1
    private var total = 0
    var refreshControl: UIRefreshControl!
    var markReadId = -1
    var hasLoadedOnce = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel = CustomerNotificationViewModel()
        setupViewModelObserver()
        notifications.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setView()
        
        if !hasLoadedOnce {
            DispatchQueue.main.async {
                self.removeNoDataLabelOnTableView(tableView: self.tableView)
                (self.viewModel as! CustomerNotificationViewModel).getNotifications()
            }
        }
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 80.0
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(handleRefreshControl),
                                 for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        self.tableView.register(UINib(nibName: "CustomerNotificationUnreadCell", bundle: nil), forCellReuseIdentifier: "CustomerNotificationUnreadCell")
        self.tableView.register(UINib(nibName: "CustomerNotificationCell", bundle: nil), forCellReuseIdentifier: "CustomerNotificationCell")
        self.tableView.separatorStyle = .singleLine
    }
    
    @objc func handleRefreshControl() {
        notifications.removeAll()
        tableView.reloadData()
        DispatchQueue.main.async {
            self.removeNoDataLabelOnTableView(tableView: self.tableView)
            (self.viewModel as! CustomerNotificationViewModel).getNotifications()
        }
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: nil, title: "Notifications", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
    }
    
    func setupViewModelObserver() {
        if let viewModel = viewModel as? CustomerNotificationViewModel {
            viewModel.setNotificationsData = { [weak self] notificationsResponse in
                guard let self = self else {
                    return
                }
                if notificationsResponse.data?.notifications?.page == 1 {
                    self.notifications = (notificationsResponse.data?.notifications?.data ?? [NotificationModel]())
                } else {
                    self.notifications.append(contentsOf: (notificationsResponse.data?.notifications?.data ?? [NotificationModel]()))
                }
                self.total = notificationsResponse.data?.notifications?.total ?? self.notifications.count
                self.page = notificationsResponse.data?.notifications?.page ?? 1
                self.unreadCount = notificationsResponse.data?.unreadCount ?? 0
                self.hasLoadedOnce = true
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
            
            viewModel.setFailureRoute = { [weak self] error in
                guard let self = self else {
                    return
                }
                self.hasLoadedOnce = true
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
            
            viewModel.markAsReadCompletion = { [weak self] response in
                guard let self = self else {
                    return
                }
                if response.status && self.markReadId != -1 {
                    if let indexFound = self.notifications.firstIndex(where: {$0.id == self.markReadId}) {
                        self.notifications[indexFound].readAt = "\(self.markReadId)"
                        self.unreadCount -= 1
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    self.markReadId = -1
                }
            }
        }
    }
}


extension CustomerNotificationView : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if notifications.count == 0 && !viewModel.isLoading && hasLoadedOnce {
            showNoDataLabelOnTableView(tableView: tableView, customText: "No new notifications found!", image: "No.Notification")
            tableView.separatorStyle  = .singleLine
        } else {
            removeNoDataLabelOnTableView(tableView: tableView)
        }
        if section == 0 {
            return 1
        } else {
            return notifications.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == notifications.count - 1 {
            if notifications.count < total {
                DispatchQueue.main.async {
                    self.removeNoDataLabelOnTableView(tableView: self.tableView)
                    (self.viewModel as! CustomerNotificationViewModel).getNotifications(offset: (self.page + 1), showLoader: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerNotificationUnreadCell", for: indexPath) as! CustomerNotificationUnreadCell
            cell.unreadNotification.text = "\(unreadCount) Unread"
            return cell
        } else {
            let notificationData = notifications[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerNotificationCell", for: indexPath) as! CustomerNotificationCell
            if notificationData.readAt ?? "" == "" {
                
                cell.bgView.backgroundColor = UIColor(hexString: "#787878").withAlphaComponent(0.2)
                
            } else {
                cell.bgView.backgroundColor = .white
            }
            if notificationData.image ?? "" != "" {
                cell.profileImage.sd_setImage(with: URL(string: notificationData.image ?? ""), completed: nil)
            }
            cell.notificationTile.text = notificationData.message
//            let createdAt = Utilities.shared.stringToDate(date: notificationData.createdAt ?? "", format: Constants.dateFormat)
//            getElapsedTime(date: createdAt)
            cell.lastTime.text = notificationData.createdAtAgo
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            ProgressHUD.animationType = .circleStrokeSpin
            ProgressHUD.show(nil, interaction: false)
            if notifications[indexPath.row].readAt ?? "" == "" {
                markReadId = notifications[indexPath.row].id ?? 0
                let notificationId = "\(markReadId)"
                (viewModel as! CustomerNotificationViewModel).markRead(notificationId: notificationId)
            }
            
            let vm = BarberHomeListViewModel()
            vm.setJobRoute = { [weak self] job in
                guard let self = self else {
                    return
                }
                switch self.notifications[indexPath.row].type ?? 0 {
                case Constants.NotificationType.BARBER_ARRIVED,
                     Constants.NotificationType.BARBER_ON_THE_WAY,
                    Constants.NotificationType.BARBER_COMPLETED_JOB:
//                     Constants.NotificationType.BARBER_REVIEWED:
                    if job.status == 16 {
                        self.goToServiceDetailView(job: job)
                    } else {
                        self.goToTrackingView(job: job)
                    }
                case Constants.NotificationType.BARBER_CANCELLED_JOB,
                     Constants.NotificationType.JOB_ACCEPTED,
                     Constants.NotificationType.JOB_REJECTED:
                    self.goToServiceDetailView(job: job)
                case Constants.NotificationType.CHAT_MESSAGE:
                    if [JobStatus.ARRIVED, JobStatus.ON_THE_WAY, JobStatus.BARBER_MARKED_COMPLETED, JobStatus.BARBER_REVIEWED].contains(job.status ?? 0) {
                        self.goToChatView(job: job)
                    } else {
                        DispatchQueue.main.async {
                            ToastView.getInstance().showToast(inView: self.view, textToShow: "Chat unavailable",backgroundColor: Theme.appOrangeColor)
                        }
                    }
                case Constants.NotificationType.BARBER_REVIEWED:
                    self.goToReview(job: job.user_id ?? -1)
                default:
                    break
                }
                ProgressHUD.dismiss()
            }
            vm.setJobFailureRoute = {[weak self] in
                guard let self = self else {
                    return
                }
                ProgressHUD.dismiss()
            }
            vm.getJob(jobId: String(notifications[indexPath.row].refId ?? 0))
        }
    }
}


extension CustomerNotificationView {
    func goToServiceDetailView(job: BarberBaseModel) {
        DispatchQueue.main.async {
            let vc : ServiceDetailView = AppRouter.instantiateViewController(storyboard: .services)
            vc.hidesBottomBarWhenPushed = true
            let todayDate = Utilities.formateDate(Date(), dateFormat: "yyyy-MM-dd")
            vc.jobType = todayDate == job.date ? .today : .upcoming
            vc.serviceObject = job
            self.route(to: vc, navigation: .push)
        }
    }
    
    func goToTrackingView(job: BarberBaseModel) {
        DispatchQueue.main.async {
            let vc : CustomerOnMyWayView = AppRouter.instantiateViewController(storyboard: .Customertrack)
            vc.serviceObject = job
            vc.shouldPopToRoot = false
            self.route(to: vc, navigation: .push)
        }
    }
    
    func goToChatView(job: BarberBaseModel) {
        DispatchQueue.main.async {
            let vc : BarberChatView = AppRouter.instantiateViewController(storyboard: .Barbermore)
            vc.isCustomer = true
            vc.serviceObject = job
            self.route(to: vc, navigation: .push)
        }
    }
    
    func goToReview(job: Int){
        DispatchQueue.main.async {
            let vc : NotificationRatingsReviewView = AppRouter.instantiateViewController(storyboard: .Customernotification)
            vc.barberId = job
            self.route(to: vc, navigation: .push)
        }
    }
}
