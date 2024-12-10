////
////  Adress.swift
////  MoCuts
////
////  Created by Mohammad Zawwar on 19/08/2020.
////  Copyright © 2020 Appiskey. All rights reserved.
////
//
//import Foundation
//import SwiftyJSON
//
//class AddressAPI {
//    
//    func getAddress(_ address: Address,completion: (String) -> ()) {
//
//        var addressText: String = ""
//
//        if address.city != "" {
//            addressText += address.city
//            if address.state != "" {
//                addressText += ", \(address.state)"
//            }
//        } else if address.city != "" {
//            addressText = address.city
//        } else {
//            addressText = address.country
//        }
//
//        if addressText != "" {
//            completion(addressText)
//        }
//        else {
//            completion("")
////            self.getAddressByGeoPoints(latitude: latitude, longitude: longitude, completion: {
////                (address, error, isSuccess) in
////
////            })
//        }
//
//    }
//    func getAddressByGeoPoints(latitude: String, longitude: String, completion: @escaping (Address?,String?, Bool) -> Void) {
//
//        if latitude == "" && longitude == "" {
//            completion(nil, "Location is empty" ,true)
//            return
//        }
//
//        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=" + "\(MapViewController.placeKey)"
//
//        let session = URLSession.shared
//
//        var request = URLRequest(url: URL(string: url)! , cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 12.0)
//
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        let task = session.dataTask(with: request, completionHandler: { data, response, error in
//            guard error == nil else {
//                if error?._code == NSURLErrorTimedOut {
//
////                    let errorResponse = Failure.init(message: "Request timed out.",
////                                                     state: ResponseState.timeOut,
////                                                    data: nil,
////                                                    code: 422)
//                    completion(nil ,"Request timed out.", false)
//                }
//                else if error?._code == NSURLErrorNotConnectedToInternet || error?._code == NSURLErrorNetworkConnectionLost{
////                    let errorResponse = Failure.init(message: "Please check your internet connection.",
////                                                     state: ResponseState.unknown,
////                                                     data: nil,
////                                                     code: 400)
//                    completion(nil ,"Please check your internet connection.", false)
//
//                }
//                else {
//
//                    completion(nil ,"Sorry, something went wrong.", false)
//
//                }
//
//                return
//            }
//
//            guard let data = data else {
//
////                let errorResponse = ServerResponse.failure(Failure(message: "Sorry, something went wrong.", code: .unknown))
//
//                completion(nil ,"Sorry, something went wrong.", false)
//
//                return
//            }
//
//            do {
//                let jsonResult: Any = (try JSONSerialization.jsonObject(with: data, options:
//                    JSONSerialization.ReadingOptions.mutableContainers))
//
//                if let responseJSON = jsonResult as? [String: Any] {
//                    if let results = responseJSON["results"] as? NSArray, results.count > 0 {
//                        if let addressDic = results[0] as? [String: Any] {
//
//                            let obj = Address()
//
//                            if let addComponenet = addressDic["address_components"] as? [[String:Any]] {
//
//                                for component in addComponenet {
//                                    if let type = component["types"] as? [String] {
//                                        for typeName in type {
//                                            if typeName == "political" {
//                                                obj.address = component["short_name"] as? String ?? ""
//                                            }
//                                            if typeName == "locality" {
//                                                obj.city = component["short_name"] as? String ?? ""
//                                            }
//                                            if typeName == "administrative_area_level_1" {
//                                                obj.state = component["short_name"] as? String ?? ""
//                                            }
//                                            if typeName == "country" {
//
//                                                 obj.country = component["long_name"] as? String ?? ""
//
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                            obj.latitude = Double(latitude)!
//                            obj.longitude = Double(longitude)!
//                            completion(obj,nil, true)
//                        }
//                    }
//                }
//            } catch {
//
//            }
//
//
//        })
//
//        task.resume()
//    }
//}
//class Address {
//
//    var country:String = ""
//    var state:String = ""
//    var city:String = ""
//    var zip:String = ""
//    var address:String = ""
//    var latitude:Double = 0.0
//    var longitude:Double = 0.0
//
//    init() {}
//
//    init(
//        country:String,
//        state:String,
//        city:String,
//        zip:String,
//        address:String,
//        latitude:Double,
//        longitude:Double
//
//        ) {
//
//
//        self.country = country
//        self.state = state
//        self.city = city
//        self.zip = zip
//        self.address = address
//        self.latitude = latitude
//        self.longitude = longitude
//
//    }
//
//    init(fromJson json: JSON){
//        address = json["address"].stringValue
//        city = json["city"].stringValue
//        country = json["country"].stringValue
//        latitude = Double(json["latitude"].stringValue) ?? 0.0
//        longitude = Double(json["longitude"].stringValue) ?? 0.0
//        state = json["state"].stringValue
//        zip = json["zip"].stringValue
//    }
//
//}
//
