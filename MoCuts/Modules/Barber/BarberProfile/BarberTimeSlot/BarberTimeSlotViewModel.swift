//
//  BarberTimeSlotViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 11/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class BarberTimeSlotViewModel : BaseViewModel {
    
    var barberHomeRepository: BarberHomeRepository = BarberHomeRepository()
    
    var setBarberTimeSlotData : (([Availabilities]) -> Void)?
    var setBarberTimeSlotStatus : ((GenericResponse<Availability>) -> Void)?
    var setBarberTimeSlotDelete : ((GenericResponse<Availability>) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    
    
    func getAllSlots(userID: Int = UserPreferences.userModel?.id ?? 0) {
        
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        barberHomeRepository.getTimeSlotsByID(userID: userID) { response in
            self.isLoading = false
            
            if response.status == true {
                if let availibilities = response.data {
                    self.setBarberTimeSlotData?(availibilities)
                }
            }else {
                self.showPopup = response.message ?? ""
                self.setBarberTimeSlotData?(response.data ?? [])
                self.setFailureRoute?(response.message ?? "")
            }
            
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.setFailureRoute?(error.localizedDescription)
        }
    }
    
    func changeSlotStatus(slotID: Int, isEnable: Bool) {
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        barberHomeRepository.changeSlotStatus(slotID: slotID, isEnable: isEnable) { service in
            self.isLoading = false
            self.setBarberTimeSlotStatus?(service)
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.setFailureRoute?(error.localizedDescription)
        }
    }
    
    func deleteSlot(slotID: Int) {
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        barberHomeRepository.deleteTimeSlot(slotID: slotID) { slot in
            self.isLoading = false
            self.setBarberTimeSlotDelete?(slot)
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
//            self.setFailureRoute?(error.localizedDescription)
        }
    }
}
