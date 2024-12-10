//
//  CustomerSelectDateTimeModels.swift
//  MoCuts
//
//  Created by Ahmed Khan on 15/11/2021.
//

import Foundation
struct TimeSlot : Codable {

    let createdAt : String?
    let day : Int?
    let duration : Int?
    let endTime : String?
    let id : Int?
    let isActive : Int?
    let isDeleted : Int?
    let startTime : String?
    let updatedAt : String?
    let userId : Int?


    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case day = "day"
        case duration = "duration"
        case endTime = "end_time"
        case id = "id"
        case isActive = "is_active"
        case isDeleted = "is_deleted"
        case startTime = "start_time"
        case updatedAt = "updated_at"
        case userId = "user_id"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        day = try values.decodeIfPresent(Int.self, forKey: .day)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
        endTime = try values.decodeIfPresent(String.self, forKey: .endTime)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        isActive = try values.decodeIfPresent(Int.self, forKey: .isActive)
        isDeleted = try values.decodeIfPresent(Int.self, forKey: .isDeleted)
        startTime = try values.decodeIfPresent(String.self, forKey: .startTime)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
    }
}
