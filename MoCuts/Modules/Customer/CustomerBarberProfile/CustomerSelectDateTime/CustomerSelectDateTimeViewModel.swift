//
//  CustomerSelectDateTimeViewModel.swift
//  MoCuts
//
//  Created by Ahmed Khan on 31/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class CustomerSelectDateTimeViewModel: BaseViewModel {
    var timeSlotRepository = CustomerSelectDateTimeRepository()
    var setBarberTimeSlotData : (([TimeSlot], String) -> Void)?
    var setBarberTimeSlotError: ((String) -> Void)?

    func getAllSlots(userID: Int, duration: String, date: String) {
        
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        timeSlotRepository.getTimeSlotsByID(userID: userID, date: date, duration: duration) { response in
            self.isLoading = false
            
            if response.status == true {
                if let timeSlots = response.data {
                    self.setBarberTimeSlotData?(timeSlots, date)
                }
            }else {
                self.showPopup = response.message ?? ""
                self.setBarberTimeSlotData?(response.data ?? [], date)
                self.setBarberTimeSlotError?(response.message ?? "")
            }
            
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.setBarberTimeSlotError?(error.localizedDescription)
        }
    }
}
