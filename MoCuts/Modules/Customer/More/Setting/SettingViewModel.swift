//
//  SettingViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 27/07/2021.
//

import Helpers

class SettingViewModel: BaseViewModel {
    var authRepo = AuthenticationRepository()
    var onSuccess: ((User_Model)->Void)?
    var onFailure: ((String)->Void)?
    
    func updatePushNotifications(pushNotifications: Int) {
        guard self.networkAdapter.isNetworkAvailable else {
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        self.isLoading = true
        
        authRepo.updatePushNotifications(pushNotifications: pushNotifications, successCompletion: { response in
            if response.status {
                if let data = response.data {
                    self.onSuccess?(data)
                }
            } else {
                self.showPopup = response.message ?? ""
            }
            self.isLoading = false
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.onFailure?(error.localizedDescription)
        })
    }
}
