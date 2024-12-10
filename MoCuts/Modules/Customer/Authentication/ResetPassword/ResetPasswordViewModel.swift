//
//  ResetPasswordViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//

import Helpers
import CommonComponents

class ResetPasswordViewModel : BaseViewModel {
    
    private var authRepository: AuthenticationRepository = AuthenticationRepository()
//    private var userRepository: UserRepository = UserRepository()
    
    var setResetPasswordRoute : (() -> Void)?
    var validatePassword : (() -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    var validateField : ((String) -> Void)?
    var email : String = ""
    var code : String = ""
    
    func resetPassword(newPassword: String, confirmNewPassword: String) {
        
        if isNotValidated(password: newPassword, confirmNewPassword: confirmNewPassword) {
            return
        } else if passwrodNotMatched(password: newPassword, confirmPassword: confirmNewPassword) {
            validatePassword?()
            return
        }
       
        self.isLoading = true
        
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        authRepository.resetPassword(email: email, code : code, password: newPassword) { response in
            self.isLoading = false
            if response.status == true {
                self.setResetPasswordRoute?()
            } else {
                self.showPopup = response.message ?? ""
            }
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    private func passwrodNotMatched(password: String, confirmPassword : String) -> Bool {
        if password != confirmPassword {
            return true
        }
        return false
    }
    
    public func isNotValidated(password: String, confirmNewPassword : String) -> Bool{
        
        var isErrorExist = false

        if password == "" || confirmNewPassword == ""  {
            isErrorExist = true
            validateField?("Field can't be empty")
        } else if password.count < 8 || confirmNewPassword.count < 8 {
            isErrorExist = true
            validateField?("Password must be greater than 8 characters")
        }
        return isErrorExist
    }
}
