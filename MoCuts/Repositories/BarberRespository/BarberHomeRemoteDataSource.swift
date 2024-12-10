//
//  BarberHomeRemoteDataSource.swift
//  MoCuts
//
//  Created by Saif Ahmed  on 29/09/2021.
//

import Foundation
import UIKit

struct BarberHomeRemoteDataSource {

    func getJobs(appendingUrl: String, successCompletion: @escaping (_ response: GenericResponse<BarberHomeModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .getJobs, appendingURL: appendingUrl, parameters: [:], method: .get) { 
            response in
            
            switch response {
            case .success(let success):
                guard let jobs = try? JSONDecoder().decode(GenericResponse<BarberHomeModel>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if jobs.status {
                    successCompletion(jobs)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: jobs.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func getJob(appendingUrl: String, successCompletion: @escaping (_ response: GenericResponse<BarberBaseModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .getJobs, appendingURL: appendingUrl, parameters: [:], method: .get) {
            response in
            
            switch response {
            case .success(let success):
                guard let jobs = try? JSONDecoder().decode(GenericResponse<BarberBaseModel>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if jobs.status {
                    successCompletion(jobs)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: jobs.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func getPendingJobs(successCompletion: @escaping (_ response: GenericResponse<PendingJobs>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .checkPendingJobs, appendingURL: "", parameters: [:], method: .get) {
            response in
            
            switch response {
            case .success(let success):
                guard let jobs = try? JSONDecoder().decode(GenericResponse<PendingJobs>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if jobs.status {
                    successCompletion(jobs)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: jobs.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func changeServiceStatus(serviceID: Int, isEnable: Bool, successCompletion: @escaping (_ response: GenericResponse<Services>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .addService, appendingURL: "/\(serviceID)", parameters: ["is_active":isEnable], method: .put) {
            response in

            switch response {
            case .success(let success):
                guard let service = try? JSONDecoder().decode(GenericResponse<Services>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if service.status {
                    successCompletion(service)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: service.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func editBarberProfile(dict: [String:Any], newImagesArray: [UIImage]?,profileImg: UIImage?, successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void,
                failureCompletion: @escaping (_ error: Error) -> Void) {
        
        var images = [Media]()
        
        if let profileImg = profileImg {
            let media = Media(key: "image", fileData: profileImg.pngData() ?? Data(), type: .image, last3Char: "png")
            images.append(media)
        }
        
        if let newImagesArray = newImagesArray
        {
            for (index,img) in newImagesArray.enumerated()
            {
                let media = Media(key: "files[]", fileData: img.pngData() ?? Data(), type: .image, filename: "files", last3Char: "png")
                images.append(media)
            }
        }
        
        Router.APIRouter(endPoint: .profile, parameters: dict, medias: images, method: .post) { response in
            
            switch response {
            
            case .success(let success):
                
                guard let userModel = try? JSONDecoder().decode(GenericResponse<User_Model>.self, from: success.data) else {
                    print("Parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if userModel.status {
                    successCompletion(userModel)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: userModel.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
    
    func removeBarberGaleryPicture(dict: [String:Any], successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void,
                failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .removeGallery, parameters: dict, method: .post) { response in
            
            switch response {
            
            case .success(let success):
                
                guard let userModel = try? JSONDecoder().decode(GenericResponse<User_Model>.self, from: success.data) else {
                    print("Parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if userModel.status {
                    successCompletion(userModel)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: userModel.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
    
    
    
    func editBarberProfileWithImage(dict: [String:Any], successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void,
                failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .profile, parameters: dict, method: .post) { response in
            
            switch response {
            
            case .success(let success):
                
                guard let userModel = try? JSONDecoder().decode(GenericResponse<User_Model>.self, from: success.data) else {
                    print("Parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if userModel.status {
                    successCompletion(userModel)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: userModel.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
    
    func editService(serviceID: Int, params: [String:Any], successCompletion: @escaping (_ response: GenericResponse<Services>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .addService, appendingURL: "/\(serviceID)", parameters: params, method: .put) {
            response in

            switch response {
            case .success(let success):
                guard let service = try? JSONDecoder().decode(GenericResponse<Services>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if service.status {
                    successCompletion(service)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: service.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func deleteService(serviceID: Int, successCompletion: @escaping (_ response: GenericResponse<Services>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .addService, appendingURL: "/\(serviceID)", parameters: [:], method: .del) {
            response in

            switch response {
            case .success(let success):
                guard let service = try? JSONDecoder().decode(GenericResponse<Services>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if service.status {
                    successCompletion(service)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: service.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func addBarberService(dict: [String:Any], successCompletion: @escaping (_ response: GenericResponse<Services>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .addService, parameters: dict, method: .post) {
            response in
            
            switch response {
            case .success(let success):
                guard let jobs = try? JSONDecoder().decode(GenericResponse<Services>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if jobs.status {
                    successCompletion(jobs)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: jobs.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    
    func addTimeSlot(dict: [String:Any], successCompletion: @escaping (_ response: GenericResponse<Availability_String>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .availabilities, parameters: dict, method: .post) {
            response in
            
            switch response {
            case .success(let success):
                guard let availability = try? JSONDecoder().decode(GenericResponse<Availability_String>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if availability.status {
                    successCompletion(availability)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: availability.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func changeSlotStatus(serviceID: Int, isEnable: Bool, successCompletion: @escaping (_ response: GenericResponse<Availability>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .availabilities, appendingURL: "/\(serviceID)", parameters: ["is_active":isEnable], method: .put) {
            response in

            switch response {
            case .success(let success):
                guard let service = try? JSONDecoder().decode(GenericResponse<Availability>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if service.status {
                    successCompletion(service)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: service.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func acceptService(serviceID: Int,params: [String:Any],successCompletion: @escaping (_ response: GenericResponse<Availability>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .getJobs, appendingURL: "/\(serviceID)", parameters: params, method: .put) { response in
            
            switch response {
            case .success(let success):
                guard let availibility = try? JSONDecoder().decode(GenericResponse<Availability>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if availibility.status {
                    successCompletion(availibility)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: availibility.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func editTimeSlot(slotID: Int, params: [String:Any], successCompletion: @escaping (_ response: GenericResponse<Availability>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .addService, appendingURL: "/\(slotID)", parameters: params, method: .put) {
            response in

            switch response {
            case .success(let success):
                guard let availibility = try? JSONDecoder().decode(GenericResponse<Availability>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if availibility.status {
                    successCompletion(availibility)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: availibility.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    
    func deleteService(slotID: Int, successCompletion: @escaping (_ response: GenericResponse<Availability>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .availabilities, appendingURL: "/\(slotID)", parameters: [:], method: .del) {
            response in

            switch response {
            case .success(let success):
                guard let availability = try? JSONDecoder().decode(GenericResponse<Availability>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if availability.status {
                    successCompletion(availability)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: availability.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func getNotifications(appendingURL: String = "", successCompletion: @escaping (_ response: GenericResponse<NotificationsResponseItem>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {

        Router.APIRouter(endPoint: .notifications, appendingURL: appendingURL, parameters: [:], method: .get) {
            response in

            switch response {
            case .success(let success):
                guard let notifications = try? JSONDecoder().decode(GenericResponse<NotificationsResponseItem>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if notifications.status {
                    successCompletion(notifications)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: notifications.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func markNotificationAsRead(notificationId: String, successCompletion: @escaping (_ response: GenericResponse<NotificationsResponseItem>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {

        Router.APIRouter(endPoint: .markRead, appendingURL: "/\(notificationId)", parameters: [:], method: .post) {
            response in

            switch response {
            case .success(let success):
                guard let notifications = try? JSONDecoder().decode(GenericResponse<NotificationsResponseItem>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if notifications.status {
                    successCompletion(notifications)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: notifications.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func getWithdrawalsHistory(appendingURL: String, successCompletion: @escaping (_ response: GenericResponse<WithdrawHistoryResponseItem>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {

        Router.APIRouter(endPoint: .withdrawals, appendingURL: appendingURL, parameters: [:], method: .get) {
            response in

            switch response {
            case .success(let success):
                guard let notifications = try? JSONDecoder().decode(GenericResponse<WithdrawHistoryResponseItem>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if notifications.status {
                    successCompletion(notifications)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: notifications.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
}
