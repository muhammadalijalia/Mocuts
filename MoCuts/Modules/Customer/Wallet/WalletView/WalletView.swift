//
//  WalletView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 02/08/2021.
//

import UIKit
import Helpers
import CommonComponents

class WalletView: BaseView, Routeable {

    @IBOutlet weak var creditLimitView : UIView!
    @IBOutlet weak var profileDetailView : UIView!
    @IBOutlet weak var addCreditOrangeBtn : UIButton!
    @IBOutlet weak var addCreditBlueBtnView : UIView!
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var availableCreditLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = WalletViewModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setView()
        setProfileData()
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        let rightBarImage = UIBarButtonItem(image: UIImage(named: "NotificationIcon"), style: .plain, target: self, action: #selector(notificationButton))
        Helper.getInstance.setNavigationBar(leftBarItem: nil, rightBarItem: rightBarImage, title: "Wallet", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        creditLimitView.layer.cornerRadius = 8
        addCreditOrangeBtn.layer.cornerRadius = 5
        addCreditBlueBtnView.layer.cornerRadius = 5
        profileImageView.layer.cornerRadius = 5
        profileDetailView.backgroundColor = Theme.appNavigationBlueColor
        addCreditOrangeBtn.backgroundColor = Theme.appOrangeColor
    }
    
    func setProfileData() {
        (viewModel as! WalletViewModel).setProfileData = { [weak self] userProfile in
            guard let self = self else {
                return
            }
            UserPreferences.userModel = userProfile
            DispatchQueue.main.async {
                self.availableCreditLabel.text = String(format: "%.1f", (UserPreferences.userModel?.wallet_amount ?? 0)) + " $"
                self.profileImageView.sd_setImage(with: URL(string: UserPreferences.userModel?.image_url ?? ""), completed: nil)
                self.nameLabel.text = UserPreferences.userModel?.name
                self.addressLabel.text = UserPreferences.userModel?.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
            }
        }
        (viewModel as! WalletViewModel).getProfile()
    }
    
    @objc func notificationButton() {
        let vc : CustomerNotificationView = AppRouter.instantiateViewController(storyboard: .Customernotification)
                self.route(to: vc, navigation: .push)
    }
    
    @IBAction func addCreditOrangeBtnAction() {
        let vc : AddNewCardView = AppRouter.instantiateViewController(storyboard: .wallet)
        self.route(to: vc, navigation: .push)
    }
    
    @IBAction func addCreditBlueBtnAction() {
        let vc : AddNewCardView = AppRouter.instantiateViewController(storyboard: .wallet)
        self.route(to: vc, navigation: .push)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
