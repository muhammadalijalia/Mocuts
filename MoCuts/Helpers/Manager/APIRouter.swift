//
//  APIRouter.swift
//  MoCuts
//
//  Created by Appiskey's iOS Dev on 7/8/19.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import Foundation
import Swift
import UIKit
import Helpers
import FirebaseAnalytics
import Firebase
//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//

///This file contains classes, structures which are used for api calling

//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------//

/// Success block with success data.
struct Success : Decodable {
    var data : Data
    init(data:Data=Data()) {
        self.data = data
        do {
            let serverResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            //            print("\n✅✅✅✅✅========================== SERVER RESPONSE START ==========================✅✅✅✅✅\n")
            //            print(serverResponse)
            //
            //            print("\n✅✅✅✅✅========================== SERVER RESPONSE END ==========================✅✅✅✅✅\n")
            
            
        } catch {
            print("Unable to decode as json object: \(error.localizedDescription)")
        }
    }
}




/// Failure block with message, response code and data(if available) in JSON format.
struct Failure {
    var message : String
    var state : ResponseState
    var data : Data?
    var code: Int?
    
    init(message: String,
         state: ResponseState,
         data: Data?,
         code: Int) {
        
        self.message = message
        self.state = state
        self.code = code
        self.data = data
        
        if let adata = data {
            if let model = try? JSONDecoder().decode(BaseRequestResponse.self, from:adata) {
                self.message = model.message ?? ""
            }
        }
    }
}

struct ErrorResponse {
    
}
/// Enum with success/ failure.
///
/// - success: success of Request.
/// - failure: failure of Request.
enum ServerResponse  {
    case success (Success)
    case failure (Failure)
}

//MARK: Enums to use in APIs
///This enum indicates that the API is type of Post, get, put or delete type.
enum HTTPMethod:String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case del = "DELETE"
}

///This enum indicates the FileType uses in application.
enum FileType{
    case doc
    case xlx
    case pdf
    case image
    case video
    case message
    case audio
}

///This enum indicates that the result of APIs is what
enum ResponseState {
    case success
    case failure
    case authError
    case unknown
    case networkIssue
    case timeOut
    case Error404
    case ServerIssue
}

enum EndPoints: String{
    
    case login = "login"
    case signup = "register"
    case forgotPassword = "forgot-password"
    case verifyOTP = "verify-otp"
    case resetPassword = "reset-password"
    case logout = "logout"
    case getUserProfile = "me"
    case changePassword = "change-password"
    case socialLogin = "social-login"
    case attachments = "attachments"
    case withdraw = "withdraw"
    case getJobs = "jobs"
    case getBarberById = "barber"
    case barbers = "barbers"
    case addService = "services"
    case availabilities = "availabilities"
    case availabilitiesByDate = "availabilities-by-date"
    case withdrawals = "transactions?type=30"
    case profile = "profile"
    case review = "review"
    case reviews = "reviews"
    case removeGallery = "remove-gallery"
    case notifications = "notifications"
    case sendPushNotification = "send-push-notification"
    case markRead = "mark-read"
    case generateConnectAccountLink = "generate-connect-account-link"
    case reports = "reports"
    case reportTypes = "report-types"
    case contactUs = "contact-us"
    case aboutUs = "page/about-us"
    case privacyPolicy = "page/privacy-policy"
    case termsAndConditions = "page/terms-and-conditions"
    case faqs = "faqs"
    case userCards = "user-cards"
    case addStripeCard = "add-stripe-card"
    case topUp = "top-up"
    case checkPendingJobs = "check-user-job"
    case settings = "settings"
    case deleteAccount = "delete-account"
    case deleteAccountReasons = "constants?instance_type=35&orderBy=id&sortBy=asc"
    case brainTreeToken = "generate-braintree-token"
    case connectPaypal = "connect-paypal"
    case checkout = "checkout"
}

///this completion block are use as call back from api
typealias completionBlock = (_ response: ServerResponse) -> Void


///convert string to mutable data
extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true)
        append(data!)
    }
    
    func appendStringToBody(boundaryPrefix: String,
                            key: String,
                            fileName: String,
                            mimeType: String,
                            data: Data){
        
        self.appendString(string: boundaryPrefix)
        self.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
        self.appendString(string: "Content-Type: \(mimeType)\r\n\r\n")
        self.append(data)
        self.appendString(string: "\r\n")
        
    }
}


struct Messages{
    
    static let error404 = "Source not found, Kindly recheck and try again later."
    static let authError = "User Not found, Or authentification failed."
    static let wentWrongError = "Something went wrong, Please try again!"
    static let serverNotResponding = "Server not responding at the moment."
    static let internetError = "Please check your internet connection."
    static let timedOut = "Connection Timeout, Please try again!"
    
}

/// Media type with key server required. data of media and mimetype is file type of. and file name need to be put on server.
struct Media {
    
    var key : String
    var data : Data
    var mimeType: String
    var filename : String
    
