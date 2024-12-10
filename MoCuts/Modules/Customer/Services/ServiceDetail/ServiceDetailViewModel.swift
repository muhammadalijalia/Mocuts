//
//  ServiceDetailViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 01/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class ServiceDetailViewModel: BaseViewModel
{
    private var customerHomeRepository = CustomerHomeRepository()
    private var authRepository: AuthenticationRepository = AuthenticationRepository()
    var setCancelRoute: (() -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var updateCompletion: (() -> Void)?
    var setReportTypes: (([ReportType]) -> Void)?
    var setReportResponse: ((ReportResponse) -> Void)?
    
    func cancelService(serviceID: Int, params: [String:Any]) {
        
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        customerHomeRepository.cancelService(serviceID: serviceID, params: params) { response in
            self.isLoading = false
            
            if response.status == true {
                if let jobModel = response.data {
                    self.setCancelRoute?()
                }
            } else {
                self.showPopup = response.message ?? ""
            }
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    func getCustomerProfile() {
        self.isLoading = true
        authRepository.getUserProfile(from: .remoteUpdateLocal) { barber in
            self.isLoading = false
            self.updateCompletion?()
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    func getReportTypes() {
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        authRepository.getReportTypes(successCompletion: { response in
            self.isLoading = false
            if response.status {
                if let reportTypes = response.data {
                    self.setReportTypes?(reportTypes)
                }
            } else {
                self.showPopup = response.message ?? ""
            }
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        })
    }
    
    func sendReport(toId: String, reportTypeId: String, message: String) {
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        authRepository.sendReport(toId: toId, reportTypeId: reportTypeId, message: message, successCompletion: { response in
            self.isLoading = false
            if response.status {
                if let reportResponse = response.data {
                    self.setReportResponse?(reportResponse)
                    self.showSuccessPopup = response.message ?? ""
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
