//
//  BarberEditServiceViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 23/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class BarberEditServiceViewModel : BaseViewModel {
    
    private var barberHomeRepository: BarberHomeRepository = BarberHomeRepository()
    
    var setEditServiceRoute : ((GenericResponse<Services>) -> Void)?
    var deleteServiceRoute : ((GenericResponse<Services>) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    var validateField : ((String) -> Void)?
    
    func editService(serviceId: Int, serviceTitle: UITextField, serviceFee: UITextField, serviceTime : UITextField, servicePrice: String, serviceDuration: String) {

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
        
        barberHomeRepository.editService(serviceId: serviceId, params: params){ response in
            self.isLoading = false
            
            if response.status == true {
                if response.data != nil {
                    self.setEditServiceRoute?(response)
                }
            } else {
                self.showPopup = response.message ?? ""
            }
            
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    func deleteService(serviceId: Int) {
        
        self.isLoading = true

        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
                
        barberHomeRepository.deleteService(serviceId: serviceId){ response in
            self.isLoading = false
            
            if response.status == true {
                self.deleteServiceRoute?(response)
            } else {
                self.showPopup = response.message ?? ""
            }
            
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
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
