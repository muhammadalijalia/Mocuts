//
//  ServiceHistoryViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 05/08/2021.
//

import Helpers
import CommonComponents

class ServiceHistoryViewModel : BaseViewModel {
    
    private var customerHomeRepository = CustomerHomeRepository()
    
    var setJobsRoute: ((BarberHomeModel) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    
    func getServiceCompletedJobs(userId: String, month: String = "", year: String = "", query: String = "", status: String = "",offset: Int, isFiltered: Int = 0) {
        
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        customerHomeRepository.getJobsForHistory(userId: userId, month: month, year: year, query: query, status: status, isFiltered: isFiltered, offset: offset) { response in
            self.isLoading = false
            
            if response.status == true {
                if let jobModel = response.data {
                    self.setJobsRoute?(jobModel)
                }
            } else {
                self.showPopup = response.message ?? ""
            }
            
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
}
