//
//  WalletViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 02/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class WalletViewModel : BaseViewModel {
    
    private var authRepository = AuthenticationRepository()
    
    var setProfileData : ((User_Model?) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    var validateField : ((String) -> Void)?
    
    func getProfile() {
        self.isLoading = true
        authRepository.getUserProfile(from: .remote) { user in
            self.isLoading = false
            self.setProfileData?(user)
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
    
}
