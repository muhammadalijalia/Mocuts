//
//  BarberSettingView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 27/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class BarberSettingView: BaseView, Routeable {
    
    @IBOutlet weak var tableView : UITableView!
    var isPushEnabled = UserPreferences.userModel?.push_notification == 1
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SettingListingCell", bundle: nil), forCellReuseIdentifier: "SettingListingCell")
        self.tableView.register(UINib(nibName: "SettingPushNotificationCell", bundle: nil), forCellReuseIdentifier: "SettingPushNotificationCell")
    }
    
    @objc func notificationButton() {
        let vc : CustomerNotificationView = AppRouter.instantiateViewController(storyboard: .Customernotification)
                self.route(to: vc, navigation: .push)
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        let rightBarImage = UIBarButtonItem(image: UIImage(named: "NotificationIcon"), style: .plain, target: self, action: #selector(notificationButton))
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: rightBarImage, title: "Settings", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
    }
}

extension BarberSettingView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingPushNotificationCell", for: indexPath) as! SettingPushNotificationCell
            cell.delegate = self
            cell.switcher.setOn(self.isPushEnabled, animated: false)
            cell.itemTitle.text = "Push Notifications"
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingListingCell", for: indexPath) as! SettingListingCell
            cell.itemTitle.text = "Change Password"
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingListingCell", for: indexPath) as! SettingListingCell
            cell.itemTitle.text = "Terms & Conditions"
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingListingCell", for: indexPath) as! SettingListingCell
            cell.itemTitle.text = "Privacy Policy"
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingListingCell", for: indexPath) as! SettingListingCell
            cell.itemTitle.text = "FAQs"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            let vc : ChangePasswordView = AppRouter.instantiateViewController(storyboard: .more)
            self.route(to: vc, navigation: .push)
        } else if indexPath.row == 2 {
            let vc : AboutUsView = AppRouter.instantiateViewController(storyboard: .more)
            vc.screenType = .tc
            self.route(to: vc, navigation: .push)
        } else if indexPath.row == 3 {
            let vc : AboutUsView = AppRouter.instantiateViewController(storyboard: .more)
            vc.screenType = .pp
            self.route(to: vc, navigation: .push)
        } else if indexPath.row == 4 {
            let vc : CustomerFaqsView = AppRouter.instantiateViewController(storyboard: .more)
            
            self.route(to: vc, navigation: .push)
        }
    }
}
extension BarberSettingView : SettingPushNotificationCellDelegate {
    func switchTapped(isOn: Bool) {
        (viewModel as! SettingViewModel).updatePushNotifications(pushNotifications: isOn ? 1 : 0)
        (viewModel as! SettingViewModel).onSuccess = { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                UserPreferences.userModel?.push_notification = isOn ? 1 : 0
                self.isPushEnabled = isOn
                self.tableView.reloadData()
            }
            
        }
    }
}
