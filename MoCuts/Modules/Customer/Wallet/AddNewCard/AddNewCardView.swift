//
//  AddNewCardView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 06/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import Stripe
import StripeUICore
import PassKit
import IQKeyboardManagerSwift
import Braintree
import BraintreeDropIn
import PayPal

class AddNewCardView: BaseView, Routeable {
    
    @IBOutlet weak var amountField : UITextField!
    @IBOutlet weak var addWalletAmountBtn : MoCutsAppButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    var selectedCard: CardResponse?
    var cardsData = [[String:Any]]()
    var isMyCards = false
    var didLoadOnce = false
    
    var braintree: BTApplePayClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddNewCardViewModel()
        setVMObserver()
        DispatchQueue.main.async {
            self.removeNoDataLabelOnTableView(tableView: self.tableView)
            (self.viewModel as! AddNewCardViewModel).getCards()
        }
        topView.isHidden = isMyCards
        bottomView.isHidden = isMyCards
    }
    
    func setVMObserver() {
        (viewModel as! AddNewCardViewModel).setCards = { [weak self] cards in
            guard let self = self else {
                return
            }
            self.cardsData.removeAll()
            for card in cards {
                var newCard = [String:Any]()
                newCard["card"] = card
                newCard["isSelected"] = false
                self.cardsData.append(newCard)
            }
            if self.tableView != nil {
                DispatchQueue.main.async {
                    self.didLoadOnce = true
                    self.tableView.reloadData()
                }
            }
        }
        
        (viewModel as! AddNewCardViewModel).setCardsFailure = { [weak self] error in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.didLoadOnce = true
                self.tableView.reloadData()
            }
            print(error)
        }
        
        (viewModel as! AddNewCardViewModel).topupRoute = { [weak self] response in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.routeBack(navigation: .pop)
            }
        }
        
        (viewModel as! AddNewCardViewModel).topupFailureRoute = { [weak self] error in
            print(error)
        }
        
        (viewModel as! AddNewCardViewModel).setAddCardRoute = { [weak self] response in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.removeNoDataLabelOnTableView(tableView: self.tableView)
                (self.viewModel as! AddNewCardViewModel).getCards()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setView()
        self.setButton()
        IQKeyboardManager.shared.enable = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: nil, title: "Add Wallet Amount", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
        
        self.amountField.autocapitalizationType = .words
        self.amountField.keyboardType = .numberPad
        self.amountField.layer.borderColor = UIColor.lightGray.cgColor
        self.amountField.layer.borderWidth = 1.0
        self.amountField.layer.cornerRadius = 4
        self.amountField.delegate = self
        self.amountField.setLeftPaddingPoints(5)
        self.amountField.setRightPaddingPoints(5)
        self.amountField.textColor = UIColor(hex: "#212021")
        tableView.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
    }
    
    func setButton() {
        self.addWalletAmountBtn.buttonColor = .orange
        self.addWalletAmountBtn.setText(text: "Add Wallet Amount")
        self.addWalletAmountBtn.setAction(actionP: { [weak self] in
            guard let self else {return}
            self.addNewCard()
        }
//                                            {[weak self] in
//            guard let self = self else {
//                return
//            }
//            if self.amountField.text == "" {
//                self.viewModel.showPopup = "Wallet topup amount field can't be empty"
//                return
//            }
//            (self.viewModel as! AddNewCardViewModel).topupAmount(amount: Int(self.amountField.text ?? "0") ?? 0, paymentMethod: self.selectedCard?.paymentMethodId ?? "", paypal: false)
//        }
        )
    }
    
    @IBAction func addNewCard() {
        let attributedString = NSAttributedString(string: "Add Wallet Amount", attributes: [
            NSAttributedString.Key.font : Theme.getAppMediumFont(withSize: 18),
            NSAttributedString.Key.foregroundColor : UIColor.black
        ])
        let alert = UIAlertController(title: "Add Wallet Amount", message: nil, preferredStyle: .actionSheet)
        let subview = alert.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertContentView.layer.cornerRadius = 15
        
        alert.view.tintColor = Theme.appOrangeColor
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
//        alert.addAction(UIAlertAction(title: "Stripe", style: .default, handler: { action in
//            
//            let config = STPPaymentConfiguration()
//            config.requiredBillingAddressFields = .none
//            
//            let stripeView = STPAddCardViewController(configuration: config, theme: .defaultTheme)
//            stripeView.delegate = self
//            let stripeNavigationController = UINavigationController(rootViewController: stripeView)
//            
//            self.present(stripeNavigationController, animated: true, completion: nil)
//        }))
        
        alert.addAction(UIAlertAction(title: "Paypal", style: .default, handler: { action in
            guard let amount = Int(self.amountField.text ?? "0") else {
                self.viewModel.showPopup = "Please enter valid amount!"
                return
            }
            let vc : AddCardWebView = AppRouter.instantiateViewController(storyboard: .wallet)
            vc.amount = amount
            vc.onCompleteTransaction = { [weak self] in
                guard let self else { return }
                self.routeBack(navigation: .pop)
            }
            self.route(to: vc, navigation: .present)
//            (self.viewModel as! AddNewCardViewModel).getBraintreeToken()
//
//            self.braintreeDropIn()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Apple Pay", style: .default, handler: { action in
//            if self.amountField.text != "" {
            guard let amount = Int(self.amountField.text ?? "0") else {
                self.viewModel.showPopup = "Please enter valid amount!"
                return
            }
            let paymentManager = ApplePayHandler(items: [PKPaymentSummaryItem(label: "Mocuts", amount: NSDecimalNumber(value: amount))])
            DispatchQueue.main.async {
                if let Vc = paymentManager.paymentViewController() {
                    Vc.delegate = self
                    self.present(Vc, animated: true, completion: nil)
                }
            }
//            (self.viewModel as! AddNewCardViewModel).getBraintreeToken()
            
//            self.braintreeApplePay()
//            }
            
            
//            let paymentItem = PKPaymentSummaryItem(label: "MoCuts", amount: NSDecimalNumber(value: 0.5))
//            let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
//            
//            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
//                let merchantIdentifier = "merchant.com.app.mocuts"
//                let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "US", currency: "USD")
//                //paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS
//                paymentRequest.paymentSummaryItems = [paymentItem]
//                //paymentRequest.supportedNetworks = paymentNetworks // 5
//                
//                if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self){
//                    // Present Apple Pay payment sheet
//                    applePayContext.presentApplePay()
//                } else {
//                    self.viewModel.showPopup = "Apple Pay not configured"
//                    // There is a problem with your Apple Pay configuration
//                }
//                
//            } else {
//                self.viewModel.showPopup = "Apple Pay not configured"
//                //displayDefaultAlert(title: "Error", message: "Unable to make Apple Pay transaction.")
//            }
        }))
        
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func braintreeDropIn(){
        (self.viewModel as! AddNewCardViewModel).setBraintreeRes = { [weak self] response in
            guard let self = self else {
                return
            }
            let authorization = response
            
            DispatchQueue.main.async {
                let request = BTDropInRequest()
                let paypalRequest = BTPayPalVaultRequest()
                request.payPalRequest = paypalRequest
                request.applePayDisabled = true
        
                let dropIn = BTDropInController(authorization: authorization, request: request) { (controller, result, error) in
                    if (error != nil) {
                        print("ERROR: \(String(describing: error?.localizedDescription))")
                    } else if (result?.isCanceled == true) {
                        print("CANCELED")
                    } else if let result = result {
                        // Use the BTDropInResult properties to update your UI
                        print("PMType: \(result.paymentMethodType), PM: \(String(describing: result.paymentMethod?.type)), PMIcon: \(result.paymentIcon), PMDescription: \(result.paymentDescription)")
                        print("Nonce: \(result.paymentMethod?.nonce ?? "")")
                        
                        if result.paymentMethod?.type == "PayPal" {
                            (self.viewModel as! AddNewCardViewModel).topupAmount(amount: Int(self.amountField.text ?? "0") ?? 0, paymentMethod: result.paymentMethod?.nonce ?? "", paypal: true)
                        } else {
                            (self.viewModel as! AddNewCardViewModel).addCard(paymentMethod: result.paymentMethod?.nonce ?? "", applePay: 0)
                        }
                    }
                    controller.dismiss(animated: true, completion: nil)
                }
                self.present(dropIn!, animated: true, completion: nil)
            }
        }
    }
    
    func braintreeApplePay(){
        (self.viewModel as! AddNewCardViewModel).setBraintreeRes = { [weak self] response in
            guard let self = self else {
                return
            }
            guard let authorization = BTAPIClient(authorization: response) else {
                return
            }
            
            braintree = BTApplePayClient(apiClient: authorization)
            self.tappedApplePay()
        }
        
    }
    
    func tappedApplePay() {
        self.setupPaymentRequest { (paymentRequest, error) in
            guard error == nil, let paymentRequest = paymentRequest else {
                // Handle error
                print("Error setting up payment request: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let vc = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) as PKPaymentAuthorizationViewController? {
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)
            } else {
                print("Error: Payment request is invalid.")
            }
        }
    }
    
    func setupPaymentRequest(completion: @escaping (PKPaymentRequest?, Error?) -> Void) {
        guard let applePayClient = braintree else {
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Braintree client not initialized"]))
            return
        }
        
        applePayClient.paymentRequest { (paymentRequest, error) in
            guard let paymentRequest = paymentRequest else {
                completion(nil, error)
                return
            }
            
            // We recommend collecting billing address information, at minimum
            // billing postal code, and passing that billing postal code with all
            // Apple Pay transactions as a best practice.
//            paymentRequest.requiredBillingContactFields = [.postalAddress]
            
            // Set other PKPaymentRequest properties here
            let paymentItem = PKPaymentSummaryItem(label: "MoCuts", amount: NSDecimalNumber(value: 0.5))
            let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
            paymentRequest.merchantIdentifier = "merchant.com.app.mocuts"
            paymentRequest.merchantCapabilities = .capability3DS
            paymentRequest.paymentSummaryItems = [paymentItem]
            paymentRequest.supportedNetworks = paymentNetworks
            completion(paymentRequest, nil)
        }
    }
}

