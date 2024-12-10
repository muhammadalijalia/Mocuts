//
//  BarberAddNewTimeSlotViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 22/08/2021.
//

import Foundation
import Foundation
import Helpers
import CommonComponents

class BarberAddNewTimeSlotViewModel : BaseViewModel {
    
    //    private var authRepository: AuthenticationRepository = AuthenticationRepository()
    //    private var userRepository: UserRepository = UserRepository()
    
    private var barberHomeRepository: BarberHomeRepository = BarberHomeRepository()

    var setNewTimeAddRoute : ((GenericResponse<Availability_String>) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    var validateField : ((String) -> Void)?
    
    func addNewTime(selectDay: UITextField, startTime: UITextField, endTime : UITextField, day: String, start_time: String, end_time: String) {
        
        if isNotValidated(selectDay: selectDay, startTime: startTime, endTime : endTime) {
            return
        }
        
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        let params: [String:Any] = ["day":day, "start_time":start_time, "end_time":end_time]
        
        barberHomeRepository.addTimeSlot(params: params) { response in
            self.isLoading = false
            
            if response.status == true {
                if response.data != nil {
                    self.setNewTimeAddRoute?(response)
                }
            }else {
                self.showPopup = response.message ?? ""
            }
            
        } failureCompletion: { error in
            self.isLoading = false
            self.errorMessage = error.localizedDescription
        }
    }
    
    public func isNotValidated(selectDay: UITextField, startTime: UITextField, endTime : UITextField) -> Bool{
        
        var isErrorExist = false
        if  selectDay.text == "" || startTime.text == "" || endTime.text == "" {
            isErrorExist = true
            validateField?("Field can't be empty")
        }
        return isErrorExist
    }
}
