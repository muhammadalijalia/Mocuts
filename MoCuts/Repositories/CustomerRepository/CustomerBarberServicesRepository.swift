//
//  CustomerBarberServicesRepository.swift
//  MoCuts
//
//  Created by Ahmed Khan on 10/11/2021.
//

import Foundation
class CustomerBarberServicesRepository {
    
    var remoteDataSource = CustomerBarberServicesRemoteDataSource()
    
    func getServices(userId: String, successCompletion: @escaping (_ response: GenericResponse<[CustomerServiceModel]>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.getServices(userId: userId)  { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func requestServices(barberId: String, availabilityId: String, date: String, items: [String], successCompletion: @escaping (_ response: GenericResponse<BarberModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.requestService(barberId: barberId, availabilityId: availabilityId, date: date, items: items, successCompletion: { response in
            successCompletion(response)
        }, failureCompletion: { error in
            failureCompletion(error)
        })
    }
}
