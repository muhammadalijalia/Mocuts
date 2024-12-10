//
//  BarberRateViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 16/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class BarberRateViewModel: BaseViewModel {

    private var barberProfileRepository: BarberProfileRepository = BarberProfileRepository()
    
    var setReviewResponseRoute : ((ReviewResponse?) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var validateField : ((String) -> Void)?
    
    func postReview(rating: Double, review: String, jobId: Int, toId: Int) {
        
        
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        self.isLoading = true
        barberProfileRepository.postReview(rating: rating, review: review, jobId: jobId, toId: toId) { response in
            self.isLoading = false
            if response.status == true {
                if let reviewResponse = response.data {
                    self.setReviewResponseRoute?(reviewResponse)
                }
            } else {
                self.showPopup = response.message ?? ""
            }
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    func validateReview() {
        
    }
}
