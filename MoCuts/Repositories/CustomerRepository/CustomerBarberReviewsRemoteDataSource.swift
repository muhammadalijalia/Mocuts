//
//  CustomerBarberReviewsRemoteDataSource.swift
//  MoCuts
//
//  Created by Ahmed Khan on 09/11/2021.
//

import Foundation

class CustomerBarberReviewsRemoteDataSource {
    func getReviews(userId: String, offset: Int, successCompletion: @escaping (_ response: GenericResponse<BarberReviewResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        Router.APIRouter(endPoint: .reviews, appendingURL: "?to_id=\(userId)&offset=\(offset)", parameters: [:], method: .get, completion: { response in
            switch(response) {
            case .success(let success):
                guard let servicesListResponse = try? JSONDecoder().decode(GenericResponse<BarberReviewResponse>.self, from: success.data) else {
                    print("Parsing failed.")
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if servicesListResponse.status {
                    successCompletion(servicesListResponse)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: servicesListResponse.message ?? "No message returned"])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo: [NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        })
    }
}
