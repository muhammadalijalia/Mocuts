//
//  CustomerBarberServicesModels.swift
//  MoCuts
//
//  Created by Ahmed Khan on 10/11/2021.
//

import Foundation

struct CustomerServiceModel : Codable {

    let createdAt : String?
    let duration : Int?
    let id : Int?
    let isActive : Int?
    let name : String?
    let price : Int?
    let updatedAt : String?
    let userId : Int?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case duration = "duration"
        case id = "id"
        case isActive = "is_active"
        case name = "name"
        case price = "price"
        case updatedAt = "updated_at"
        case userId = "user_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        isActive = try values.decodeIfPresent(Int.self, forKey: .isActive)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
    }
}
