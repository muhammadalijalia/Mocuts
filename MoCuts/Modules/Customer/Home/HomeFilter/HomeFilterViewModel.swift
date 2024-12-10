//
//  HomeFilterViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 23/08/2021.
//

import Foundation
import Helpers

class HomeFilterViewModel: BaseViewModel {
    var homeFilterRepository = CustomerHomeFilterRepository()
    var onServicesRetrieval: (([ServiceModel]) -> Void)?
    var onError: ((String) -> Void)?
    
    func getServices() {
        
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        self.isLoading = true
        
        self.homeFilterRepository.getServices(successCompletion: { response in
            self.isLoading = false
            
            if response.status {
                if let services = response.data {
                    self.onServicesRetrieval?(services)
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