extension AddNewCardView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == amountField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        } else if Int(string) ?? -1 == -1 {
            return false
        }
        
        if textField == amountField {
            let maxLength = 4
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}

extension AddNewCardView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cardsData.count == 0 && !viewModel.isLoading && didLoadOnce {
            showNoDataLabelOnTableView(tableView: tableView, customText: "Oops! No payment cards\nadded yet!", image: "Cards")
        } else {
            removeNoDataLabelOnTableView(tableView: tableView)
        }
        return cardsData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as!
            CardCell
        let data = cardsData[indexPath.row]["card"] as! CardResponse
        if !isMyCards {
            cell.delegate = self
            cell.toggleBackground(isSelected: (cardsData[indexPath.row]["isSelected"] as? Bool ?? false))
        } else {
            cell.toggleBackground(isSelected: false)
        }

        cell.cardBrandLbl.text = data.brand ?? ""
        cell.cardExpiryLbl.text = "\(String(data.expMonth ?? 1))/\(String(data.expYear ?? 0))"
        cell.cardNumberLbl.text = "XXXX XXXX XXXX \(String(data.lastFour ?? 0))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let data = cardsData[indexPath.row]["card"] as! CardResponse
            (self.viewModel as! AddNewCardViewModel).setDelCardRoute = { [weak self] in
                guard let self = self else {
                    return
                }
                self.cardsData.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                    if self.cardsData.count == 0 {
                        self.showNoDataLabelOnTableView(tableView: self.tableView, customText: "Oops! No payment cards\nadded yet!", image: "Cards")
                    }
                }
            }
            (self.viewModel as! AddNewCardViewModel).deleteCard(cardId: String(data.id ?? 0))
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

