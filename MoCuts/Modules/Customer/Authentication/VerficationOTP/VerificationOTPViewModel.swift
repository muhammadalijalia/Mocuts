//
//  VerificationOTPViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//

import Helpers
import CommonComponents

class VerificationOTPViewModel : BaseViewModel {
    
    private var authRepository: AuthenticationRepository = AuthenticationRepository()
    //    private var userRepository: UserRepository = UserRepository()
    
    var setVerificationRoute : ((String) -> Void)?
    var setSendOTPRoute : (() -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    var validation: Bool? = false
    private var fields : [UITextField] = []
    var failure: (() -> Void)?
    var email : String = ""
    
    func verifyOTP(txtbox1:String, txtbox2: String, txtbox3: String, txtbox4 : String) {
        
        guard isValidate(txtbox1: txtbox1, txtbox2: txtbox2, txtbox3: txtbox3, txtbox4: txtbox4) else {
            return
        }
        
        self.isLoading = true
        
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        let code = txtbox1 + txtbox2 + txtbox3 + txtbox4

        authRepository.verifyOTP(email: email, code: code) { response in
            self.isLoading = false
            if response.status == true {
                self.setVerificationRoute?(code)
            } else {
                self.showPopup = response.message ?? ""
            }
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.failure?()
        }
    }
    
    func forgetPassword(isForgot: Int? = nil) {

        
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        authRepository.forgotPassword(email: self.email, isForgot: isForgot) { response in
            if response.status == true {
                self.setSendOTPRoute?()
            } else {
                self.showPopup = response.message ?? ""
            }
        } failureCompletion: { error in
            self.showPopup = error.localizedDescription
        }
    }
    
    /// Function for add all textfields text in field array
    func setFields(txtbox1:UITextField,txtbox2:UITextField,txtbox3:UITextField,txtbox4:UITextField) {
        
        /// adding all field in array to handle on currentIndex
        self.fields.append(txtbox1)
        self.fields.append(txtbox2)
        self.fields.append(txtbox3)
        self.fields.append(txtbox4)
    }
    
    private func isValidate(txtbox1: String, txtbox2: String, txtbox3: String, txtbox4: String) -> Bool {
        
        if txtbox1 == "" || txtbox2 == "" || txtbox3 == ""
            || txtbox4 == "" {
            Helper.getInstance.showAlert(title: "Error", message: "OTP Code is required")
            self.validation = false
            return false
        } else {
            self.validation = true
        }
        return true
    }
}
