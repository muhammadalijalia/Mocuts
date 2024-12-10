//
//  CustomerBarberReviewModel.swift
//  MoCuts
//
//  Created by Ahmed Khan on 09/11/2021.
//

import Foundation

struct BarberReviewResponse : Codable {

    let data : [ReviewItem]?
    let lastPage : Int?
    let page : Int?
    let perPage : Int?
    let total : Int?


    enum CodingKeys: String, CodingKey {
        case data = "data"
        case lastPage = "lastPage"
        case page = "page"
        case perPage = "perPage"
        case total = "total"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([ReviewItem].self, forKey: .data)
        lastPage = try values.decodeIfPresent(Int.self, forKey: .lastPage)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        perPage = try values.decodeIfPresent(Int.self, forKey: .perPage)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }
}

struct ReviewItem : Codable {

    let createdAt : String?
    let from : ReviewFrom?
    let fromId : Int?
    let id : Int?
    let isActive : Int?
    let jobId : Int?
    let rating : Double?
    let review : String?
    let toId : Int?
    let updatedAt : String?
    let data : [Data]?
    let lastPage : Int?
    let page : Int?
    let perPage : Int?
    let total : Int?


    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case from
        case fromId = "from_id"
        case id = "id"
        case isActive = "is_active"
        case jobId = "job_id"
        case rating = "rating"
        case review = "review"
        case toId = "to_id"
        case updatedAt = "updated_at"
        case data = "data"
        case lastPage = "lastPage"
        case page = "page"
        case perPage = "perPage"
        case total = "total"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        from = try values.decodeIfPresent(ReviewFrom.self, forKey: .from)
        fromId = try values.decodeIfPresent(Int.self, forKey: .fromId)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        isActive = try values.decodeIfPresent(Int.self, forKey: .isActive)
        jobId = try values.decodeIfPresent(Int.self, forKey: .jobId)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
        review = try values.decodeIfPresent(String.self, forKey: .review)
        toId = try values.decodeIfPresent(Int.self, forKey: .toId)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        data = try values.decodeIfPresent([Data].self, forKey: .data)
        lastPage = try values.decodeIfPresent(Int.self, forKey: .lastPage)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        perPage = try values.decodeIfPresent(Int.self, forKey: .perPage)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }
}

struct ReviewFrom : Codable {

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
    let smallImageUrl : String?
    let socialPlatform : String?
    let stripeCustomerId : String?
    let token : String?
    let totalReviews : Int?
    let updatedAt : String?
    let verificationCode : String?
    let walletAmount : Float?


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
        case smallImageUrl = "small_image_url"
        case socialPlatform = "social_platform"
        case stripeCustomerId = "stripe_customer_id"
        case token = "token"
        case totalReviews = "total_reviews"
        case updatedAt = "updated_at"
        case verificationCode = "verification_code"
        case walletAmount = "wallet_amount"
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
        smallImageUrl = try values.decodeIfPresent(String.self, forKey: .smallImageUrl)
        socialPlatform = try values.decodeIfPresent(String.self, forKey: .socialPlatform)
        stripeCustomerId = try values.decodeIfPresent(String.self, forKey: .stripeCustomerId)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        totalReviews = try values.decodeIfPresent(Int.self, forKey: .totalReviews)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        verificationCode = try values.decodeIfPresent(String.self, forKey: .verificationCode)
        walletAmount = try values.decodeIfPresent(Float.self, forKey: .walletAmount)
    }
}