extension AddNewCardView : CardCellDelegate {
    func bgTapped(cell: CardCell) {
        if !isMyCards {
            if let indexPath = tableView.indexPath(for: cell) {
                for i in 0..<cardsData.count {
                    if i != indexPath.row {
                        cardsData[i]["isSelected"] = false
                    }
                }
                
                cardsData[indexPath.row]["isSelected"] = !(cardsData[indexPath.row]["isSelected"] as? Bool ?? false)
                if cardsData[indexPath.row]["isSelected"] as? Bool ?? false {
                    selectedCard = cardsData[indexPath.row]["card"] as? CardResponse
                } else {
                    selectedCard = nil
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension AddNewCardView: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
//        // Tokenize the Apple Pay payment
//        braintree?.tokenizeApplePay(payment) { (nonce, error) in
//            if let error = error {
//                // Received an error from Braintree.
//                // Indicate failure via the completion callback.
//                completion(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
//                return
//            }
//            
//            print("Nonce: \(nonce?.nonce ?? "")")
//            
//            // TODO: On success, send nonce to your server for processing.
//            // If requested, address information is accessible in 'payment' and may
//            // also be sent to your server.
//            
//            // Then indicate success or failure based on the server side result of Transaction.sale
//            // via the completion callback.
//            // e.g. If the Transaction.sale was successful
//            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//            (self.viewModel as! AddNewCardViewModel).topupAmount(amount: Int(self.amountField.text ?? "0") ?? 0, paymentMethod: nonce?.nonce ?? "", paypal: true)
//        }
        (self.viewModel as! AddNewCardViewModel).topupAmount(amount: Int(self.amountField.text ?? "0") ?? 0, paymentMethod: "", paypal: true)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true)
    }
}

extension AddNewCardView : STPAddCardViewControllerDelegate {
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        (viewModel as! AddNewCardViewModel).addCard(paymentMethod: paymentMethod.stripeId, applePay: 0)
        dismiss(animated: true, completion: nil)
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        //MARK: TODO
        dismiss(animated: true, completion: nil)
    }
}

extension AddNewCardView: STPApplePayContextDelegate {
    
    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: STPPaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
        (viewModel as! AddNewCardViewModel).setAddCardRoute = { [weak self] response in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                completion(response.clientSecret, nil)
                self.removeNoDataLabelOnTableView(tableView: self.tableView)
                (self.viewModel as! AddNewCardViewModel).getCards()
            }
        }
        (viewModel as! AddNewCardViewModel).addCard(paymentMethod: paymentMethod.stripeId, applePay: 1)
    }
    
    func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPPaymentStatus, error: Error?) {
        switch status {
        case .success:
            // Payment succeeded, show a receipt view
            break
        case .error:
            // Payment failed, show the error
            break
        case .userCancellation:
            // User cancelled the payment
            break
        @unknown default:
            fatalError()
        }
    }
}

