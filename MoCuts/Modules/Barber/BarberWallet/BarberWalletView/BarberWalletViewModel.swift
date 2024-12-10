//
//  BarberWalletViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 02/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class BarberWalletViewModel : BaseViewModel {
    
    private var authRepository: AuthenticationRepository = AuthenticationRepository()
    private var barberWalletRepository: BarberWalletRepository = BarberWalletRepository()
    
    var setWithdrawAmountRoute : ((WithdrawalResponseItem?) -> Void)?
    var getConnectLinkResponse: ((ConnectLinkResponse) -> Void)?
    var setBarberProfileData : ((User_Model?) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    var validateField : ((String) -> Void)?
    var setConnectPaypalRes : ((BaseRequestResponse?) -> Void)?
    
    func withdrawAmount(amount: String) {
        
        if isNotValidated(amount: amount) {
            return
        }
        
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        self.isLoading = true
        
        barberWalletRepository.withdrawAmount(amount: (Int(amount) ?? 0)) { response in
            self.isLoading = false
            if response.status == true {
                if let withdrawalsResponse = response.data {
                    self.setWithdrawAmountRoute?(withdrawalsResponse)
                    self.showSuccessPopup = response.message ?? "Withdrawal Successful"
                }
            } else {
                self.showPopup = response.message ?? ""
            }
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    func getConnectLink() {
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        self.isLoading = true
        
        barberWalletRepository.generateLink() { response in
            self.isLoading = false
            if response.status {
                if let connectResponse = response.data {
                    self.getConnectLinkResponse?(connectResponse)
                }
            } else {
                self.showPopup = response.message ?? ""
            }
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    func connectPaypal(token: String){
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        self.isLoading = true
        
        barberWalletRepository.connectPaypal(token: token) { response in
            self.isLoading = false
            if response.status == true {
                self.setConnectPaypalRes?(response)
                self.showSuccessPopup = response.message ?? "Paypal Connected!"
            } else {
                self.showPopup = response.message ?? ""
            }
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    func getBarberProfile() {
        self.isLoading = true
        authRepository.getUserProfile(from: .remote) { barber in
            self.isLoading = false
            self.setBarberProfileData?(barber)
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    public func isNotValidated(amount: String) -> Bool{
        
        var isErrorExist = false
        if  amount == "" {
            isErrorExist = true
            validateField?("Field can't be empty")
        } else if amount == "0" {
            isErrorExist = true
            validateField?("Enter a valid amount")
        }
        return isErrorExist
    }
    
    func withDrawAmountIsValid(withdrawlAmount: String, availableCredit: String) -> Bool {
        if Double(withdrawlAmount) == 0.0 {
            self.showPopup = "Please enter a valid amount."
            return false
        }
        
        guard let withdrawalAmount = Double(withdrawlAmount) else {
            // Display an error or disable the withdrawal functionality
            self.showPopup = "Insufficient Amount in your wallet."
            return false
        }
        
        guard let availableAmount = Double(availableCredit) else {
            // Display an error or disable the withdrawal functionality
            self.showPopup = "Insufficient Amount in your wallet."
            return false
        }
        
        // Check if the entered amount exceeds the available amount
        if withdrawalAmount > availableAmount {
            // Display an error or disable the withdrawal functionality
            print("Error: Entered amount exceeds available amount")
            self.showPopup = "Insufficient Amount in your wallet."
            return false
        } else if withdrawalAmount == 0.0 {
            self.showPopup = "Please enter a valid amount."
            return false
        } else {
            // Enable the withdrawal functionality or clear error messages
            print("Withdrawal amount is valid")
            return true
        }
    }
}
