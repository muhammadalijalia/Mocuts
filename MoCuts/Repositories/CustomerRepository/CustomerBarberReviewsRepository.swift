//
//  CustomerBarberReviewsRepository.swift
//  MoCuts
//
//  Created by Ahmed Khan on 09/11/2021.
//

import Foundation

class CustomerBarberReviewsRepository {
    
    var remoteDataSource = CustomerBarberReviewsRemoteDataSource()
    
    func getReviews(userId: String, offset:Int, successCompletion: @escaping (_ response: GenericResponse<BarberReviewResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.getReviews(userId: userId, offset: offset)  { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
}
