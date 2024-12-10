//
//  GalleryResponseModel.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 13/09/2021.
//

import Foundation

struct GalleryResponseModel : Codable {
    var id : Int
    var user_id : Int
    var media_type : Int?
    var media : String?
    var created_at : String?
    var updated_at : String?
    var media_url : String?
    var medium_media_url : String?
    var small_media_url : String?
    var media_from: Int?
}
