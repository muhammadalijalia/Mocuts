//
//  BarberHomeListViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 06/08/2021.
//

import Helpers
import CommonComponents

class BarberHomeListViewModel : BaseViewModel {
    
    private var barberHomeRepository: BarberHomeRepository = BarberHomeRepository()
    
    var setJobRoute: ((BarberBaseModel) -> Void)?
    var setJobsRoute: ((BarberHomeModel) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var setJobFailureRoute: (() -> Void)?
    func getJobs(barberID: String, isRequested: Bool = false, isToday: Bool = false, isUpcoming: Bool = false, limit: Int, offset: Int) {
        
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        barberHomeRepository.getJobs(barberID: barberID, isRequested: isRequested, isToday: isToday, isUpcoming: isUpcoming, limit: limit, offset: offset) { response in
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
            print("failure\n\(error.localizedDescription)")
        }
    }
    
    func getJob(jobId: String) {
        
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        barberHomeRepository.getJob(jobId: jobId) { response in
            self.isLoading = false
            
            if response.status == true {
                if let jobModel = response.data {
                    self.setJobRoute?(jobModel)
                }
            } else {
                self.showPopup = response.message ?? ""
            }
            
        } failureCompletion: { error in
            self.setJobFailureRoute?()
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
}
