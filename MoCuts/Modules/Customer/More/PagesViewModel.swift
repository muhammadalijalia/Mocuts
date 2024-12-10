//
//  PagesViewModel.swift
//  MoCuts
//
//  Created by Ahmed Khan on 25/11/2021.
//

import Foundation
import Helpers

class PagesViewModel: BaseViewModel {
    var authRepository = AuthenticationRepository()
    var onSuccess: ((WebContentResponseModel)->Void)?
    var onFailure: ((String)->Void)?
    
    func getPageData(endPoint: EndPoints) {
        guard self.networkAdapter.isNetworkAvailable else {
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        self.isLoading = true
        
        authRepository.getPageData(endPoint: endPoint, successCompletion: { response in
            if response.status {
                if let pageData = response.data {
                    self.onSuccess?(pageData)
                }
            } else {
                self.showPopup = response.message ?? ""
                self.isLoading = false
            }
        }, failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.onFailure?(error.localizedDescription)
        })
    }
}
