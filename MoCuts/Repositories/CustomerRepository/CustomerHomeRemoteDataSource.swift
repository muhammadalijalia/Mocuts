//
//  CustomerHomeRemoteDataSource.swift
//  MoCuts
//
//  Created by Ahmed Khan on 02/11/2021.
//

import UIKit

struct CustomerHomeRemoteDataSource {
    
    func editProfile(dict: [String:Any], profileImg: UIImage?, successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void,
                failureCompletion: @escaping (_ error: Error) -> Void) {
        
        var images = [Media]()
        
        if let profileImg = profileImg {
            let media = Media(key: "image", fileData: profileImg.pngData() ?? Data(), type: .image, last3Char: "png")
            images.append(media)
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
    
    func getBarbers(appendingUrl : String = "", successCompletion: @escaping (_ response: GenericResponse<BarberListModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .barbers, appendingURL: appendingUrl, parameters: [:], method: .get, completion: {response in
            switch(response) {
            case .success(let success):
                guard let barbersListResponse = try? JSONDecoder().decode(GenericResponse<BarberListModel>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if barbersListResponse.status {
                    successCompletion(barbersListResponse)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: barbersListResponse.message ?? "No message returned"])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo: [NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        })
    }
    
    func getServices(successCompletion: @escaping (_ response: GenericResponse<[ServiceModel]>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        Router.APIRouter(endPoint: .addService, appendingURL: "", parameters: [:], method: .get, completion: { response in
            switch(response) {
            case .success(let success):
                guard let servicesListResponse = try? JSONDecoder().decode(GenericResponse<[ServiceModel]>.self, from: success.data) else {
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
    
    func cancelService(serviceID: Int,params: [String:Any],successCompletion: @escaping (_ response: GenericResponse<Availability>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
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
    
    func updateJob(serviceID: Int,params: [String:Any],successCompletion: @escaping (_ response: GenericResponse<Availability>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
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
}
