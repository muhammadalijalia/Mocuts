//
//  ChangePasswordViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//

import Helpers
import CommonComponents

class ChangePasswordViewModel : BaseViewModel {
    
    private var authRepository: AuthenticationRepository = AuthenticationRepository()
    //    private var userRepository: UserRepository = UserRepository()
    
    var setChangePasswordRoute : (() -> Void)?
    var validatePassword : (() -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    var validateField : ((String) -> Void)?
    
    func changePassword(currentPassword: String, newPassword: String, confirmNewPassword: String) {
        
        if isNotValidated(currentPassword: currentPassword, newPassword: newPassword, confirmNewPassword: confirmNewPassword) {
            return
        } else if passwrodNotMatched(newPassword: newPassword, confirmNewPassword: confirmNewPassword) {
            validatePassword?()
            return
        }
        
        self.isLoading = true
        
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        authRepository.changePassword(currentPassword: currentPassword, newPassword: newPassword) { response in
            self.isLoading = false
            if response.status {
                self.showSuccessPopup = response.message ?? ""
                self.setChangePasswordRoute?()
            } else {
                self.showPopup = response.message ?? ""
            }
            
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    private func passwrodNotMatched(newPassword: String, confirmNewPassword : String) -> Bool {
        if newPassword != confirmNewPassword {
            return true
        }
        return false
    }
    
    public func isNotValidated(currentPassword: String, newPassword: String, confirmNewPassword : String) -> Bool{
        
        var isErrorExist = false
        
        if currentPassword == "" || confirmNewPassword == "" || newPassword == "" {
            isErrorExist = true
            validateField?("Field can't be empty")
        } else if currentPassword.count < 8 || confirmNewPassword.count < 8 || newPassword.count < 8 {
            isErrorExist = true
            validateField?("Password must be greater than 8 characters")
        }
        return isErrorExist
    }
}
