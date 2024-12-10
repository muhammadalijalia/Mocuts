//
//  BarberEditProfileViewModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 23/08/2021.
//

import Foundation
import Helpers
import CommonComponents

class BarberEditProfileViewModel : BaseViewModel {
    
    private var authRepository: AuthenticationRepository = AuthenticationRepository()
    private var galleryRepository: GalleryRepository = GalleryRepository()
    
    private var barberRespository : BarberHomeRepository = BarberHomeRepository()
    
    var setUpdateProfileRoute : (() -> Void)?
    var validateField : ((String) -> Void)?
    var getBarberData : ((User_Model?) -> Void)?
    var getBarberGalleryImage : (([GalleryResponseModel]?) -> Void)?
    var takeBackToView : (() -> Void)?
    
    var setPendingJobsRoute: ((PendingJobs) -> Void)?
    var setPendingJobsFailureRoute : ((String) -> Void)?
    
    var name : String = ""
    var email : String = ""
    var contactNumber : String = ""
    var address : String = ""
    var about : String?
    var imageUrl : String = ""
    var latitude: String = ""
    var longitude: String = ""
    var id: Int = -1
    var galleryImagesOne : [GalleryResponseModel] = []
    
    func getBarberProfile() {
        self.isLoading = true
        authRepository.getUserProfile(from: .localFetchingRemote) { barber in
            self.isLoading = false
            UserPreferences.userModel = barber
            self.name = barber?.name ?? ""
            self.contactNumber = barber?.phone ?? ""
            self.email = barber?.email ?? ""
            self.address = barber?.address ?? ""
            self.latitude = barber?.latitude ?? ""
            self.longitude = barber?.longitude ?? ""
            self.id = barber?.id ?? -1
            if barber?.about == nil {
                self.about = ""
            } else {
                self.about = barber?.about
            }
            self.imageUrl = barber?.image_url ?? ""
            self.getBarberData?(barber)
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    func getBarberImages(userId : Int) {
        self.isLoading = true
        galleryRepository.getBarberGalleryImages(userId : userId) { images in
            self.isLoading = false
            self.getBarberGalleryImage?(images)
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    func getPendingJobs() {
        
        guard self.networkAdapter.isNetworkAvailable else {
            self.setPendingJobsFailureRoute?("No Internet Connection")
            return
        }
        self.isLoading = true
        
        barberRespository.getPendingJobs(successCompletion: {
            response in
               self.isLoading = false
               
               if response.status == true {
                   if let responseData = response.data {
                       self.setPendingJobsRoute?(responseData)
                   }
               } else {
                   self.showPopup = response.message ?? ""
               }
               
        }, failureCompletion: {
            error in
            self.isLoading = false
            self.setPendingJobsFailureRoute?("\(error.localizedDescription)")
        })
    }
    
    func editProfile(fullName: UITextField, contactNumber: UITextField, emailID: UITextField, location: UITextField, name:String, contact:String, email:String, address:String, lat: String, long: String, about: String, newImagesArray: [UIImage]? = nil, profileImg: UIImage? = nil) {
        
        if isNotValidated(fullName: fullName, contactNumber: contactNumber, emailID: emailID, location: location) {
            return
        }
        
        guard self.networkAdapter.isNetworkAvailable else {
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        self.isLoading = true
        var aboutt = about
        
        var temp = aboutt.replacingOccurrences(of: " ", with: "")
        if temp.isEmpty {
            aboutt = ""
        }
        
        temp = aboutt.replacingOccurrences(of: "\n", with: "")
        if temp.isEmpty {
            aboutt = ""
        }
        aboutt = aboutt.trimmingCharacters(in: [" ", "\n"])
        self.barberRespository.editBarberProfile(name: name , phone: contact, email: email, location: address, lat: lat, long: long, about: aboutt, newImagesArray: newImagesArray, profileImg: profileImg) { response in
            self.isLoading = false
            if response.status {
                if let profile = response.data {
                    UserPreferences.userModel = profile
                    self.setUpdateProfileRoute?()
                }
            } else {
                self.showPopup = response.message ?? ""
            }
        } failureCompletion: { error in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    func removeImage(id: Int)
    {
        guard self.networkAdapter.isNetworkAvailable else {
            self.isLoading = false
            Helper.getInstance.showAlert(title: "Error", message: "No Internet Connection")
            return
        }
        
        self.barberRespository.removeBarberGaleryImage(id: id) { (response) in
            self.isLoading = true
            if response.status {
                self.getBarberImages(userId: UserPreferences.userModel?.id ?? 0)
            } else {
                self.showPopup = response.message ?? ""
            }
        } failureCompletion: { (error) in
            self.isLoading = false
            self.showPopup = error.localizedDescription
        }
    }
    
    public func isNotValidated(fullName: UITextField, contactNumber: UITextField, emailID: UITextField, location: UITextField) -> Bool{
        
        var isErrorExist = false
        
        if fullName.text == "" || contactNumber.text == "" || emailID.text == "" {
            isErrorExist = true
            validateField?("Field can't be empty")
        } else if fullName.text?.count ?? 0 > 25 {
            isErrorExist = true
            validateField?("Name must not be greater than 25 characters")
        } else if emailID.text != "" {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailTest.evaluate(with: emailID.text) {
                validateField?("Enter valid email address")
                isErrorExist = true
            } else if location.text == "" {
                validateField?("Your profile won't appear in searches without your location.")
            }
        }
        return isErrorExist
    }
}
