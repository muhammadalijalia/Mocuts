//
//  ApplePayHandler.swift
//  MoCuts
//
//  Created by Farooq Haroon on 26/08/2024.
//

import Foundation
import PassKit

class ApplePayHandler: NSObject {
    let currencyCode: String
    let countryCode: String
    let merchantID: String
    let paymentNetworks: [PKPaymentNetwork]
    let items: [PKPaymentSummaryItem]
    init(
        items: [PKPaymentSummaryItem],
        currencyCode: String = "USD",
        countryCode: String = "US",
        merchantID: String = "merchant.com.app.mocuts",
        paymentNetworks: [PKPaymentNetwork] = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]) {
        self.items = items
        self.currencyCode = currencyCode
        self.countryCode = countryCode
        self.merchantID = merchantID
        self.paymentNetworks = paymentNetworks
    }
    func paymentViewController() -> PKPaymentAuthorizationViewController? {
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            request.currencyCode = self.currencyCode
            request.countryCode = self.countryCode
            request.supportedNetworks = paymentNetworks
            request.merchantIdentifier = self.merchantID
            request.paymentSummaryItems = items
            request.merchantCapabilities = .capabilityCredit
            return PKPaymentAuthorizationViewController(paymentRequest: request)
        }
        return nil
    }
}
