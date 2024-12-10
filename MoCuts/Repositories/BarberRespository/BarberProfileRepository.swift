//
//  BarberProfileRepository.swift
//  MoCuts
//
//  Created by Ahmed Khan on 29/10/2021.
//

import Foundation
import Reachability

class BarberProfileRepository: BaseRepository {
    
    private var remoteDataSource: BarberProfileRemoteDataSource!
    
    override init() {
        remoteDataSource = BarberProfileRemoteDataSource()
    }
    
    func postReview(rating: Double, review: String, jobId: Int, toId: Int, successCompletion: @escaping (_ response: GenericResponse<ReviewResponse>) -> Void,
                failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.postReview(rating: rating, review: review, jobId: jobId, toId: toId) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
}
