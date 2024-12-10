//
//  CustomerBarberServiceViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 25/08/2021.
//

import Foundation
import CommonComponents
import Helpers

class CustomerBarberServiceViewModel: BaseViewModel {
    var authRepository = AuthenticationRepository()
    var servicesRepository = CustomerBarberServicesRepository()
    var barberHomeRepository = BarberHomeRepository()
    var onServicesRetrieval: (([CustomerServiceModel]) -> Void)?
    var onServiceRequestResponse: ((BarberModel) -> Void)?
    var onServiceRequestError: ((String) -> Void)?
    var onError: ((String) -> Void)?
    var setReportTypes: (([ReportType]) -> Void)?
    var setReportResponse: ((ReportResponse) -> Void)?
    var setBarberData : ((GenericResponse<User_Model>) -> Void)?
    var setBarberFailure : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    
    func getBarberByID(barberID: Int, showLoader: Bool = true) {
        
        self.isLoading = showLoader
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        barberHomeRepository.getBarberByID(barberID: "\(barberID)") { user in
            self.isLoading = false
            self.setBarberData?(user)
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    func getServices(userId: String) {
        
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        self.isLoading = true
        
        self.servicesRepository.getServices(userId: userId, successCompletion: { response in
            self.isLoading = false
            
            if response.status {
                if let services = response.data {
                    self.onServicesRetrieval?(services)
                }
            } else {
                self.onError?(response.message ?? "")
                self.showPopup = response.message ?? ""
            }
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.onError?(error.localizedDescription)
        })
    }
    
    func requestService(barberId: String, availabilityId: String, date: String, items: [String]) {
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        self.isLoading = true
        
        self.servicesRepository.requestServices(barberId: barberId, availabilityId: availabilityId, date: date, items: items, successCompletion: { response in
            self.isLoading = false
            
            if response.status {
                if let requestResponse = response.data {
                    self.showSuccessPopup = response.message ?? ""
                    self.onServiceRequestResponse?(requestResponse)
                }
            } else {
                self.onServiceRequestError?(response.message ?? "")
            }
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.onServiceRequestError?(error.localizedDescription)
        })
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
