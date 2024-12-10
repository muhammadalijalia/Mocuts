//
//  BarberProfileRemoteDataSource.swift
//  MoCuts
//
//  Created by Ahmed Khan on 29/10/2021.
//

import Foundation
import UIKit

struct BarberProfileRemoteDataSource {

    func postReview(rating: Double, review: String, jobId: Int, toId: Int, successCompletion: @escaping (_ response: GenericResponse<ReviewResponse>) -> Void,
                failureCompletion: @escaping (_ error: Error) -> Void) {
        
        var params = [String:Any]()
        params["rating"] = rating
        params["review"] = review
        params["job_id"] = jobId
        params["to_id"] = toId
        
        Router.APIRouter(endPoint: .reviews, parameters: params, method: .post) { response in
            switch response {
                case .success(let success):
                guard let postReviewResponse = try? JSONDecoder().decode(GenericResponse<ReviewResponse>.self, from: success.data) else {
                    print("Parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if postReviewResponse.status {
                    successCompletion(postReviewResponse)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: postReviewResponse.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
}
