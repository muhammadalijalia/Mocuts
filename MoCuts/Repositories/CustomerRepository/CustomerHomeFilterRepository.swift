//
//  CustomerHomeFilterRepository.swift
//  MoCuts
//
//  Created by Ahmed Khan on 05/11/2021.
//

import Foundation
import Reachability

class CustomerHomeFilterRepository: BaseRepository {
    
    private var remoteDataSource: CustomerHomeRemoteDataSource!
    
    override init() {
        remoteDataSource = CustomerHomeRemoteDataSource()
    }
    
    func getServices(successCompletion: @escaping (_ response: GenericResponse<[ServiceModel]>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        remoteDataSource.getServices()  { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
}
