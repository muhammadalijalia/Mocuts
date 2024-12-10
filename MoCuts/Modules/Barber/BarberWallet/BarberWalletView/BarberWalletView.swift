//
//  BarberWalletView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 02/08/2021.
//

import UIKit
import Helpers
import CommonComponents

class BarberWalletView: BaseView, Routeable, ConnectStripeWebViewDelegate {
    
    
    @IBOutlet weak var creditLimitView : UIView!
    @IBOutlet weak var profileDetailView : UIView!
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var withdrawalAmountField : UITextField!
    @IBOutlet weak var requestWithdrawalBtn : MoCutsAppButton!
    @IBOutlet weak var addCardView: UIView!
    @IBOutlet weak var connectWithStripeBtn: MoCutsAppButton!
    @IBOutlet weak var barberNameLabel: UILabel!
    @IBOutlet weak var barberAddressLabel: UILabel!
    @IBOutlet weak var availableCreditLabel: UILabel!
    @IBOutlet weak var monthlyEarningHeadingLabel: UILabel!
    @IBOutlet weak var monthlyEarningLabel: UILabel!
    @IBOutlet weak var totalEarningLabel: UILabel!
    
    var availableCredit: Float?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BarberWalletViewModel()
        withdrawAmountRoute()
        connectStripeLinkResponse()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setView()
        setProfileData()
        paypalConnectResponse()
        setButton()
        errorTextMessage()
        setAddCardVisibility()
    }
    
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        let rightBarImage = UIBarButtonItem(image: UIImage(named: "NotificationIcon"), style: .plain, target: self, action: #selector(notificationButton))
        Helper.getInstance.setNavigationBar(leftBarItem: nil, rightBarItem: rightBarImage, title: "Wallet", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        creditLimitView.layer.cornerRadius = 8
        profileImageView.layer.cornerRadius = 5
        profileDetailView.backgroundColor = Theme.appNavigationBlueColor
        
        self.withdrawalAmountField.delegate = self
        self.withdrawalAmountField.isUserInteractionEnabled = true
        self.withdrawalAmountField.textColor = UIColor(hex: "#212021")
        self.withdrawalAmountField.autocapitalizationType = .none
        self.withdrawalAmountField.keyboardType = .numberPad
        self.withdrawalAmountField.layer.borderColor = UIColor.lightGray.cgColor
        self.withdrawalAmountField.layer.borderWidth = 1.0
        self.withdrawalAmountField.layer.cornerRadius = 4
        self.withdrawalAmountField.setLeftPaddingPoints(5)
        self.withdrawalAmountField.setRightPaddingPoints(5)
    }
    
    func setProfileData() {
        setAddCardVisibility()
        profileImageView.sd_setImage(with: URL(string: UserPreferences.userModel?.image_url ?? ""), completed: nil)
        barberNameLabel.text = UserPreferences.userModel?.name
        barberAddressLabel.text = UserPreferences.userModel?.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
        monthlyEarningHeadingLabel.text = DateManager.shared.getString(from: Date(), format: Constants.withdrawalDateFormat) + " Withdrawal"
        (viewModel as! BarberWalletViewModel).setBarberProfileData = {
            [weak self] barberData in
            
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                UserPreferences.userModel = barberData
                self.setAddCardVisibility()
                
                self.availableCreditLabel.text = String(format: "%.2f", (barberData?.wallet_amount ?? 0)) + " $"
                
                self.monthlyEarningLabel.text = String(format: "%.1f", Double(barberData?.current_month_with_draw ?? 0)) + " $"
                
                self.totalEarningLabel.text = String(format: "%.1f", Double(barberData?.all_time_with_draw ?? 0)) + " $"
                self.availableCredit = Float(barberData?.wallet_amount ?? 0)
            }
        }
        (viewModel as! BarberWalletViewModel).getBarberProfile()
    }
    
    func setButton() {
        requestWithdrawalBtn.buttonColor = .orange
        requestWithdrawalBtn.setText(text: "Request Withdrawal")
        requestWithdrawalBtn.setAction(actionP: { [weak self] in
            guard let self = self else { return }
            self.withdrawalAmountField.resignFirstResponder()
            
            if (self.viewModel as! BarberWalletViewModel).withDrawAmountIsValid(withdrawlAmount: withdrawalAmountField.text ?? "", availableCredit: String(availableCredit ?? 0)) == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    (self.viewModel as! BarberWalletViewModel).withdrawAmount(amount: self.withdrawalAmountField.text ?? "")
                }
            }
        })
        connectWithStripeBtn.buttonColor = .blue
        connectWithStripeBtn.setText(text: "Connect With Paypal")
        connectWithStripeBtn.setAction(actionP: { [weak self] in
            guard let self = self else { return }
            (self.viewModel as! BarberWalletViewModel).getConnectLink()
        })
    }
        
    func withdrawAmountRoute() {
        (self.viewModel as! BarberWalletViewModel).setWithdrawAmountRoute = { [weak self] withdrawalResponse in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.withdrawalAmountField.text = ""
                self.availableCreditLabel.text = String(format: "%.2f", Double(withdrawalResponse?.walletAmount ?? 0)) + " $"
                
                self.monthlyEarningLabel.text = String(format: "%.1f", Double(withdrawalResponse?.currentMonthWithDraw ?? 0)) + " $"
                
                self.totalEarningLabel.text = String(format: "%.1f", Double(withdrawalResponse?.allTimeWithDraw ?? 0)) + " $"
                self.availableCredit = withdrawalResponse?.walletAmount 
            }
        }
    }
    
    func connectStripeLinkResponse() {
        (self.viewModel as! BarberWalletViewModel).getConnectLinkResponse = { [weak self] response in
            guard let self = self else {
                return
            }
            if let url = response.url {
                self.goToConnectStripePage(url)
            }
        }
    }
    
    func goToConnectStripePage(_ url: String) {
        let vc: ConnectStripeWebView = AppRouter.instantiateViewController(storyboard: .Barberwallet)
        vc.stripeOnboardingUrl = url
        vc.delegate = self
        vc.successCallback = { [weak self] in
            guard let self = self else {
                return
            }
            self.setProfileData()
        }
        self.route(to: vc, navigation: .push)
    }
    
    func setAddCardVisibility() {
        if let connectId = UserPreferences.userModel?.connect_account_id, connectId != "" {
            #if DEBUG
            print(connectId)
            #endif
            DispatchQueue.main.async {
                self.addCardView.isHidden = true
            }
        } else {
            DispatchQueue.main.async {
                self.addCardView.isHidden = false
            }
        }
    }
    
    func paypalConnect(token: String) {
        print("Paypal ID Token: \(token)")
        (self.viewModel as! BarberWalletViewModel).connectPaypal(token: token)
        
    }
    
    func paypalConnectResponse(){
        DispatchQueue.main.async {
            (self.viewModel as! BarberWalletViewModel).setConnectPaypalRes = { [weak self] response in
                guard let self = self else {
                    return
                }
                
                if let message = response?.message {
                    print("Res Message: \(String(describing: message))")
                    (viewModel as! BarberWalletViewModel).getBarberProfile()
                }
            }
        }
    }
    
    func errorTextMessage() {
        (self.viewModel as! BarberWalletViewModel).validateField = { [weak self] errorText in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                ToastView.getInstance().showToast(inView: self.view, textToShow: errorText,backgroundColor: Theme.appOrangeColor)
            }
        }
    }
    
    @objc func notificationButton() {
        let vc : BarberNotificationView = AppRouter.instantiateViewController(storyboard: .Barbernotification)
        self.route(to: vc, navigation: .push)
    }
}

extension BarberWalletView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == withdrawalAmountField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.canBeConverted(to: String.Encoding.ascii){
             return false
        }
        
        if textField == withdrawalAmountField {
            //            let allowedCharacters = CharacterSet.decimalDigits
            //            let characterSet = CharacterSet(charactersIn: string)
            //            return allowedCharacters.isSuperset(of: characterSet)
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        return true
    }
}
