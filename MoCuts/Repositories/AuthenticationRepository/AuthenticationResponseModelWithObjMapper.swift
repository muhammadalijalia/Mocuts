//
//  AuthenticationResponseModelWithObjMapper.swift
//  MoCuts
//
//  Created by Saif Ahmed  on 27/09/2021.
//

import Foundation
import UIKit

struct User_Model : Codable {
    var id : Int?
    var name : String?
    var email : String?
    var about : String?
    var phone : String?
    var image : String?
    var address : String?
    var latitude : String?
    var longitude : String?
    var stripe_customer_id : String?
    var connect_account_id : String?
    var average_rating : Double?
    var total_reviews : Int?
    var wallet_amount : Double?
    var social_platform : String?
    var client_id : String?
    var token : String?
    var verification_code : String?
    var push_notification : Int?
    var is_social_login : Int?
    var is_verified : Int?
    var is_approved : Int?
    var is_blocked : Int?
    var created_at : String?
    var updated_at : String?
    var role : Int?
    var image_url : String?
    var medium_image_url : String?
    var small_image_url : String?
    var services : [Services]?
    var attachments : [Attachments]?
    var reviews : [Reviews]?
    var availabilities : [Availabilities]?
    var access_token : Access_token?
    var all_time_with_draw: Int?
    var current_month_with_draw: Int?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case email = "email"
        case about = "about"
        case phone = "phone"
        case image = "image"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case stripe_customer_id = "stripe_customer_id"
        case connect_account_id = "connect_account_id"
        case average_rating = "average_rating"
        case total_reviews = "total_reviews"
        case wallet_amount = "wallet_amount"
        case social_platform = "social_platform"
        case client_id = "client_id"
        case token = "token"
        case verification_code = "verification_code"
        case push_notification = "push_notification"
        case is_social_login = "is_social_login"
        case is_verified = "is_verified"
        case is_approved = "is_approved"
        case is_blocked = "is_blocked"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case role = "role"
        case image_url = "image_url"
        case medium_image_url = "medium_image_url"
        case small_image_url = "small_image_url"
        case services = "services"
        case attachments = "attachments"
        case reviews = "reviews"
        case availabilities = "availabilities"
        case access_token = "access_token"
        case all_time_with_draw = "all_time_with_draw"
        case current_month_with_draw = "current_month_with_draw"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        about = try values.decodeIfPresent(String.self, forKey: .about)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        stripe_customer_id = try values.decodeIfPresent(String.self, forKey: .stripe_customer_id)
        connect_account_id = try values.decodeIfPresent(String.self, forKey: .connect_account_id)
        average_rating = try values.decodeIfPresent(Double.self, forKey: .average_rating)
        total_reviews = try values.decodeIfPresent(Int.self, forKey: .total_reviews)
        wallet_amount = try values.decodeIfPresent(Double.self, forKey: .wallet_amount)
        social_platform = try values.decodeIfPresent(String.self, forKey: .social_platform)
        client_id = try values.decodeIfPresent(String.self, forKey: .client_id)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        verification_code = try values.decodeIfPresent(String.self, forKey: .verification_code)
        push_notification = try values.decodeIfPresent(Int.self, forKey: .push_notification)
        is_social_login = try values.decodeIfPresent(Int.self, forKey: .is_social_login)
        is_verified = try values.decodeIfPresent(Int.self, forKey: .is_verified)
        is_approved = try values.decodeIfPresent(Int.self, forKey: .is_approved)
        is_blocked = try values.decodeIfPresent(Int.self, forKey: .is_blocked)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        role = try values.decodeIfPresent(Int.self, forKey: .role)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        medium_image_url = try values.decodeIfPresent(String.self, forKey: .medium_image_url)
        small_image_url = try values.decodeIfPresent(String.self, forKey: .small_image_url)
        services = try values.decodeIfPresent([Services].self, forKey: .services)
        attachments = try values.decodeIfPresent([Attachments].self, forKey: .attachments)
        reviews = try values.decodeIfPresent([Reviews].self, forKey: .reviews)
        availabilities = try values.decodeIfPresent([Availabilities].self, forKey: .availabilities)
        access_token = try values.decodeIfPresent(Access_token.self, forKey: .access_token)
        all_time_with_draw = try values.decodeIfPresent(Int.self, forKey: .all_time_with_draw)
        current_month_with_draw = try values.decodeIfPresent(Int.self, forKey: .current_month_with_draw)
    }
}

struct Access_token : Codable {
    var type : String?
    var token : String?
    var refreshToken : String?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case token = "token"
        case refreshToken = "refreshToken"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        refreshToken = try values.decodeIfPresent(String.self, forKey: .refreshToken)
    }

}


struct Services : Codable {
    let id : Int?
    let user_id : Int?
    let name : String?
    let price : Int?
    let duration : Int?
    var is_active : Int?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case name = "name"
        case price = "price"
        case duration = "duration"
        case is_active = "is_active"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
        is_active = try values.decodeIfPresent(Int.self, forKey: .is_active)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}


