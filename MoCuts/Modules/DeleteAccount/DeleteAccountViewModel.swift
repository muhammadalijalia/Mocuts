//
//  DeleteAccountViewModel.swift
//  PoshOnTheGo
//
//  Created by Ahmed on 21/02/2023.
//

import Foundation
import Helpers

protocol DeleteAccountViewModelProtocol: AnyObject {
    func onSuccessReasons()
    func onSuccess()
    func onFailure(error: String)
}

class DeleteAccountViewModel: BaseViewModel {
    
    var remote = AuthenticationRemoteDataSource()
    var reasonId: Int?
    var deleteReasons: [ConstantModel] = []
    var delegate: DeleteAccountViewModelProtocol?
    
    init(delegate: DeleteAccountViewModelProtocol) {
        super.init()
        self.delegate = delegate
        getDeleteReasons()
    }
    
    func getDeleteReasons() {
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        self.isLoading = true
        
        remote.getDeleteReasons { response in
            self.isLoading = false
            guard response.status else { return }
            guard let data = response.data else { return }
            self.deleteReasons.removeAll()
            self.deleteReasons = data
            self.delegate?.onSuccessReasons()
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.delegate?.onFailure(error: error.localizedDescription)
        }
    }
    
    func deleteAccount() {
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        self.isLoading = true
        remote.deleteAccount(reason: reasonId) { response in
            self.isLoading = false
            guard response.status else { return }
            self.delegate?.onSuccess()
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.delegate?.onFailure(error: error.localizedDescription)
        }
    }
}
