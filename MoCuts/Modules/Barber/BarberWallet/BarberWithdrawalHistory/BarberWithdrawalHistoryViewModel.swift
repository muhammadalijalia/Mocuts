//
//  BarberWithdrawalHistoryViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 17/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class BarberWithdrawalHistoryViewModel : BaseViewModel {
    private var authRepository: AuthenticationRepository = AuthenticationRepository()
    private var barberHomeRepository: BarberHomeRepository = BarberHomeRepository()
    
    var setWithdrawalsData: ((WithdrawHistoryResponseItem) -> Void)?
    var setFailureRoute : ((String) -> Void)?
    var setBarberProfileData : ((User_Model?) -> Void)?
    var name : String = ""
    var email : String = ""
    var contactNumber : String = ""
    var address : String = ""
    var about : String?
    var imageUrl : String = ""
    var galleryImagesOne : [GalleryResponseModel] = []
    
    func getWithdrawals(offset: Int = 1, year: String = String(Date().year), month: String = String(Date().month)) {
        self.isLoading = true
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        barberHomeRepository.getWithdrawalsHistory(appendingURL: "&month=\(month)&year=\(year)&offset=\(String(offset))") { response in
            self.isLoading = false
            
            if response.status == true {
                if let withdrawalsResponse = response.data {
                    self.setWithdrawalsData?(withdrawalsResponse)
                }
            } else {
                self.showPopup = response.message ?? ""
            }
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    func getBarberProfile() {
        self.isLoading = true
        authRepository.getUserProfile(from: .localFetchingRemote) { barber in
            self.isLoading = false
            self.setBarberProfileData?(barber)
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
}


