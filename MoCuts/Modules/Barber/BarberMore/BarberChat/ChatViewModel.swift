//
//  ChatViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 17/08/2021.
//

import Foundation
import Helpers

class ChatViewModel: BaseViewModel {
    
    var authRepo = AuthenticationRepository()
    
    func sendPushNotification(recipientId: String, jobId: String, message: String, title: String) {
        guard self.networkAdapter.isNetworkAvailable else {
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            
            return
        }
                
        let url = "?user_id=\(recipientId)&job_id=\(jobId)&message=\(message)&title=\(title)"
        
        authRepo.sendPushNotificationToUser(appendingUrl: url, successCompletion: { response in
            print(response.status)
            self.isLoading = false
        }, failureCompletion: { error in
            print(error.localizedDescription)
            self.isLoading = false
        })
    }
}
