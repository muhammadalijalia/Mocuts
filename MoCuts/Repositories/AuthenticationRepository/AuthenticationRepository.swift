//
//  AuthenticationRepository.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 29/03/2020.
//  Copyright © 2020 Appiskey. All rights reserved.
//

import Foundation
import Reachability

class AuthenticationRepository: BaseRepository {
    
    private var localDataSource: AuthenticationLocalDataSource!
    private var remoteDataSource: AuthenticationRemoteDataSource!
    
    override init() {
        super.init()
        
        localDataSource = AuthenticationLocalDataSource()
        remoteDataSource = AuthenticationRemoteDataSource()
    }
    
    func login(email : String, password : String, successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        let dict : [String : Any] = ["email": email,
                                     "password": password,
                                     "device_type": Utilities.shared.getDeviceType(),
                                     "device_token": UserPreferences.fcmToken]
        
        remoteDataSource.login(dict: dict) { response in
            Router.configuration = RouterConfiguration.init(baseURL: Enviroment.baseURL, authorizationToken: response.data?.access_token?.token)

            if let user = response.data {
                if user.access_token != nil {
//                    self.localDataSource.saveToken(user.access_token!)
                    UserPreferences.accessToken = user.access_token
                    

                    print(user.access_token?.token ?? "")
                }
                
//                self.localDataSource.saveUser(user)
                UserPreferences.userModel = user
            }
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func socialLogin(name: String, email: String, role: Int, socialPlatform: String, clientId: String, token: String, successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        let dict : [String : Any] = ["name": name,
                                     "email": email,
                                     "role": "\(role)",
                                     "social_platform": socialPlatform,
                                     "client_id": clientId,
                                     "token": token,
                                     "device_type": Utilities.shared.getDeviceType(),
                                     "device_token": UserPreferences.fcmToken]
        
        remoteDataSource.socialLogin(dict: dict) { response in

            Router.configuration = RouterConfiguration.init(baseURL: Enviroment.baseURL, authorizationToken: response.data?.access_token?.token)

            if let user = response.data {
                if user.access_token != nil {
//                    self.localDataSource.saveToken(user.access_token!)
                    UserPreferences.accessToken = user.access_token
                    print(user.access_token?.token ?? "")

                }
//                self.localDataSource.saveUser(user)
                UserPreferences.userModel = user
            }
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func signup(name : String , phone : String , email : String , location : String , lat : String , long : String , password : String , role : Int , successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        var dict : [String : Any] = ["name":name,
                                     "phone":phone,
                                     "email": email,
                                     "password":password,
                                     "role":role,
                                     "device_type": Utilities.shared.getDeviceType(),
                                     "device_token": UserPreferences.fcmToken]
        if location != "" {
            dict["address"] = location
            dict["latitude"] = lat
            dict["longitude"] = long
        }
        
        remoteDataSource.signup(dict: dict) { response in

            Router.configuration = RouterConfiguration.init(baseURL: Enviroment.baseURL, authorizationToken: response.data?.access_token?.token)

            if let user = response.data {
                if user.access_token != nil {
//                    self.localDataSource.saveToken(user.access_token!)
                    UserPreferences.accessToken = user.access_token
                    print(user.access_token?.token ?? "")
                }
//                self.localDataSource.saveUser(user)
                UserPreferences.userModel = user
            }
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func forgotPassword(email : String,isForgot: Int? = nil, successCompletion: @escaping (_ response: BaseRequestResponse) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        let dict : [String : Any] = ["email": email, "is_forgot": isForgot]
        
        remoteDataSource.forgotPassword(dict: dict) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func verifyOTP(email : String , code : String , successCompletion: @escaping (_ response: BaseRequestResponse) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        let dict : [String : Any] = ["email": email,
                                     "verification_code": code]
        remoteDataSource.verifyOTP(dict: dict) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func resetPassword(email : String , code : String , password : String, successCompletion: @escaping (_ response: BaseRequestResponse) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        let dict : [String : Any] = ["email": email,
                                     "verification_code": code,
                                     "password":password]
        remoteDataSource.resetPassword(dict: dict) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func changePassword(currentPassword : String, newPassword : String, successCompletion: @escaping (_ response: BaseRequestResponse) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        let dict : [String : Any] = ["current_password": currentPassword,
                                     "password": newPassword]
        remoteDataSource.changePassword(dict: dict) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func logout(successCompletion: @escaping (_ response: BaseRequestResponse) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.logout() { response in
            Router.configuration.authorizationToken = nil
            self.removeUserToken()
            
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
//    func getUserProfile(from method: FetchingType = .automatic, successCompletion: @escaping (_ response: GenericResponse<UserModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
//
//        remoteDataSource.getUserProfile() { response in
//            Router.configuration = RouterConfiguration.init(baseURL: Enviroment.baseURL, authorizationToken: response.data?.access_token?.token)
//            if let user = response.data {
//                if user.access_token != nil {
//                    self.localDataSource.saveToken(user.access_token!)
//                    print(user.access_token?.token ?? "")
//                }
//                self.localDataSource.saveUser(user)
//            }
//            successCompletion(response)
//        } failureCompletion: { error in
//            failureCompletion(error)
//        }
//    }
    

    
    func getUserProfile(from method: FetchingType = .automatic, successCompletion: @escaping (_ response: User_Model?) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
                
        switch method {
        case .local:
            successCompletion(UserPreferences.userModel)
        print("aaa")

        case .remote:
            remoteDataSource.getUserProfile { response in
                successCompletion(response.data)
            } failureCompletion: { error in
                failureCompletion(error)
            }

        case .remoteUpdateLocal:
            remoteDataSource.getUserProfile { response in
                if let user = response.data {
                    successCompletion(user)
//                    self.localDataSource.saveUser(user)
                    UserPreferences.userModel = user
                }
            } failureCompletion: { error in
                failureCompletion(error)
            }

        case .localFetchingRemote:
            successCompletion(UserPreferences.userModel)
            remoteDataSource.getUserProfile { response in
                if let user = response.data {
                    successCompletion(user)
//                    self.localDataSource.saveUser(user)
                    UserPreferences.userModel = user
                }
            } failureCompletion: { error in
                failureCompletion(error)
            }
            
        case .automatic:
            if self.networkAdapter.isNetworkAvailable {
                remoteDataSource.getUserProfile { response in
                    if let user = response.data {
                        successCompletion(user)
//                        self.localDataSource.saveUser(user)
                        UserPreferences.userModel = user
                    }
                } failureCompletion: { error in
                    successCompletion(UserPreferences.userModel)
                }
            }
        }
    }
    
    func updatePushNotifications(pushNotifications: Int, successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        remoteDataSource.updatePushNotifications(pushNotifications: pushNotifications) {
            response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func getReportTypes(successCompletion: @escaping (_ response: GenericResponse<[ReportType]>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        remoteDataSource.getReportTypes() {
            response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func getSettings(successCompletion: @escaping (_ response: GenericResponse<SettingsResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        remoteDataSource.getSettings() {
            response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func getCards(successCompletion: @escaping (_ response: GenericResponse<[CardResponse]>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        remoteDataSource.getCards() {
            response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func deleteCard(cardId: String, successCompletion: @escaping (_ response: GenericResponse<[CardResponse]>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        remoteDataSource.deleteCard(cardId: cardId) {
            response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func addCard(paymentMethod: String, applePay: Int = 0, successCompletion: @escaping (_ response: GenericResponse<AddCardResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        var params = [String:Any]()
        params["payment_method"] = paymentMethod
        if applePay == 1 {
            params["apple_pay"] = applePay
        }

        remoteDataSource.addCard(params: params) {
            response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func getBraintreeToken(successCompletion: @escaping (_ response: GenericResponse<BrainTreeResponse>)  -> Void, failureCompletion: @escaping (_ error: Error) -> Void){
        
        remoteDataSource.getBraintreeToken { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func sendReport(toId: String, reportTypeId: String, message: String, successCompletion: @escaping (_ response: GenericResponse<ReportResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        var params = [String:Any]()
        params["to_id"] = toId
        params["report_type_id"] = reportTypeId
        params["message"] = message
        
        remoteDataSource.sendReport(params: params) {
            response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func topUpAmount(amount: Int, paymentMethod: String, paypal: Bool, successCompletion: @escaping (_ response: GenericResponse<TopupResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        var params = [String:Any]()
        params["amount"] = amount
        params["payment_method"] = paymentMethod
        if paypal == true {
            params["paypal_pay"] = paypal
        }
        
        remoteDataSource.topUpAmount(params: params) {
            response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func sendPushNotificationToUser(appendingUrl: String, successCompletion: @escaping (_ response: GenericResponse<Data>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.sendPushNotificationToUser(appendingURL: appendingUrl) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func submitContactUsForm(parameters: [String:Any], successCompletion: @escaping (_ response: GenericResponse<ContactUsResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.submitContactUsForm(params: parameters) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    
    func getLocalUserToken(completion: @escaping (Access_token?) -> ()) {
        let token = UserPreferences.accessToken //localDataSource.getToken()
        completion(token)
    }
    
    func removeUserToken() {
        UserPreferences.clearPreference()
    }
    
    func getPageData(endPoint: EndPoints, successCompletion: @escaping (_ response: GenericResponse<WebContentResponseModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.getPageData(endPoint: endPoint) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func getFaqs(successCompletion: @escaping (_ response: GenericResponse<[FaqsResponseModel]>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.getFaqs() { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    func checkOutWithPaypal(amount: Int, successCompletion: @escaping (_ response: GenericResponse<OrderData>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        var params = [String:Any]()
        params["amount"] = "\(amount)"
        params["currency"] = "USD"
        remoteDataSource.checkOutWithPaypal(params: params) {
            response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    //    func create(dic:[String:Any], completion: @escaping (Token?) -> (), errorCompletion: @escaping (ServerErrorResponse?, String?) -> ()) {
    //
    //        remoteDataSource.signup(dic: dic) {
    //            (token, failure) in
    //
    //            guard failure == nil else {
    //                self.switchFailure(failure!, errorCompletion: errorCompletion)
    //                return
    //            }
    //            token?.email = dic["email"] as? String
    //            Router.configuration = RouterConfiguration.init(baseURL: Enviroment.baseURL, authorizationToken: token?.access_token)
    //            self.localDataSource.saveToken(token!)
    //            completion(token)
    //
    //        }
    //    }
    //
    //    func getUser(completion: @escaping (Token?) -> ()) {
    //        let token = localDataSource.getToken()
    //        completion(token)
    //    }
    //
    //    func removeUser() {
    //        localDataSource.removeToken()
    //    }
    //
    //    func forget(dic:[String:Any], completion: @escaping (ForgetResponse?) -> (), errorCompletion: @escaping (ServerErrorResponse?, String?) -> ()) {
    //
    //        remoteDataSource.forgot(dic: dic) {
    //            (response, failure) in
    //
    //            guard failure == nil else {
    //                self.switchFailure(failure!, errorCompletion: errorCompletion)
    //                return
    //            }
    //            completion(response)
    //        }
    //    }
    //
    //    func verifyPhone(dic:[String:Any], completion: @escaping (VerifyPhone?) -> (), errorCompletion: @escaping (ServerErrorResponse?, String?) -> ()) {
    //
    //        remoteDataSource.verifyPhone(dic: dic) {
    //            (response, failure) in
    //
    //            guard failure == nil else {
    //                self.switchFailure(failure!, errorCompletion: errorCompletion)
    //                return
    //            }
    //            completion(response)
    //        }
    //    }
    //    func verifyOtp(dic:[String:Any], completion: @escaping (VerifyOtp?) -> (), errorCompletion: @escaping (ServerErrorResponse?, String?) -> ()) {
    //
    //        remoteDataSource.verifyOtp(dic: dic) {
    //            (response, failure) in
    //
    //            guard failure == nil else {
    //                self.switchFailure(failure!, errorCompletion: errorCompletion)
    //                return
    //            }
    //            completion(response)
    //        }
    //    }
    //
    //
    //    func changePassword(dic : [String : Any], completion : @escaping (ChangePassword?) -> () , errorCompletion : @escaping (ServerErrorResponse? , String?) -> ()) {
    //
    //        remoteDataSource.changePassword(dic: dic) { (message, failure) in
    //
    //            guard failure == nil else {
    //                self.switchFailure(failure!, errorCompletion: errorCompletion)
    //                return
    //            }
    //            completion(message)
    //        }
    //    }
    //
    //
    ////    func updateProfile(dic : [String : Any], completion : @escaping (UserModel?)->() , errorCompletion : @escaping (ServerErrorResponse?, String?) -> ()) {
    ////
    ////        remoteDataSource.updateProfile(dic: dic) { (response, failure) in
    ////
    ////            guard failure == nil else {
    ////                self.switchFailure(failure!, errorCompletion: errorCompletion)
    ////                return
    ////            }
    ////            completion(response!)
    ////        }
    ////    }
    //
    //    func updatePassword(dic : [String : Any], completion : @escaping (ChangePassword?)->() , errorCompletion : @escaping (ServerErrorResponse?, String?) -> ()) {
    //
    //        remoteDataSource.updatePassword(dic: dic) { (response, failure) in
    //
    //            guard failure == nil else {
    //                self.switchFailure(failure!, errorCompletion: errorCompletion)
    //                return
    //            }
    //            if let response = response {
    //                completion(response)
    //            }
    //
    //        }
    //    }
    
}

//class UserRepository: BaseRepository {
//    
//    private var localDataSource: AuthenticationLocalDataSource!
//    private var remoteDataSource: AuthenticationRemoteDataSource!
//    
//    override init() {
//        super.init()
//        
//        localDataSource = AuthenticationLocalDataSource()
//        remoteDataSource = AuthenticationRemoteDataSource()
//    }
//
//}
