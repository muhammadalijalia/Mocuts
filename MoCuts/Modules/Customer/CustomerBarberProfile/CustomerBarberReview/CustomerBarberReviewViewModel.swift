//
//  CustomerBarberReviewViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 25/08/2021.
//

import Foundation
import Helpers

class CustomerBarberReviewViewModel : BaseViewModel {
    var remoteRepository = CustomerBarberReviewsRepository()
    var reviewsFetched: ((BarberReviewResponse) -> Void)?
    var onFailure: ((String) -> Void)?
    
    func getReviews(userId: String, offset: Int = 1) {
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        self.isLoading = true
        
        remoteRepository.getReviews(userId: userId, offset: offset, successCompletion: { response in
            self.isLoading = false
            if response.status {
                if let data = response.data {
                    self.reviewsFetched?(data)
                } else {
                    self.onFailure?(response.message ?? "")
                }
            } else {
                self.onFailure?(response.message ?? "")
                self.showPopup = response.message ?? ""
            }
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.onFailure?(error.localizedDescription)
        })
    }
}