struct Availabilities : Codable {
    let day : Int?
    var availabilities : [Availability]?

    enum CodingKeys: String, CodingKey {

        case day = "day"
        case availabilities = "availabilities"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        day = try values.decodeIfPresent(Int.self, forKey: .day)
        availabilities = try values.decodeIfPresent([Availability].self, forKey: .availabilities)
    }

}

struct Attachments : Codable {
    let id : Int?
    let user_id : Int?
    let media_type : Int?
    let media : String?
    let created_at : String?
    let updated_at : String?
    let media_url : String?
    let medium_media_url : String?
    let small_media_url : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case media_type = "media_type"
        case media = "media"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case media_url = "media_url"
        case medium_media_url = "medium_media_url"
        case small_media_url = "small_media_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        media_type = try values.decodeIfPresent(Int.self, forKey: .media_type)
        media = try values.decodeIfPresent(String.self, forKey: .media)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        media_url = try values.decodeIfPresent(String.self, forKey: .media_url)
        medium_media_url = try values.decodeIfPresent(String.self, forKey: .medium_media_url)
        small_media_url = try values.decodeIfPresent(String.self, forKey: .small_media_url)
    }

}

struct Reviews : Codable {
    let id : Int?
    let from_id : Int?
    let to_id : Int?
    let job_id : Int?
    let review : String?
    let rating : Double?
    let is_active : Int?
    let created_at : String?
    let updated_at : String?
    let from : From?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case from_id = "from_id"
        case to_id = "to_id"
        case job_id = "job_id"
        case review = "review"
        case rating = "rating"
        case is_active = "is_active"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case from = "from"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        from_id = try values.decodeIfPresent(Int.self, forKey: .from_id)
        to_id = try values.decodeIfPresent(Int.self, forKey: .to_id)
        job_id = try values.decodeIfPresent(Int.self, forKey: .job_id)
        review = try values.decodeIfPresent(String.self, forKey: .review)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
        is_active = try values.decodeIfPresent(Int.self, forKey: .is_active)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        from = try values.decodeIfPresent(From.self, forKey: .from)
    }

}


struct From : Codable {
    let id : Int?
    let name : String?
    let email : String?
    let about : String?
    let phone : String?
    let image : String?
    let address : String?
    let latitude : String?
    let longitude : String?
    let stripe_customer_id : String?
    let connect_account_id : String?
    let average_rating : Double?
    let total_reviews : Int?
    let wallet_amount : Double?
    let social_platform : String?
    let client_id : String?
    let token : String?
    let verification_code : String?
    let push_notification : Int?
    let is_social_login : Int?
    let is_verified : Int?
    let is_approved : Int?
    let is_blocked : Int?
    let created_at : String?
    let updated_at : String?
    let image_url : String?
    let medium_image_url : String?
    let small_image_url : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case email = "email"
        case about = "about"
        case phone = "phone"
        case image = "image"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case stripe_customer_id = "stripe_customer_id"
        case connect_account_id = "connect_account_id"
        case average_rating = "average_rating"
        case total_reviews = "total_reviews"
        case wallet_amount = "wallet_amount"
        case social_platform = "social_platform"
        case client_id = "client_id"
        case token = "token"
        case verification_code = "verification_code"
        case push_notification = "push_notification"
        case is_social_login = "is_social_login"
        case is_verified = "is_verified"
        case is_approved = "is_approved"
        case is_blocked = "is_blocked"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case image_url = "image_url"
        case medium_image_url = "medium_image_url"
        case small_image_url = "small_image_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        about = try values.decodeIfPresent(String.self, forKey: .about)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        stripe_customer_id = try values.decodeIfPresent(String.self, forKey: .stripe_customer_id)
        connect_account_id = try values.decodeIfPresent(String.self, forKey: .connect_account_id)
        average_rating = try values.decodeIfPresent(Double.self, forKey: .average_rating)
        total_reviews = try values.decodeIfPresent(Int.self, forKey: .total_reviews)
        wallet_amount = try values.decodeIfPresent(Double.self, forKey: .wallet_amount)
        social_platform = try values.decodeIfPresent(String.self, forKey: .social_platform)
        client_id = try values.decodeIfPresent(String.self, forKey: .client_id)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        verification_code = try values.decodeIfPresent(String.self, forKey: .verification_code)
        push_notification = try values.decodeIfPresent(Int.self, forKey: .push_notification)
        is_social_login = try values.decodeIfPresent(Int.self, forKey: .is_social_login)
        is_verified = try values.decodeIfPresent(Int.self, forKey: .is_verified)
        is_approved = try values.decodeIfPresent(Int.self, forKey: .is_approved)
        is_blocked = try values.decodeIfPresent(Int.self, forKey: .is_blocked)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        medium_image_url = try values.decodeIfPresent(String.self, forKey: .medium_image_url)
        small_image_url = try values.decodeIfPresent(String.self, forKey: .small_image_url)
    }

}