    init (key : String, fileData: Data, type: FileType, mimeType : String = "", filename: String = "file", last3Char: String = "") {
        
        self.key = key
        self.mimeType = mimeType
        
        if type == .image{
            
            self.data = fileData
            self.mimeType = mimeType == "" ? "image/\(last3Char)" : mimeType
            if filename.components(separatedBy: ".").count <= 1{
                self.filename = filename.appending("." + last3Char)
            }else{
                self.filename = filename
            }
        }else if type == .audio{
            self.data = fileData
            self.mimeType = mimeType == "" ? "audio/aac" : mimeType
            if filename.components(separatedBy: ".").count <= 1{
                self.filename = filename.appending(".aac")
            }else{
                self.filename = filename
            }
        }else if type == .video{
            self.data = fileData
            self.mimeType = mimeType == "" ? "video/\(last3Char)" : mimeType
            if last3Char == "mov"{
                self.mimeType = mimeType == "" ? "video/quicktime" : mimeType
            }else if last3Char == "3gp"{
                self.mimeType = mimeType == "" ? "video/3gpp" : mimeType
            }
            if filename.components(separatedBy: ".").count <= 1{
                self.filename = filename.appending("." + last3Char)
            }else{
                self.filename = filename
            }
        }else if type == .doc{
            self.data = fileData
            self.mimeType = mimeType == "" ? "application/msword" : mimeType
            if filename.components(separatedBy: ".").count <= 1{
                self.filename = filename.appending(".doc")
            }else{
                self.filename = filename
            }
        }else if type == .xlx{
            self.data = fileData
            self.mimeType = mimeType == "" ? "application/vnd.ms-excel" : mimeType
            if filename.components(separatedBy: ".").count <= 1{
                self.filename = filename.appending(".xls")
            }else{
                self.filename = filename
            }
        }else if type == .pdf{
            self.data = fileData
            self.mimeType = mimeType == "" ? "application/pdf" : mimeType
            if filename.components(separatedBy: ".").count <= 1{
                self.filename = filename.appending(".pdf")
            }else{
                self.filename = filename
            }
        }else {
            self.filename = filename
            data = Data()
        }
        
    }
    
    init(key : String, data: Data, mimeType : String, filename : String = "video") {
        self.key = key
        self.data = data
        self.mimeType = mimeType
        self.filename = filename
    }
    
}


struct RouterConfiguration{
    var baseURL : String
    var authorizationToken: String?
}

///this router have to perform api tasks
struct Router {
    
    ////this function perform api tasks, defferentiate api tasks with enum typeOfCall, httpsMethods etc
    
    static var configuration: RouterConfiguration! = nil
    
