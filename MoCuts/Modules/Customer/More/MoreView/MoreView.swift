//
//  MoreView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 27/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class MoreView: BaseView, Routeable {
    
    @IBOutlet weak var logOutBtn : MoCutsAppButton!
    @IBOutlet weak var logOutConstraint : NSLayoutConstraint!
    @IBOutlet weak var tableView : UITableView!
    
    var iPhoneXorLaterFamily : [String] = ["iPhone10,3","iPhone10,6","iPhone11,2","iPhone11,4","iPhone11,6","iPhone11,8","iPhone12,1","iPhone12,3","iPhone12,5","iPhone12,8","iPhone13,1","iPhone13,2","iPhone13,3","iPhone13,4"]
    var cellHeight : CGFloat = 0
    var xFamily : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MoreViewModel()
        logoutUserRedirection()
        tableView.bounces = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MoreItemListingCell", bundle: nil), forCellReuseIdentifier: "MoreItemListingCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setView()
        self.setButton()
        for i in iPhoneXorLaterFamily {
            if UIDevice.current.modelName == i {
                logOutConstraint.constant = 230
                break
            } else {
                logOutConstraint.constant = 100
            }
        }
        self.tableView.reloadData()
    }
    
    @objc func notificationButton() {
        let vc : CustomerNotificationView = AppRouter.instantiateViewController(storyboard: .Customernotification)
                self.route(to: vc, navigation: .push)
    }
    
    func setView(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
//        self.tabBarController?.tabBar.isTranslucent = true
        let rightBarImage = UIBarButtonItem(image: UIImage(named: "NotificationIcon"), style: .plain, target: self, action: #selector(notificationButton))
        Helper.getInstance.setNavigationBar(leftBarItem: nil, rightBarItem: rightBarImage, title: "More", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
    }
    
    func setButton() {
        self.logOutBtn.buttonColor = .orange
        self.logOutBtn.setText(text: "Log Out")
        self.logOutBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .alert)

            alertController.addAction(UIAlertAction(title: "Yes", style: .default)
               { action -> Void in
                (self.viewModel as! MoreViewModel).logout()
            })
            alertController.addAction(UIAlertAction(title: "No", style: .cancel)
               { action -> Void in
                 // Put your code here
               })
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func logoutUserRedirection() {
        
        (viewModel as! MoreViewModel).setLogoutRoute = {
            DispatchQueue.main.async {
                let signupVc : GetStartedView
                    = AppRouter.instantiateViewController(storyboard: .authentication)
                let nvc = UINavigationController(rootViewController: signupVc)
                Helper.getInstance.makeSpecificViewRoot(vc: nvc)
            }
        }
    }
}


extension MoreView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreItemListingCell", for: indexPath) as! MoreItemListingCell
        cell.iconImage?.contentMode = .scaleAspectFit
        if indexPath.row == 0 {
            cell.itemTitle.text = "My Profile"
            cell.iconImage.image = UIImage(named: "MyProfileIcon")
        } else if indexPath.row == 1 {
            cell.itemTitle.text = "About Us"
            cell.iconImage.image = UIImage(named: "AboutUs")
        } else if indexPath.row == 2 {
            cell.itemTitle.text = "Services History"
            cell.iconImage.image = UIImage(named: "serviceHistoryNew")
        } else if indexPath.row == 3 {
            cell.itemTitle.text = "My Cards"
            cell.iconImage.image = UIImage(named: "MyCards")
        } else if indexPath.row == 4 {
            cell.itemTitle.text = "Settings"
            cell.iconImage.image = UIImage(named: "Settings")
        } else if indexPath.row == 5 {
            cell.itemTitle.text = "Contact Us"
            cell.iconImage.image = UIImage(named: "ContactUs")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc : MyProfileView = AppRouter.instantiateViewController(storyboard: .more)
            self.route(to: vc, navigation: .push)
        } else if indexPath.row == 1 {
            let vc : AboutUsView = AppRouter.instantiateViewController(storyboard: .more)
            vc.screenType = .about
            self.route(to: vc, navigation: .push)
        } else if indexPath.row == 2 {
            let vc : ServiceHistoryView = AppRouter.instantiateViewController(storyboard: .more)
            self.route(to: vc, navigation: .push)
        } else if indexPath.row == 3 {
            let vc : AddNewCardView = AppRouter.instantiateViewController(storyboard: .wallet)
            vc.isMyCards = true
            self.route(to: vc, navigation: .push)
        } else if indexPath.row == 4 {
            let vc : SettingView = AppRouter.instantiateViewController(storyboard: .more)
            self.route(to: vc, navigation: .push)
        } else if indexPath.row == 5 {
            let vc : BarberContactUsView = AppRouter.instantiateViewController(storyboard: .Barbermore)
            self.route(to: vc, navigation: .push)
        }
    }
}
