//
//  BarberAddNewServiceViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 16/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class BarberAddNewServiceViewModel : BaseViewModel {
    
    //    private var authRepository: AuthenticationRepository = AuthenticationRepository()
    //    private var userRepository: UserRepository = UserRepository()
    
    private var barberHomeRepository: BarberHomeRepository = BarberHomeRepository()

    
    var setNewServiceRoute : ((GenericResponse<Services>) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    var validateField : ((String) -> Void)?
    
    func addNewService(serviceTitle: UITextField, serviceFee: UITextField, serviceTime : UITextField, servicePrice: String, serviceDuration: String) {

        if isNotValidated(serviceTitle: serviceTitle, serviceFee: serviceFee, serviceTime : serviceTime) {
            return
        }
        
        self.isLoading = true

        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        let params: [String:Any] = ["name": serviceTitle.text ?? "", "price": Int(servicePrice)!, "duration": Int(serviceDuration)!]
        
        barberHomeRepository.addBarberService(params: params){ response in
            self.isLoading = false
            
            if response.status == true {
                if response.data != nil {
                    self.setNewServiceRoute?(response)
                }
            } else {
                self.showPopup = response.message ?? ""
                self.setFailureRoute?(response.message ?? "")
            }
            
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.setFailureRoute?(error.localizedDescription)
        }
    }
    
    public func isNotValidated(serviceTitle: UITextField, serviceFee: UITextField, serviceTime : UITextField) -> Bool{
        
        var isErrorExist = false
        if  serviceTitle.text == "" || serviceFee.text == "" || serviceTime.text == "" {
            isErrorExist = true
            validateField?("Field can't be empty")
        } 
        return isErrorExist
    }
}
