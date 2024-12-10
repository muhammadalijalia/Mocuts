//
//  BarberServiceViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 11/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class BarberServiceViewModel : BaseViewModel {
    
    private var barberHomeRepository: BarberHomeRepository = BarberHomeRepository()
    
    var setBarberServiceData : ((GenericResponse<Services>) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    
    func changeServiceStatus(serviceId: Int, isEnable: Bool) {
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        barberHomeRepository.changeServiceStatus(serviceId: serviceId, isEnable: isEnable) { service in
            self.isLoading = false
            self.setBarberServiceData?(service)
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
}
