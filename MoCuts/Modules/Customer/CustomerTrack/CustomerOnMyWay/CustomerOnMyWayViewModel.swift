//
//  CustomerOnMyWayViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 27/08/2021.
//

import Foundation
import Helpers

class CustomerOnMyWayViewModel: BaseViewModel {
    var homeRepository = CustomerHomeRepository()
    var setAcceptRoute: (() -> Void)?
    var setFailureRoute : ((String) -> Void)?
    
    func updateJob(serviceId: Int, params: [String:Any]) {
        guard self.networkAdapter.isNetworkAvailable else {
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        self.isLoading = true
        
        homeRepository.updateJob(serviceID: serviceId, params: params, successCompletion: { response in
            self.isLoading = false
            
            if response.status == true {
                if let jobModel = response.data {
                    self.setAcceptRoute?()
                }
            } else {
                self.showPopup = response.message ?? ""
            }
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        })
    }
}
