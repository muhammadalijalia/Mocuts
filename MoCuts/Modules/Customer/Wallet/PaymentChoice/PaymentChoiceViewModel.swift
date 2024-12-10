//
//  PaymentChoiceViewModel.swift
//  MoCuts
//
//  Created by Farooq Haroon on 12/08/2024.
//

import Foundation
import Helpers
import CommonComponents

class PaymentChoiceViewModel : BaseViewModel {
    
    private var authRepository: AuthenticationRepository = AuthenticationRepository()
    
    var setAddCardRoute : ((AddCardResponse) -> Void)?
    var setDelCardRoute: (() -> Void)?
    var topupRoute: ((TopupResponse) -> Void)?
    var topupFailureRoute: ((String) -> Void)?
    var validatePassword : (() -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    var validateField : ((String) -> Void)?
    var setCards: (([CardResponse]) -> Void)?
    var setCardsFailure: ((String) -> Void)?
    var addCardFailure: ((String) -> Void)?
    var setBraintreeRes: ((String) -> Void)?
    var setBraintreeFailure: ((String) -> Void)?
    var orderCreated:((OrderData)-> Void)?
    
    func addCard(paymentMethod: String, applePay: Int) {
        guard self.networkAdapter.isNetworkAvailable else {
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        authRepository.addCard(paymentMethod: paymentMethod, applePay: applePay, successCompletion: { response in
            self.isLoading = false
            if response.status {
                if let addCardResponse = response.data {
                    self.setAddCardRoute?(addCardResponse)
                }
            } else {
                self.showPopup = response.message ?? ""
                self.addCardFailure?(response.message ?? "")
            }
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.addCardFailure?(error.localizedDescription)
        })
    }
    func checkOutWithPaypal(amount: Int) {
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            self.isLoading = false
            return
        }
        authRepository.checkOutWithPaypal(amount: amount, successCompletion: { response in
            self.isLoading = false
            if response.status {
                if let addCardResponse = response.data {
                    self.orderCreated?(addCardResponse)
                }
            } else {
                self.showPopup = response.message ?? ""
                self.addCardFailure?(response.message ?? "")
            }
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.addCardFailure?(error.localizedDescription)
        })
    }
}
