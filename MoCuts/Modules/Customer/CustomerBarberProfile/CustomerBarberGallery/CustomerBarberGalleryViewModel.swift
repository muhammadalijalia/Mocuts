//
//  CustomerBarberGalleryViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 25/08/2021.
//

import Foundation

class CustomerBarberGalleryViewModel: BaseViewModel {
    
    private var galleryRepository: GalleryRepository = GalleryRepository()
    var getBarberGalleryImage : (([GalleryResponseModel]?) -> Void)?
    var failure: ((String) -> Void)?
    
    func getBarberImages(userId : Int) {
        self.isLoading = true
        galleryRepository.getBarberGalleryImages(userId : userId) { images in
            self.isLoading = false
            self.getBarberGalleryImage?(images)
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
            self.failure?(error.localizedDescription)
        }
    }
}
