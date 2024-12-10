//
//  UserRemoteRepository.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 7/9/19.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import Foundation
import UIKit
import Helpers

struct AuthenticationRemoteDataSource {
    
    func deleteAccount(reason: Int?, successCompletion: @escaping (_ response: BaseRequestResponse) -> Void,
                       failureCompletion: @escaping (_ error: Error) -> Void) {
        var dict: [String:Any]?
        if let reason = reason {
            dict = ["reason": reason]
        }
        Router.APIRouter(endPoint: .deleteAccount, parameters: dict, method: .post) { response in
            
            switch response {
            case .success(let success):
                guard let requestResponse = try? JSONDecoder().decode(BaseRequestResponse.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if requestResponse.status {
                    successCompletion(requestResponse)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: requestResponse.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
    
    func getDeleteReasons(successCompletion: @escaping (_ response: GenericResponse<[ConstantModel]>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .deleteAccountReasons, parameters: nil, method: .get) { (response) in
            
            switch response {
                
            case .success(let success):
                
                guard let response = try? JSONDecoder().decode(GenericResponse<[ConstantModel]>.self, from: success.data) else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                successCompletion(response)
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
    
    
    func login(dict : [String:Any], successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void,
               failureCompletion: @escaping (_ error: Error) -> Void) {
        //    func login() {
        
        Router.APIRouter(endPoint: .login, parameters: dict , method: .post) { response in
            
            switch response {
            case .success(let success):
                guard let userModel = try? JSONDecoder().decode(GenericResponse<User_Model>.self, from: success.data) else {
                    print("parsing failed")
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
    
    func sendPushNotificationToUser(appendingURL:String, successCompletion: @escaping (_ response: GenericResponse<Data>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        
        Router.APIRouter(endPoint: .sendPushNotification, appendingURL: appendingURL, parameters: nil, method: .get) {
            response in
            switch response {
            case .success(let success):
                guard let notifications = try? JSONDecoder().decode(GenericResponse<Data>.self, from: success.data) else {
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
    
    func socialLogin(dict : [String:Any], successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void,
                     failureCompletion: @escaping (_ error: Error) -> Void) {
        //    func login() {
        
        Router.APIRouter(endPoint: .socialLogin, parameters: dict , method: .post) { response in
            
            switch response {
            case .success(let success):
                guard let userModel = try? JSONDecoder().decode(GenericResponse<User_Model>.self, from: success.data) else {
                    print("parsing failed")
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
    
    func signup(dict: [String:Any], successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void,
                failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .signup, parameters: dict, method: .post) { response in
            
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
    
    func forgotPassword(dict: [String:Any], successCompletion: @escaping (_ response: BaseRequestResponse) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .forgotPassword, parameters: dict, method: .post) { response in
            
            switch response {
            
            case .success(let success):
                
                guard let response = try? JSONDecoder().decode(BaseRequestResponse.self, from: success.data) else {
                    print("Parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if response.status {
                    successCompletion(response)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: response.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
    
    func verifyOTP(dict: [String:Any], successCompletion: @escaping (_ response: BaseRequestResponse) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .verifyOTP, parameters: dict, method: .post) { response in
            
            switch response {
            
            case .success(let success):
                
                guard let response = try? JSONDecoder().decode(BaseRequestResponse.self, from: success.data) else {      print("Parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if response.status {
                    successCompletion(response)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: response.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
    
    func resetPassword(dict: [String:Any], successCompletion: @escaping (_ response: BaseRequestResponse) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .resetPassword, parameters: dict, method: .post) { response in
            
            switch response {
            
            case .success(let success):
                
                guard let response = try? JSONDecoder().decode(BaseRequestResponse.self, from: success.data) else {
                    print("Parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if response.status {
                    successCompletion(response)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: response.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
    
    func changePassword(dict: [String:Any], successCompletion: @escaping (_ response: BaseRequestResponse) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .changePassword, parameters: dict, method: .post) { response in
            
            switch response {
            
            case .success(let success):
                
                guard let response = try? JSONDecoder().decode(BaseRequestResponse.self, from: success.data) else {      print("Parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if response.status {
                    successCompletion(response)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: response.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
    
    func logout(successCompletion: @escaping (_ response: BaseRequestResponse) -> Void, failureCompletion: @escaping (_ error: Error) -> Void){
        
        let appendingURL = "?device_type=\(Utilities.shared.getDeviceType())&device_token=\(UserPreferences.fcmToken)"
        Router.APIRouter(endPoint: .logout, appendingURL:appendingURL, parameters: nil, method: .get) { (response) in
            
            switch response {
            
            case .success(let success):
                
                guard let response = try? JSONDecoder().decode(BaseRequestResponse.self, from: success.data) else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                successCompletion(response)
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
    
    func getUserProfile(successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void){
        
        Router.APIRouter(endPoint: .getUserProfile, parameters: nil, method: .get) { (response) in
            
            switch response {
            
            case .success(let success):
                
                guard let userModel = try? JSONDecoder().decode(GenericResponse<User_Model>.self, from: success.data) else {
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
    
    func updatePushNotifications(pushNotifications: Int, successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void){
        
        Router.APIRouter(endPoint: .profile, parameters: ["push_notification": pushNotifications], method: .post) { (response) in
            
            switch response {
            
            case .success(let success):
                
                guard let userModel = try? JSONDecoder().decode(GenericResponse<User_Model>.self, from: success.data) else {
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
    
    func getReportTypes(successCompletion: @escaping (_ response: GenericResponse<[ReportType]>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {

        Router.APIRouter(endPoint: .reportTypes, appendingURL: "", parameters: [:], method: .get) {
            response in

            switch response {
            case .success(let success):
                guard let notifications = try? JSONDecoder().decode(GenericResponse<[ReportType]>.self, from: success.data) else {
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
    
    func getSettings(successCompletion: @escaping (_ response: GenericResponse<SettingsResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {

        Router.APIRouter(endPoint: .settings, appendingURL: "", parameters: [:], method: .get) {
            response in

            switch response {
            case .success(let success):
                guard let notifications = try? JSONDecoder().decode(GenericResponse<SettingsResponse>.self, from: success.data) else {
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
    
    func getBraintreeToken(successCompletion: @escaping (_ response: GenericResponse<BrainTreeResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void){
        
        Router.APIRouter(endPoint: .brainTreeToken, parameters: [:], method: .get) { response in
            switch response {
            case .success(let success):
                guard let braintreeResponse = try? JSONDecoder().decode(GenericResponse<BrainTreeResponse>.self, from: success.data)  else {
                    print("parsing failed")
                    
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if braintreeResponse.status {
                    successCompletion(braintreeResponse)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: braintreeResponse.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
    
    func getCards(successCompletion: @escaping (_ response: GenericResponse<[CardResponse]>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .userCards, appendingURL: "", parameters: [:], method: .get) {
            response in

            switch response {
            case .success(let success):
                guard let cardsResponse = try? JSONDecoder().decode(GenericResponse<[CardResponse]>.self, from: success.data) else {
                    print("parsing failed")
                    
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if cardsResponse.status {
                    successCompletion(cardsResponse)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: cardsResponse.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func deleteCard(cardId: String, successCompletion: @escaping (_ response: GenericResponse<[CardResponse]>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .userCards, appendingURL: "/\(cardId)", parameters: [:], method: .del) {
            response in

            switch response {
            case .success(let success):
                guard let cardsResponse = try? JSONDecoder().decode(GenericResponse<[CardResponse]>.self, from: success.data) else {
                    print("parsing failed")
                    
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if cardsResponse.status {
                    successCompletion(cardsResponse)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: cardsResponse.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func sendReport(params:[String:Any], successCompletion: @escaping (_ response: GenericResponse<ReportResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        Router.APIRouter(endPoint: .reports, appendingURL: "", parameters: params, method: .post) {
            response in
            switch response {
            case .success(let success):
                guard let notifications = try? JSONDecoder().decode(GenericResponse<ReportResponse>.self, from: success.data) else {
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
    
    func addCard(params:[String:Any], successCompletion: @escaping (_ response: GenericResponse<AddCardResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        Router.APIRouter(endPoint: .addStripeCard, appendingURL: "", parameters: params, method: .post) {
            response in
            switch response {
            case .success(let success):
                guard let addCardResponse = try? JSONDecoder().decode(GenericResponse<AddCardResponse>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if addCardResponse.status {
                    successCompletion(addCardResponse)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: addCardResponse.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func topUpAmount(params:[String:Any], successCompletion: @escaping (_ response: GenericResponse<TopupResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        Router.APIRouter(endPoint: .topUp, appendingURL: "", parameters: params, method: .post) {
            response in
            switch response {
            case .success(let success):
                guard let topupResponse = try? JSONDecoder().decode(GenericResponse<TopupResponse>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if topupResponse.status {
                    successCompletion(topupResponse)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: topupResponse.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    func submitContactUsForm(params:[String:Any], successCompletion: @escaping (_ response: GenericResponse<ContactUsResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .contactUs, appendingURL: "", parameters: params, method: .post) {
            response in
            switch response {
            case .success(let success):
                guard let notifications = try? JSONDecoder().decode(GenericResponse<ContactUsResponse>.self, from: success.data) else {
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
    
    func getPageData(endPoint: EndPoints, successCompletion: @escaping (_ response: GenericResponse<WebContentResponseModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        Router.APIRouter(endPoint: endPoint, appendingURL: "", parameters: nil, method: .get, completion: { response in
            switch response {
            case .success(let success):
                guard let pageData = try? JSONDecoder().decode(GenericResponse<WebContentResponseModel>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if pageData.status {
                    successCompletion(pageData)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: pageData.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        })
    }
    func getFaqs(successCompletion: @escaping (_ response: GenericResponse<[FaqsResponseModel]>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        Router.APIRouter(endPoint: .faqs, appendingURL: "", parameters: nil, method: .get, completion: { response in
            switch response {
            case .success(let success):
                guard let pageData = try? JSONDecoder().decode(GenericResponse<[FaqsResponseModel]>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if pageData.status {
                    successCompletion(pageData)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: pageData.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        })
    }
    
    func checkOutWithPaypal(params:[String:Any], successCompletion: @escaping (_ response: GenericResponse<OrderData>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        Router.APIRouter(endPoint: .checkout, appendingURL: "", parameters: params, method: .post) {
            response in
            switch response {
            case .success(let success):
                guard let topupResponse = try? JSONDecoder().decode(GenericResponse<OrderData>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if topupResponse.status {
                    successCompletion(topupResponse)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: topupResponse.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)

            }
        }
    }
    
    //    func validate(dic: [String:Any], completion: @escaping (ServerValidationResponse?,Failure?) -> ()) {
    //
    //        Router.APIRouter(endPoint: .validate, parameters: dic, method: .post) { response in
    //
    //            switch response {
    //
    //            case .success(let success):
    //
    //                guard let response = try? JSONDecoder().decode(ServerValidationResponse.self, from: success.data) else {
    //
    //                    completion(nil, Failure(message: "Unable to parse response.", state: .unknown, data: nil, code: nil))
    //                    return
    //                }
    //                completion(response,nil)
    //
    //            case .failure(let failure):
    //
    //                completion(nil,failure)
    //
    //            }
    //        }
    //    }
    
    
    
    //    /
    
    //    func verifyPhone(dic: [String:Any], completion: @escaping (VerifyPhone?,Failure?) -> ()) {
    //
    //        Router.APIRouter(endPoint: .phoneVerification, parameters: dic, method: .post) { response in
    //
    //            switch response {
    //
    //            case .success(let success):
    //
    //                guard let response = try? JSONDecoder().decode(VerifyPhone.self, from: success.data) else {
    //
    //                    completion(nil, Failure(message: "Unable to parse response.", state: .unknown, data: nil, code: nil))
    //                    return
    //                }
    //                completion(response,nil)
    //
    //
    //            case .failure(let failure):
    //
    //                completion(nil,failure)
    //
    //            }
    //        }
    //    }
    
    //    func verifyOtp(dic: [String:Any], completion: @escaping (VerifyOtp?,Failure?) -> ()) {
    //
    //        Router.APIRouter(endPoint: .otpVerification, parameters: dic, method: .post) { response in
    //
    //            switch response {
    //
    //            case .success(let success):
    //
    //                guard let response = try? JSONDecoder().decode(VerifyOtp.self, from: success.data) else {
    //
    //                    completion(nil, Failure(message: "Unable to parse response.", state: .unknown, data: nil, code: nil))
    //                    return
    //                }
    //                completion(response,nil)
    //
    //
    //            case .failure(let failure):
    //
    //                completion(nil,failure)
    //
    //            }
    //        }
    //    }
    
    //    func changePassword(dic : [String : Any], completion : @ escaping (ChangePassword?,Failure?) -> ()){
    //
    //        Router.APIRouter(endPoint: .changePassword, parameters: dic, method: .post) { (response) in
    //
    //            switch response {
    //
    //            case .success(let success):
    //                guard let success = try? JSONDecoder().decode(ChangePassword.self, from: success.data) else {
    //
    //                    completion(nil, Failure(message: "Unable to parse response.", state: .unknown, data: nil, code: nil))
    //                    return
    //                }
    //
    //                completion(success,nil)
    //
    //
    //            case .failure(let failure):
    //
    //                completion(nil,failure)
    //
    //            }
    //        }
    //    }
    
    //    func updateProfile(dic : [String : Any], completion : @ escaping (UserModel?,Failure?) -> ()){
    //        let authRepo = AuthenticationRepository()
    //        authRepo.getUser { (token) in
    //            Router.configuration = RouterConfiguration.init(baseURL: Enviroment.baseURL, authorizationToken: token!.access_token)
    //        }
    //        Router.APIRouter(endPoint: .updateProfile, parameters: dic, method: .post) { (response) in
    //
    //            switch response {
    //
    //            case .success(let success):
    //                guard let success = try? JSONDecoder().decode(UserModel.self, from: success.data) else {
    //
    //                    completion(nil, Failure(message: "Unable to parse response.", state: .unknown, data: nil, code: nil))
    //                    return
    //                }
    //
    //                completion(success,nil)
    //
    //
    //            case .failure(let failure):
    //
    //                completion(nil,failure)
    //
    //            }
    //        }
    //    }
}
