//
//  CustomerHomeResponseModels.swift
//  MoCuts
//
//  Created by Ahmed Khan on 02/11/2021.
//

import Foundation

struct BarberListModel : Codable {

    let barbers : [BarberModel]?
    let lastPage : Int?
    let page : Int?
    let perPage : Int?
    let total : Int?


    enum CodingKeys: String, CodingKey {
        case barbers = "data"
        case lastPage = "lastPage"
        case page = "page"
        case perPage = "perPage"
        case total = "total"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        barbers = try values.decodeIfPresent([BarberModel].self, forKey: .barbers)
        lastPage = try values.decodeIfPresent(Int.self, forKey: .lastPage)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        perPage = try values.decodeIfPresent(Int.self, forKey: .perPage)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }


}

struct BarberModel : Codable {

    var about : String?
    var address : String?
    var averageRating : Double?
    var clientId : String?
    var connectAccountId : String?
    var createdAt : String?
    var email : String?
    var id : Int?
    var image : String?
    var imageUrl : String?
    var isApproved : Int?
    var isBlocked : Int?
    var isSocialLogin : Int?
    var isVerified : Int?
    var latitude : String?
    var longitude : String?
    var mediumImageUrl : String?
    var name : String?
    var phone : String?
    var pushNotification : Int?
    var smallImageUrl : String?
    var socialPlatform : String?
    var stripeCustomerId : String?
    var token : String?
    var totalReviews : Int?
    var updatedAt : String?
    var verificationCode : String?
    var walletAmount : Double?


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
        averageRating = try values.decodeIfPresent(Double.self, forKey: .averageRating)
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
        walletAmount = try values.decodeIfPresent(Double.self, forKey: .walletAmount)
    }


}
