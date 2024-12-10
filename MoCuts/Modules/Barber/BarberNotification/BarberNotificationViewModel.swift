//
//  BarberNotificationViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 10/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class BarberNotificationViewModel : BaseViewModel {
    private var barberHomeRepository: BarberHomeRepository = BarberHomeRepository()
    
    var setNotificationsData : ((GenericResponse<NotificationsResponseItem>) -> Void)?
    var markAsReadCompletion : ((GenericResponse<NotificationsResponseItem>) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var takeBackToView : (() -> Void)?
    
    func getNotifications(offset: Int = 1, showLoader: Bool = true) {
        
        self.isLoading = showLoader
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        barberHomeRepository.getNotifications(offset: offset, successCompletion: { notificationsResponse in
            self.isLoading = false
            self.setNotificationsData?(notificationsResponse)
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        })
    }
    
    func markRead(notificationId:String) {
        self.isLoading = false
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        barberHomeRepository.markNotificationAsRead(notificationId: notificationId, successCompletion: { notificationsResponse in
            self.markAsReadCompletion?(notificationsResponse)
        }, failureCompletion: { error in
            
        })
    }
}
