//
//  BarberWalletResponseModels.swift
//  MoCuts
//
//  Created by Ahmed Khan on 28/10/2021.
//

import Foundation

//MARK: ConnectLinkResponse
struct ConnectLinkResponse : Codable {

    let created : Int?
    let expiresAt : Int?
    let object : String?
    let url : String?


    enum CodingKeys: String, CodingKey {
        case created = "created"
        case expiresAt = "expires_at"
        case object = "object"
        case url = "url"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        created = try values.decodeIfPresent(Int.self, forKey: .created)
        expiresAt = try values.decodeIfPresent(Int.self, forKey: .expiresAt)
        object = try values.decodeIfPresent(String.self, forKey: .object)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
}

//MARK: WithdrawalResponseItem
struct WithdrawalResponseItem : Codable {

    let about : String?
    let address : String?
    let allTimeWithDraw : Int?
    let averageRating : Float?
    let clientId : String?
    let connectAccountId : String?
    let createdAt : String?
    let currentMonthWithDraw : Int?
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
    let walletAmount : Float?


    enum CodingKeys: String, CodingKey {
        case about = "about"
        case address = "address"
        case allTimeWithDraw = "all_time_with_draw"
        case averageRating = "average_rating"
        case clientId = "client_id"
        case connectAccountId = "connect_account_id"
        case createdAt = "created_at"
        case currentMonthWithDraw = "current_month_with_draw"
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
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        about = try values.decodeIfPresent(String.self, forKey: .about)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        allTimeWithDraw = try values.decodeIfPresent(Int.self, forKey: .allTimeWithDraw)
        averageRating = try values.decodeIfPresent(Float.self, forKey: .averageRating)
        clientId = try values.decodeIfPresent(String.self, forKey: .clientId)
        connectAccountId = try values.decodeIfPresent(String.self, forKey: .connectAccountId)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        currentMonthWithDraw = try values.decodeIfPresent(Int.self, forKey: .currentMonthWithDraw)
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
        walletAmount = try values.decodeIfPresent(Float.self, forKey: .walletAmount)
    }
}
