//
//  ChangePasswordViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//

import Helpers
import CommonComponents

class BarberChangePasswordViewModel : BaseViewModel {
    
//    private var authRepository: AuthenticationRepository = AuthenticationRepository()
//    private var userRepository: UserRepository = UserRepository()
    
    var setChangePasswordRoute : (() -> Void)?
    var validatePassword : (() -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    
    func changePassword(currentPassword: TextBoxViewModel, newPassword: TextBoxViewModel, confirmNewPassword: TextBoxViewModel) {
        
        if isNotValidated(currentPassword: currentPassword, newPassword: newPassword, confirmNewPassword: confirmNewPassword) {
            return
        } else if passwrodNotMatched(newPassword: newPassword, confirmNewPassword: confirmNewPassword) {
            validatePassword?()
            return
        }
       
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
//        self.isLoading = true
        setChangePasswordRoute?()
    }
    
    private func passwrodNotMatched(newPassword: TextBoxViewModel, confirmNewPassword : TextBoxViewModel) -> Bool {
        if newPassword.textFieldText != confirmNewPassword.textFieldText {
            return true
        }
        return false
    }
    
    public func isNotValidated(currentPassword: TextBoxViewModel, newPassword: TextBoxViewModel, confirmNewPassword : TextBoxViewModel) -> Bool{
        
        var isErrorExist = false

        if !currentPassword.validate(){
            isErrorExist = true
        }
        if !newPassword.validate() {
            isErrorExist = true
        }
        if !confirmNewPassword.validate(){
            isErrorExist = true
        }
        return isErrorExist
    }
}
