//
//  EditProfileViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 13/08/2021.
//

import Helpers
import CommonComponents

class EditProfileViewModel : BaseViewModel {
    
    private var customerRepository = CustomerHomeRepository()
    
    var setUpdateProfileRoute : ((User_Model) -> Void)?
    var validateField : ((String) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?

    var setPendingJobsRoute: ((PendingJobs) -> Void)?
    var setJobsFailureRoute : ((String) -> Void)?
    
    func getPendingJobs() {
        
        guard self.networkAdapter.isNetworkAvailable else {
            self.setJobsFailureRoute?("No Internet Connection")
            return
        }
        self.isLoading = true
        
        customerRepository.getPendingJobs(successCompletion: {
            response in
               self.isLoading = false
               
               if response.status == true {
                   if let responseData = response.data {
                       self.setPendingJobsRoute?(responseData)
                   }
               } else {
                   self.showPopup = response.message ?? ""
               }
               
        }, failureCompletion: {
            error in
            self.isLoading = false
            self.setJobsFailureRoute?("\(error.localizedDescription)")
        })
    }
    
    func editProfile(fullName: UITextField, contactNumber: UITextField, emailID: UITextField, location: UITextField, lat: String, long: String, profileImg: UIImage? = nil) {
        
        if isNotValidated(fullName: fullName, contactNumber: contactNumber, emailID: emailID, location: location) {
            return
        }
       
        guard self.networkAdapter.isNetworkAvailable else {
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        self.isLoading = true

        customerRepository.editProfile(name: fullName.text ?? "", phone: contactNumber.text ?? "", email: emailID.text ?? "", location: location.text ?? "", lat: lat, long: long, profileImg: profileImg) { response in
            self.isLoading = false
            if response.status {
                if let profile = response.data {
                    self.setUpdateProfileRoute?(profile)
                }
            } else {
                self.showPopup = response.message ?? ""
            }
            self.isLoading = false
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
        self.isLoading = true
    }
    
    public func isNotValidated(fullName: UITextField, contactNumber: UITextField, emailID: UITextField, location: UITextField) -> Bool{

        var isErrorExist = false

        if fullName.text ?? "" == "" || contactNumber.text ?? "" == "" || emailID.text ?? "" == "" { // || location.text ?? "" == ""
            isErrorExist = true
            validateField?("Field can't be empty")
        } else if fullName.text?.count ?? 0 > 40 {
            isErrorExist = true
            validateField?("Name must not be greater than 40 characters")
        } else if emailID.text ?? "" != "" {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailTest.evaluate(with: emailID.text ?? "") {
                validateField?("Enter valid email address")
                isErrorExist = true
            }
        }
        return isErrorExist
    }
}
