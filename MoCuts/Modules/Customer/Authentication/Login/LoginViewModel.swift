//
//  LoginViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 20/07/2021.
//

import Helpers
import CommonComponents

class LoginViewModel : BaseViewModel {
    
    private var authRepository: AuthenticationRepository = AuthenticationRepository()
    //    private var userRepository: UserRepository = UserRepository()
    //    a.cli3nt@yopmail.com
    //    ab4rber@yopmail.com
    //    zKMviuUXT@R7A4y
    var setLoginRoute : ((User_Model) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    var validateField : ((String) -> Void)?
    
    func login(email: String, password: String) {
        
        if isNotValidated(email: email, password: password) {
            return
        }
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        self.isLoading = true
        self.authRepository.login(email: email, password: password) { response in
            self.isLoading = false
            
            print("Response : \(response)")
            
            if response.status == true {
                if let userModel = response.data {
                    self.setLoginRoute?(userModel)
                }
            } else {
                self.showPopup = response.message ?? ""
            }
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
//        (UIApplication.shared.delegate as! AppDelegate).getNewFCMToken(onRetrieval: {
//
//        }, onFailure: {
//            self.isLoading = false
//        })
    }
    
    func socialLogin(name: String, email: String, role: Int, socialPlatform: String, clientId: String, token: String) {
        
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        authRepository.socialLogin(name: name, email: email, role: role, socialPlatform: socialPlatform, clientId: clientId, token: token ) { response in
            self.isLoading = false
            
            if response.status == true {
                if let userModel = response.data {
                    self.setLoginRoute?(userModel)
                }
            } else {
                self.showPopup = response.message ?? ""
            }
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    public func isNotValidated(email: String, password: String) -> Bool{
        
        var isErrorExist = false
        if  email == "" || password == "" {
            isErrorExist = true
            validateField?("Field can't be empty")
        }
        else if password.count < 8 {
            validateField?("Password must be greater than 8 characters")
            isErrorExist = true
        } else if email != "" {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailTest.evaluate(with: email) {
                validateField?("Enter valid email address")
                isErrorExist = true
            }
        }  else {
        }
        return isErrorExist
    }
}