    static func APIRouter(completeURL: String?=nil, endPoint: EndPoints?=nil, appendingURL: String?=nil, parameters: Dictionary<String, Any>?, medias: [Media]?=nil,method: HTTPMethod, completion: @escaping completionBlock)
    {
        var urlForAPI = ""
        if configuration == nil && completeURL == nil{
            return
        }
        
        if completeURL != nil{
            urlForAPI = completeURL!
            print("Complete URL" , completeURL!)
        }else{
            urlForAPI = (configuration.baseURL + endPoint!.rawValue) + (appendingURL ?? "")
        }
        
        var escapedAddress = urlForAPI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlForAPI
        escapedAddress = escapedAddress.replacingOccurrences(of: "%2526", with: "%26")
        guard let urlToHit = URL.init(string: escapedAddress) else {
            print("url is invalid")
            return
        }
        
        print("\n🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷\n")
        
        print(" \n *************   URL: \(urlToHit)      ************* \n ")
        print(" \n *************   Method: \(method.rawValue)      *************\n")
        
        let session = URLSession.shared
        let timeOut = 30.0
        
        
        var request = URLRequest.init(url: urlToHit,
                                      cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                      timeoutInterval: timeOut)
        
        
        request.httpMethod = method.rawValue
        if configuration.authorizationToken == nil {
            configuration.authorizationToken = UserPreferences.accessToken?.token
        }
        if completeURL == nil, configuration != nil, configuration.authorizationToken != nil{
            print("AuthToken: \(configuration.authorizationToken!)")
            request.addValue("Bearer " + configuration.authorizationToken!, forHTTPHeaderField: "Authorization")
        }
        
        if (medias != nil || medias?.count > 0) {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = createBody(parameters: parameters ?? [:],
                                          boundary: boundary,
                                          medias: medias)
        }else if parameters != nil && parameters?.count != 0 {
            do {
                let jsonParams = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
                request.httpBody = jsonParams
                if let body = NSString(data: jsonParams, encoding: String.Encoding.ascii.rawValue) {
                    print("Params: \(body)")
                }
            } catch let error {
                print(error.localizedDescription)
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            var httpResponseCode: Int = 0
            guard let httpResponse = response as? HTTPURLResponse else {
                let failure = Failure.init(message: Messages.internetError,
                                           state: ResponseState.networkIssue,
                                           data: nil,
                                           code: httpResponseCode)
                completion(ServerResponse.failure(failure))
                return
            }
            httpResponseCode = httpResponse.statusCode
            print("\n *************  Response Code :\(httpResponseCode) ************* \n")
            print("\n🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷\n")
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.networkAdapter.showHideOnNetworkCall(error: error)
            }
            
            guard error == nil else {
                var errorMsg = Messages.wentWrongError
                var responseState : ResponseState = ResponseState.failure
                if error?._code == NSURLErrorTimedOut {
                    #if DEBUG
                    if let error = error {
                        print("\nTimeoutTest8049:\n\(error.localizedDescription)")
                    }
                    #endif
                    errorMsg = Messages.timedOut
                    responseState = ResponseState.timeOut
                } else if error?._code == NSURLErrorNotConnectedToInternet || error?._code == NSURLErrorNetworkConnectionLost{
                    errorMsg = Messages.internetError
                    responseState = ResponseState.networkIssue
                }
                let failure = Failure.init(message: errorMsg,
                                           state: responseState,
                                           data: nil,
                                           code: httpResponseCode)
                
                completion(ServerResponse.failure(failure))
                return
            }
            
            guard let data = data else {
                let failure = Failure.init(message: Messages.wentWrongError,
                                           state: ResponseState.unknown,
                                           data: nil,
                                           code: httpResponseCode)
                completion(ServerResponse.failure(failure))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode){
                if completeURL == "https://www.google.com"{
                    completion(ServerResponse.success(Success()))
                }else{
                    let successData = Success.init(data: data)
                    completion(ServerResponse.success(successData))
                }
                
                print("\n✅✅✅✅✅========================== SUCCESS RESPONSE START ==========================✅✅✅✅✅\n")
                
                print(String(data: data, encoding: .utf8) ?? "")
                
                print("\n✅✅✅✅✅========================== SUCCESS RESPONSE END ==========================✅✅✅✅✅\n")
            }else {
                var errorMsg = Messages.wentWrongError
                var responseState : ResponseState = ResponseState.failure
                if(httpResponse.statusCode == 401) {
                    errorMsg = Messages.wentWrongError
                    responseState = ResponseState.authError
                

                    DispatchQueue.main.async {
                        UserPreferences.clearPreference()
                        let sgVc : GetStartedView
                        = AppRouter.instantiateViewController(storyboard: .authentication)
                        let nvc = UINavigationController(rootViewController: sgVc)
                        Helper.getInstance.makeSpecificViewRoot(vc: nvc)
                    }
                }else if(httpResponse.statusCode == 404){
                    errorMsg = Messages.wentWrongError
                    responseState = ResponseState.Error404
                }else if(httpResponse.statusCode == 500){
                    errorMsg = Messages.serverNotResponding
                    responseState = ResponseState.ServerIssue
                }
                let failure = Failure.init(message: errorMsg,
                                           state: responseState,
                                           data: data,
                                           code: httpResponseCode)
                
                if data != nil {
                    
                    print("\n❌❌❌❌❌❌========================== FAILURE RESPONSE START ==========================❌❌❌❌❌❌\n")
                    
                    print(String(data: data, encoding: .utf8) ?? "")
                    
                    print("\n❌❌❌❌❌❌========================== FAILURE RESPONSE END ==========================❌❌❌❌❌❌\n")
                    
                }
                completion(ServerResponse.failure(failure))
            }
        })
        task.resume()
    }
    
    static func createBody(parameters: [String: Any],
                           boundary: String,
                           medias: [Media]?=nil) -> Data {
        
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            print("Params \(key) : \(value)")
            
            if let dicValue = value as? [String: Any]{
                for (subKey, subValue) in dicValue{
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)[\(subKey)]\"\r\n\r\n")
                    if let subValueStr = subValue as? String{
                        print("\(key)[\(subKey)]:\(subValueStr)\r\n")
                        body.appendString(string: "\(subValueStr)\r\n")
                    }else{
                        body.appendString(string: "\(subValue)\r\n")
                    }
                }
            }else{
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        if medias != nil {
            if medias!.count == 1{
                body.appendStringToBody(boundaryPrefix: boundaryPrefix,
                                        key: "\(medias!.first!.key)",
                                        fileName: medias!.first!.filename,
                                        mimeType: medias!.first!.mimeType,
                                        data: medias!.first!.data)
            }else{
                for (i,media) in medias!.enumerated() {
                    body.appendStringToBody(boundaryPrefix: boundaryPrefix,
                                            key: "\(media.key)",
                                            fileName: media.filename,
                                            mimeType: media.mimeType,
                                            data: media.data)
                }
            }
            body.appendString(string: "--".appending(boundary.appending("--")))
            
        } else {
            print("Images are not provided...")
        }
        return body as Data
    }
    static func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
