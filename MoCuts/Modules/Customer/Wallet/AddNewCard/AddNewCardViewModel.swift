//
//  AddNewCardViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 06/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class AddNewCardViewModel : BaseViewModel {
    
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
    
    func deleteCard(cardId: String) {
        guard self.networkAdapter.isNetworkAvailable else {
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        self.isLoading = true
        authRepository.deleteCard(cardId: cardId, successCompletion: { response in
            self.isLoading = false
            if !response.status {
                self.showPopup = response.message ?? ""
            }
            self.setDelCardRoute?()
        }, failureCompletion: { error in
            self.isLoading = false
//            self.showPopup = error.localizedDescription
            self.setDelCardRoute?()
        })
    }
    
    func getCards() {
        
        guard self.networkAdapter.isNetworkAvailable else {
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        self.isLoading = true
        
        authRepository.getCards(successCompletion: { response in
            self.isLoading = false
            if response.status {
                if let cards = response.data {
                    self.setCards?(cards)
                }
            } else {
                self.showPopup = response.message ?? ""
                self.setCardsFailure?(response.message ?? "")
            }
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.setCardsFailure?(error.localizedDescription)
        })
    }
    
    func topupAmount(amount: Int, paymentMethod: String, paypal: Bool) {
        if amount == 0 {
            self.showPopup = "Please enter valid amount!"
            return
        }
        if paymentMethod == "" {
            self.showPopup = "Select card"
            return
        }
        guard self.networkAdapter.isNetworkAvailable else {
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        self.isLoading = true
        
        authRepository.topUpAmount(amount: amount, paymentMethod: paymentMethod, paypal: paypal, successCompletion: { response in
            self.isLoading = false
            if response.status {
                if let addCardResponse = response.data {
                    self.topupRoute?(addCardResponse)
                }
            } else {
                self.showPopup = response.message ?? ""
                self.topupFailureRoute?(response.message ?? "")
            }
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.topupFailureRoute?(error.localizedDescription)
        })
    }
    
    func getBraintreeToken(){
        guard self.networkAdapter.isNetworkAvailable else {
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        self.isLoading = true
        
        authRepository.getBraintreeToken(successCompletion: { response in
            self.isLoading = false
            if response.status {
                if let data = response.data?.token {
                    self.setBraintreeRes?(data)
                }
            } else {
                self.showPopup = response.message ?? ""
                self.setBraintreeFailure?(response.message ?? "")
            }
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.setBraintreeFailure?(error.localizedDescription)
        })
    }
    
    public func isNotValidated(cardHolderField: UITextField, cardNumberField: UITextField, cvvField: UITextField, expiredDateField: UITextField) -> Bool {
        
        var isErrorExist = false
        
        if cardHolderField.text == "" || cardNumberField.text == "" || cvvField .text == "" || expiredDateField.text == "" {
            isErrorExist = true
            validateField?("Field can't be empty")
        }
        return isErrorExist
    }
}
