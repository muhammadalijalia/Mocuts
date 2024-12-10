//
//  BaseModels.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 8/9/19.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import Foundation

class GenericResponse<T : Codable> : Codable {
    let status : Bool
    let data : T?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)!
        
        if let dataType = try values.decodeIfPresent(T.self, forKey: .data) {
            data = dataType
        } else {
            data = nil
        }
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

class GenericArrayResponse<T : Codable> : Codable {
    let status : Bool
    let data : [T]?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)!
        
        if let dataType = try values.decodeIfPresent([T].self, forKey: .data) {
            data = dataType
        } else {
            data = nil
        }
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

struct ServerErrorResponse: Decodable {
    var timestamp: String?
    var status: Int?
    var message: String?
    var errors: [[String: String]]
}
//
//class ResponseModel : Decodable {
//    var message : String = ""
//    var status: Bool?
//}
//
//struct PaymentErrorResponse: Decodable {
//    var error: ErrorMessage?
//}
struct BaseRequestResponse : Decodable {
    let status : Bool
    let message : String?
}
//struct ServerValidationResponse: Decodable {
//    var timestamp: String
//    var status: Int
//    var message: String
//    var data: [ValidationInnerResponse]
//    
//}
//struct ValidationInnerResponse: Decodable{
//    var key: String
//    var status: Bool
//    var message: String
//}
//
//
//struct PhoneVerifyFailure : Decodable{
//    var message : String?
//}
//
//struct ReservationErrorResponse : Decodable{
//    var message : String?
//}
//struct ErrorBodyMessage : Decodable {
//    var code : Int
//    var status : Bool
//    var body : String
//    var message : String
//}

struct ContactUsResponse : Codable {

    var createdAt : String?
    var email : String?
    var id : Int?
    var message : String?
    var name : String?
    var updatedAt : String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case email = "email"
        case id = "id"
        case message = "message"
        case name = "name"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}

struct WebContentResponseModel : Codable {

    var content : String?
    var createdAt : String?
    var id : Int?
    var slug : String?
    var title : String?
    var updatedAt : String?

    enum CodingKeys: String, CodingKey {
        case content = "content"
        case createdAt = "created_at"
        case id = "id"
        case slug = "slug"
        case title = "title"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}

struct FaqsResponseModel : Codable {

    var answer : String?
    var createdAt : String?
    var id : Int?
    var question : String?
    var updatedAt : String?

    enum CodingKeys: String, CodingKey {
        case answer = "answer"
        case createdAt = "created_at"
        case id = "id"
        case question = "question"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        answer = try values.decodeIfPresent(String.self, forKey: .answer)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        question = try values.decodeIfPresent(String.self, forKey: .question)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}

struct BrainTreeResponse: Codable {
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
}

struct CardResponse : Codable {

    let brand : String?
    let country : String?
    let createdAt : String?
    let expMonth : Int?
    let expYear : Int?
    let id : Int?
    let lastFour : Int?
    let paymentMethodId : String?
    let updatedAt : String?
    let userId : Int?


    enum CodingKeys: String, CodingKey {
        case brand = "brand"
        case country = "country"
        case createdAt = "created_at"
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case id = "id"
        case lastFour = "last_four"
        case paymentMethodId = "payment_method_id"
        case updatedAt = "updated_at"
        case userId = "user_id"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        brand = try values.decodeIfPresent(String.self, forKey: .brand)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        expMonth = try values.decodeIfPresent(Int.self, forKey: .expMonth)
        expYear = try values.decodeIfPresent(Int.self, forKey: .expYear)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        lastFour = try values.decodeIfPresent(Int.self, forKey: .lastFour)
        paymentMethodId = try values.decodeIfPresent(String.self, forKey: .paymentMethodId)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
    }


}

struct AddCardResponse : Codable {

    let brand : String?
    let clientSecret : String?
    let country : String?
    let createdAt : String?
    let expMonth : String?
    let expYear : String?
    let id : Int?
    let lastFour : String?
    let paymentMethodId : String?
    let updatedAt : String?
    let userId : Int?


    enum CodingKeys: String, CodingKey {
        case brand = "brand"
        case clientSecret = "client_secret"
        case country = "country"
        case createdAt = "created_at"
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case id = "id"
        case lastFour = "last_four"
        case paymentMethodId = "payment_method_id"
        case updatedAt = "updated_at"
        case userId = "user_id"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        brand = try values.decodeIfPresent(String.self, forKey: .brand)
        clientSecret = try values.decodeIfPresent(String.self, forKey: .clientSecret)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        expMonth = try values.decodeIfPresent(String.self, forKey: .expMonth)
        expYear = try values.decodeIfPresent(String.self, forKey: .expYear)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        lastFour = try values.decodeIfPresent(String.self, forKey: .lastFour)
        paymentMethodId = try values.decodeIfPresent(String.self, forKey: .paymentMethodId)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
    }
}

struct TopupResponse : Codable {

