//
//  SignUpViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//
import Helpers
import CommonComponents

class SignUpViewModel : BaseViewModel {
    
    private var authRepository: AuthenticationRepository = AuthenticationRepository()
    //    private var userRepository: UserRepository = UserRepository()
    
    var setSignupRoute : ((User_Model) -> Void)?
    var setSignupRouteUP : ((User_Model) -> Void)?
    var validatePassword : (() -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    var validateField : ((String) -> Void)?
    
    var role : Int = 0
    
    func signUp(fullName: String, contactNo: String, email: String, password: String, confirmPassword : String, latitude: String, longitude: String, location: String) {
        
        if isNotValidated(fullName: fullName, contactNo: contactNo, email: email, password: password, confirmPassword: confirmPassword, location: location) {
            return
        } else if passwrodNotMatched(password: password, confirmPassword: confirmPassword) {
            validatePassword?()
            return
        }
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        self.authRepository.signup(name: fullName, phone: contactNo, email: email, location: location, lat: latitude, long: longitude, password: password, role: self.role) { response in
            self.isLoading = false
            
            if response.status {
                if let userModel = response.data {
                    self.setSignupRoute?(userModel)
                }
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
    
    public func isNotValidated(fullName: String, contactNo: String, email: String, password: String, confirmPassword : String, location: String) -> Bool{
        
        var isErrorExist = false
        if fullName == "" || contactNo == "" || email == "" || password == "" || confirmPassword == "" { // || location == ""
            isErrorExist = true
            validateField?("Field can't be empty")
        } else if fullName.count > 25 {
            isErrorExist = true
            validateField?("Name must not be greater than 25 characters")
        } else if email != "" {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailTest.evaluate(with: email) {
                validateField?("Enter valid email address")
                isErrorExist = true
            }
        } else if password.count < 8 || confirmPassword.count < 8 {
            isErrorExist = true
            validateField?("Password must be greater than 8 characters")
        } else if password.count > 100 || confirmPassword.count > 100 {
            isErrorExist = true
            validateField?("Password must be lesser than 100 characters")
        }
        return isErrorExist
    }
}
