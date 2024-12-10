//
//  BarberMyProfileViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 11/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class BarberMyProfileViewModel : BaseViewModel {
    
    private var barberHomeRepository: BarberHomeRepository = BarberHomeRepository()
    //    private var userRepository: UserRepository = UserRepository()
    
    var setBarberData : ((GenericResponse<User_Model>) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    
    func getBarberByID(barberID : Int = UserPreferences.userModel?.id ?? 0, showLoader: Bool = true) {
        
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
}
