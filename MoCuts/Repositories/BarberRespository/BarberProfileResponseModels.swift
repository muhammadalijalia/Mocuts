//
//  BarberProfileResponseModels.swift
//  MoCuts
//
//  Created by Ahmed Khan on 29/10/2021.
//

import Foundation
struct ReviewResponse : Codable {

    let createdAt : String?
    let fromId : Int?
    let id : Int?
    let jobId : Int?
    let rating : Double?
    let review : String?
    let toId : Int?
    let updatedAt : String?


    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case fromId = "from_id"
        case id = "id"
        case jobId = "job_id"
        case rating = "rating"
        case review = "review"
        case toId = "to_id"
        case updatedAt = "updated_at"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        fromId = try values.decodeIfPresent(Int.self, forKey: .fromId)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        jobId = try values.decodeIfPresent(Int.self, forKey: .jobId)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
        review = try values.decodeIfPresent(String.self, forKey: .review)
        toId = try values.decodeIfPresent(Int.self, forKey: .toId)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}
