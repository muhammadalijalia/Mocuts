//
//  CustomerHomeFilterResponseModels.swift
//  MoCuts
//
//  Created by Ahmed Khan on 05/11/2021.
//

import Foundation

struct ServiceModel : Codable {

    let name : String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}
