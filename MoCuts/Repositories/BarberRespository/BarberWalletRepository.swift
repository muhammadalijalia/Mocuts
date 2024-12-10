//
//  BarberWalletRepository.swift
//  MoCuts
//
//  Created by Ahmed Khan on 28/10/2021.
//

import Foundation
import Reachability

class BarberWalletRepository: BaseRepository {
    
    private var remoteDataSource: BarberWalletRemoteDataSource!
    
    override init() {
        remoteDataSource = BarberWalletRemoteDataSource()
    }
    
    func withdrawAmount(amount: Int, successCompletion: @escaping (_ response: GenericResponse<WithdrawalResponseItem>) -> Void,
                failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.withdrawAmount(amount: amount) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func generateLink(successCompletion: @escaping (_ response: GenericResponse<ConnectLinkResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        remoteDataSource.generateLink() { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func connectPaypal(token: String, successCompletion: @escaping (_ response: BaseRequestResponse) -> Void,
                       failureCompletion: @escaping (_ error: Error) -> Void){
        remoteDataSource.connectPaypal(token: token) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
}
