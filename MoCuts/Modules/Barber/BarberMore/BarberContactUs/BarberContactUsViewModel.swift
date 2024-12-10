//
//  BarberContactUsViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 17/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class BarberContactUsViewModel : BaseViewModel {
    
    private var authRepository = AuthenticationRepository()
    
    var setContactUsRoute : ((ContactUsResponse) -> Void)?
    var setSettingsRoute : ((String,String) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    var validateField : ((String) -> Void)?
    
    func getSettings() {
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        self.isLoading = true
        
        authRepository.getSettings(successCompletion: { response in
            self.isLoading = false
            if response.status {
                if let data = response.data {
                    self.setSettingsRoute?(data.phone ?? "", data.email ?? "")
                }
            }
        }, failureCompletion: { error in
            self.isLoading = false
        })
    }
    
    func contactUs(fullName: UITextField, emailID: UITextField, message: UITextView) {
        
        if isNotValidated(fullName: fullName, emailID: emailID, message: message) {
            return
        }
        
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        self.isLoading = true
        
        var params = [String:Any]()
        params["name"] = fullName.text ?? ""
        params["email"] = emailID.text ?? ""
        params["message"] = message.text ?? ""
        
        authRepository.submitContactUsForm(parameters: params, successCompletion: { response in
            self.isLoading = false
            if response.status {
                if let data = response.data {
                    self.setContactUsRoute?(data)
                }
            } else {
                self.setFailureRoute?(response.message ?? "")
            }
            self.showSuccessPopup = response.message ?? ""
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.setFailureRoute?(error.localizedDescription)
        })
    }

    private func passwrodNotMatched(newPassword: UITextField, confirmNewPassword : UITextField) -> Bool {
        if newPassword.text != confirmNewPassword.text {
            return true
        }
        return false
    }
    
    public func isNotValidated(fullName: UITextField, emailID: UITextField, message : UITextView) -> Bool{
        
        var isErrorExist = false
        
        if fullName.text == "" || emailID.text == "" || message.text == "" {
            isErrorExist = true
            validateField?("Field can't be empty")
        } else if emailID.text != "" {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailTest.evaluate(with: emailID.text) {
                validateField?("Enter valid email address")
                isErrorExist = true
            }
        }
        return isErrorExist
    }
}
