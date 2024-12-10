//
//  ServiceListingViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//

import Foundation
import Helpers
import CommonComponents

class ServiceListingViewModel : BaseViewModel {
    
    private var homeRepository = CustomerHomeRepository()
    
    var setJobsRoute: ((BarberHomeModel) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    
    func getJobs(userId: String, isPending: Bool = false, isToday: Bool = false, isUpcoming: Bool = false, limit: Int, offset: Int) {
        
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        homeRepository.getJobs(userId: userId, isPending: isPending, isToday: isToday, serviceHistory: false, isUpcoming: isUpcoming, limit: limit, offset: offset, successCompletion: {
            response in
               self.isLoading = false
               
               if response.status == true {
                   if let jobModel = response.data {
                       self.setJobsRoute?(jobModel)
                   }
               } else {
                   self.showPopup = response.message ?? ""
               }
               
        }, failureCompletion: {
            error in
               self.isLoading = false
               self.showPopup = error.localizedDescription
        })
    }
}
