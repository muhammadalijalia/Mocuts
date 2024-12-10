//
//  PaymentChoiceView.swift
//  MoCuts
//
//  Created by Muhammad Farooq on 09/08/2024.
//

import UIKit
import PayPal

class PaymentChoiceView: BaseView, Routeable {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var choiceTbl: UITableView!
    var choiceInfo = [ChoiceInfo(name: "PayPal"), ChoiceInfo(name: "Credit or Debit Card")]
    var amount: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PaymentChoiceViewModel()
        setTableView()
        (viewModel as? PaymentChoiceViewModel)?.orderCreated = ( {[weak self] order in
            guard let self else { return }
            self.checkoutWithPayPal(orderId: order.orderId, clientId: "AWW6bCkr4Bge-JE4qJASnsTCdvRwcJz5Nd350wB0_j1SENFafaKMSmK5Bh3FzVtqdsrMhWYiL854tWlP")
        })
    }
    
    func setTableView() {
        choiceTbl.register(UINib(nibName: ChoiceCell.identifier, bundle: nil), forCellReuseIdentifier: ChoiceCell.identifier)
        mainView.roundCorners(12)
    }
    

    @IBAction func actDismiss(_ sender: UIButton) {
        routeBack(navigation: .dismiss)
    }
}

extension PaymentChoiceView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choiceInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ChoiceCell.identifier, for: indexPath) as? ChoiceCell {
            cell.setData(choiceInfo: choiceInfo[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let amount else { return }
        switch indexPath.row {
        case 0:
            self.checkoutWithAmount(amount: amount)
        case 1:
            let vc : AddCardWebView = AppRouter.instantiateViewController(storyboard: .wallet)
            vc.amount = amount
            self.route(to: vc, navigation: .present)
        default:
            break
        }
    }
    
}
extension PaymentChoiceView {
    
    struct ChoiceInfo {
        var name: String?
        var icon: String?
    }
    
}

extension PaymentChoiceView: PayPalWebCheckoutDelegate {
    
    func checkoutWithAmount(amount: Int) {
        (viewModel as? PaymentChoiceViewModel)?.checkOutWithPaypal(amount: amount)
    }
    
    private func checkoutWithPayPal(orderId: String?, clientId: String) {
        if let orderId {
            let payPalWebRequest = PayPalWebCheckoutRequest(orderID: orderId, fundingSource: .paypal)
            checkoutWithPayPal(payPalWebRequest: payPalWebRequest, clientId: clientId)
            
        }
    }
    
    func checkoutWithPayPal(payPalWebRequest: PayPalWebCheckoutRequest, clientId: String) {
         let config = CoreConfig(clientID: clientId, environment: .sandbox)
         let payPalClient = PayPalWebCheckoutClient(config: config)
         payPalClient.delegate = self
         payPalClient.start(request: payPalWebRequest)
     }
     // MARK: - PayPalWebCheckoutDelegate
     func payPal(_ payPalClient: PayPalWebCheckoutClient, didFinishWithResult result: PayPalWebCheckoutResult) {
       // order was approved and is ready to be captured/authorized (see step 7)
     }
      func payPal(_ payPalClient: PayPalWebCheckoutClient, didFinishWithError error: CoreSDKError) {
        // handle the error by accessing `error.localizedDescription`
      }
      func payPalDidCancel(_ payPalClient: PayPalWebCheckoutClient) {
        // the user canceled

    }
}
extension PaymentChoiceView {
    
}
