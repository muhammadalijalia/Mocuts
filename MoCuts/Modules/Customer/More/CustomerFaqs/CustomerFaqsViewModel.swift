//
//  CustomerFaqsViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 24/08/2021.
//

import Helpers

class CustomerFaqsViewModel : BaseViewModel {
    var authRepo = AuthenticationRepository()
    var onSuccess: (([FaqsResponseModel])->Void)?
    var onFailure: ((String)->Void)?
    
    func getFaqs() {
        guard self.networkAdapter.isNetworkAvailable else {
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        self.isLoading = true
        authRepo.getFaqs(successCompletion: { response in
            if response.status {
                if let faqsData = response.data {
                    self.onSuccess?(faqsData)
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
