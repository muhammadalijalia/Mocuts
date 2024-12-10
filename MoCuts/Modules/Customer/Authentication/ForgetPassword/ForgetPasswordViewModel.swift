//
//  ForgetPasswordViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//

import Helpers
import CommonComponents

class ForgetPasswordViewModel : BaseViewModel {
    
    private var authRepository: AuthenticationRepository = AuthenticationRepository()
    //    private var userRepository: UserRepository = UserRepository()
    
    var setForgetPasswordRoute : (() -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    var validateField : ((String) -> Void)?
    
    func forgetPassword(email: String) {
        
        if isNotValidated(email: email) {
            return
        }
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        authRepository.forgotPassword(email: email) { response in
            self.isLoading = false
            if response.status == true {
                self.setForgetPasswordRoute?()
            } else {
                self.showPopup = response.message ?? ""
            }
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    public func isNotValidated(email: String) -> Bool{
        
        var isErrorExist = false
        if  email == "" {
            isErrorExist = true
            validateField?("Field can't be empty")
        } else if email != "" {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailTest.evaluate(with: email) {
                validateField?("Enter valid email address")
                isErrorExist = true
            }
        }
        return isErrorExist
    }
}
