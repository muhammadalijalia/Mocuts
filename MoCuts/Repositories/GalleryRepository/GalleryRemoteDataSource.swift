//
//  GalleryRemoteDataSource.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 13/09/2021.
//

import Foundation

class GalleryRemoteDataSource {
    
    func getBarberGallery(userId : Int, successCompletion: @escaping (_ response: GenericArrayResponse<GalleryResponseModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void){
        
        let appendingURL = "?user_id=\(userId)"

        Router.APIRouter(endPoint: .attachments, appendingURL: appendingURL, parameters: nil, method: .get) { (response) in
            
            switch response {
            
            case .success(let success):
                
                guard let galleryModel = try? JSONDecoder().decode(GenericArrayResponse<GalleryResponseModel>.self, from: success.data) else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if galleryModel.status {
                    successCompletion(galleryModel)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: galleryModel.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
}

