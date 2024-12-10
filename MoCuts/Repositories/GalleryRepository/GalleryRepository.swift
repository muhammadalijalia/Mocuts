//
//  GalleryRepository.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 13/09/2021.
//

import Foundation
import Reachability

class GalleryRepository: BaseRepository {
    
    private var remoteDataSource: GalleryRemoteDataSource!
    
    override init() {
        super.init()
        remoteDataSource = GalleryRemoteDataSource()
    }
    
    func getBarberGalleryImages(userId : Int, successCompletion: @escaping (_ response: [GalleryResponseModel]?) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.getBarberGallery(userId: userId) { barberImages in
            successCompletion(barberImages.data)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
}
