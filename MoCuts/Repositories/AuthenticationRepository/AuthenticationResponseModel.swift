//
//  UserModels.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 6/26/19.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import Foundation


struct ConstantModel : Codable {
    let createdAt : String?
    let id : Int?
    let instanceType : Int?
    let text : String?
    let updatedAt : String?
    let value : Int?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id = "id"
        case instanceType = "instance_type"
        case text = "text"
        case updatedAt = "updated_at"
        case value = "value"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = (try? values.decodeIfPresent(String.self, forKey: .createdAt)) ?? ""
        id = (try? values.decodeIfPresent(Int.self, forKey: .id)) ?? -1
        instanceType = (try? values.decodeIfPresent(Int.self, forKey: .instanceType)) ?? -1
        text = (try? values.decodeIfPresent(String.self, forKey: .text)) ?? ""
        updatedAt = (try? values.decodeIfPresent(String.self, forKey: .updatedAt)) ?? ""
        value = (try? values.decodeIfPresent(Int.self, forKey: .value)) ?? -1
    }
}

class UserModel : Codable {
    
    var id : Int
    var name : String
    var email : String
    var about : String?
    var phone : String?
    var image : String?
    var address : String?
    var latitude : String?
    var longitude : String?
    var stripe_customer_id : String?
    var connect_account_id : String?
    var average_rating : Int
    var wallet_amount : Int
    var social_platform : String?
    var client_id : String?
    var token : String?
    var verification_code : String?
    var push_notification : Int
    var is_social_login : Int
    var is_verified : Int
    var is_approved : Int
    var created_at : String?
    var updated_at : String?
    var role : Int
    var access_token : AccessToken?
    var image_url : String?
    var medium_image_url : String?
    var small_image_url : String?
    
    

}

class AccessToken : Codable {
    var type : String
    var token : String
    var refreshToken : String
}