    let about : String?
    let address : String?
    let averageRating : Float?
    let clientId : String?
    let connectAccountId : String?
    let createdAt : String?
    let email : String?
    let id : Int?
    let image : String?
    let imageUrl : String?
    let isApproved : Int?
    let isBlocked : Int?
    let isSocialLogin : Int?
    let isVerified : Int?
    let latitude : String?
    let longitude : String?
    let mediumImageUrl : String?
    let name : String?
    let phone : String?
    let pushNotification : Int?
    let role : Int?
    let smallImageUrl : String?
    let socialPlatform : String?
    let stripeCustomerId : String?
    let token : String?
    let totalReviews : Int?
    let updatedAt : String?
    let verificationCode : String?
    let walletAmount : Double?
    let isDeleted: Int?
    let deleteReason: String?


    enum CodingKeys: String, CodingKey {
        case about = "about"
        case address = "address"
        case averageRating = "average_rating"
        case clientId = "client_id"
        case connectAccountId = "connect_account_id"
        case createdAt = "created_at"
        case email = "email"
        case id = "id"
        case image = "image"
        case imageUrl = "image_url"
        case isApproved = "is_approved"
        case isBlocked = "is_blocked"
        case isSocialLogin = "is_social_login"
        case isVerified = "is_verified"
        case latitude = "latitude"
        case longitude = "longitude"
        case mediumImageUrl = "medium_image_url"
        case name = "name"
        case phone = "phone"
        case pushNotification = "push_notification"
        case role = "role"
        case smallImageUrl = "small_image_url"
        case socialPlatform = "social_platform"
        case stripeCustomerId = "stripe_customer_id"
        case token = "token"
        case totalReviews = "total_reviews"
        case updatedAt = "updated_at"
        case verificationCode = "verification_code"
        case walletAmount = "wallet_amount"
        case isDeleted = "is_deleted"
        case deleteReason = "delete_reason"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        about = try values.decodeIfPresent(String.self, forKey: .about)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        averageRating = try values.decodeIfPresent(Float.self, forKey: .averageRating)
        clientId = try values.decodeIfPresent(String.self, forKey: .clientId)
        connectAccountId = try values.decodeIfPresent(String.self, forKey: .connectAccountId)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        isApproved = try values.decodeIfPresent(Int.self, forKey: .isApproved)
        isBlocked = try values.decodeIfPresent(Int.self, forKey: .isBlocked)
        isSocialLogin = try values.decodeIfPresent(Int.self, forKey: .isSocialLogin)
        isVerified = try values.decodeIfPresent(Int.self, forKey: .isVerified)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        mediumImageUrl = try values.decodeIfPresent(String.self, forKey: .mediumImageUrl)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        pushNotification = try values.decodeIfPresent(Int.self, forKey: .pushNotification)
        role = try values.decodeIfPresent(Int.self, forKey: .role)
        smallImageUrl = try values.decodeIfPresent(String.self, forKey: .smallImageUrl)
        socialPlatform = try values.decodeIfPresent(String.self, forKey: .socialPlatform)
        stripeCustomerId = try values.decodeIfPresent(String.self, forKey: .stripeCustomerId)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        totalReviews = try values.decodeIfPresent(Int.self, forKey: .totalReviews)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        verificationCode = try values.decodeIfPresent(String.self, forKey: .verificationCode)
        walletAmount = try values.decodeIfPresent(Double.self, forKey: .walletAmount)
        isDeleted = try values.decodeIfPresent(Int.self, forKey: .isDeleted)
        deleteReason = try values.decodeIfPresent(String.self, forKey: .deleteReason)
    }
}

struct PushNotificationModel : Codable {

    var message : String?
    var notifiableId : Int?
    var notificationId : Int?
    var refId : Int?
    var referencedUserId : Int?
    var role : Int?
    var title : String?
    var type : Int?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case notifiableId = "notifiable_id"
        case notificationId = "notification_id"
        case refId = "ref_id"
        case referencedUserId = "referenced_user_id"
        case role = "role"
        case title = "title"
        case type = "type"
    }
    init(message : String?, notifiableId : Int?, notificationId : Int?, refId : Int?, referencedUserId : Int?, role : Int?, title : String?, type : Int?) {
        self.message = message
        self.notifiableId = notifiableId
        self.notificationId = notificationId
        self.refId = refId
        self.referencedUserId = referencedUserId
        self.role = role
        self.title = title
        self.type = type
    }
}

struct PendingJobs : Codable {

    let jobsCount : Int?


    enum CodingKeys: String, CodingKey {
        case jobsCount = "jobs_count"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        jobsCount = try values.decodeIfPresent(Int.self, forKey: .jobsCount)
    }
}
struct OrderResponse: Codable {
    enum CodingKeys: String, CodingKey {
      case message
      case status
      case orderData = "data"
    }

    var message: String?
    var status: Bool?
    var orderData: OrderData?
}
struct OrderData: Codable {
    var orderId: String?
    var approvalUrl: String?
}
