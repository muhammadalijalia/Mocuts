//
//  HomeViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 26/07/2021.
//

import Foundation
import Helpers

class HomeViewModel: BaseViewModel {
    
    var customerHomeRepository = CustomerHomeRepository()
    
    var successClosure: ((BarberListModel) -> Void)?
    var failureClosure: ((String) -> Void)?
    
    func getBarbers(offset: Int = 1, longitude : String = "", latitude : String = "", radius: Double?, rating: Double?, services: [String]?) {
        
        guard self.networkAdapter.isNetworkAvailable else {
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            self.isLoading = false
            return
        }
        
        self.isLoading = true
        
        var parameters = [String:Any]()
        parameters["offset"] = offset
        parameters["longitude"] = longitude
        parameters["latitude"] = latitude
        
        if radius != nil {
            if radius != 0.0 {
                parameters["radius"] = radius
            }
        }
        
        if rating != nil {
            if rating != 0.0 || radius != rating {
                parameters["rating"] = rating
            }
        }
        var newServices = services
        for i in 0..<(newServices?.count ?? 0) {
            newServices![i] = newServices![i].replacingOccurrences(of: "&", with: "%26")
        }
        if newServices?.count != 0 {
            parameters["services"] = newServices
        }
        
        customerHomeRepository.getBarbers(params: parameters, successCompletion: { response in
            self.isLoading = false
            if response.status {
                if let barbers = response.data {
                    self.successClosure?(barbers)
                }
            }
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        })
    }
}
