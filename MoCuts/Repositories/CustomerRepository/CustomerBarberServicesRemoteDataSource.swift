//
//  CustomerBarberServicesRemoteDataSource.swift
//  MoCuts
//
//  Created by Ahmed Khan on 10/11/2021.
//

import Foundation
import SwiftyJSON

struct CustomerBarberServicesRemoteDataSource {
    
    func getServices(userId: String, successCompletion: @escaping (_ response: GenericResponse<[CustomerServiceModel]>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        Router.APIRouter(endPoint: .addService, appendingURL: "?user_id=\(userId)", parameters: [:], method: .get, completion: { response in
            switch(response) {
            case .success(let success):
                guard let servicesListResponse = try? JSONDecoder().decode(GenericResponse<[CustomerServiceModel]>.self, from: success.data) else {
                    print("Parsing failed.")
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if servicesListResponse.status {
                    successCompletion(servicesListResponse)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: servicesListResponse.message ?? "No message returned"])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo: [NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        })
    }
    
    
    
    
    func requestService(barberId: String, availabilityId: String, date: String, items: [String], successCompletion: @escaping (_ response: GenericResponse<BarberModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        var params = [String: Any]()
        var serviceIds = [[String: String]]()
        params["barber_id"] = barberId
        params["availability_id"] = availabilityId
        params["date"] = date
        
        for item in items {
            serviceIds.append(["service_id" : item])
        }
        params["items"] = serviceIds
        
        Router.APIRouter(endPoint: .getJobs, appendingURL: "", parameters: params, method: .post, completion: { response in
            switch(response) {
            case .success(let success):
                guard let servicesListResponse = try? JSONDecoder().decode(GenericResponse<BarberModel>.self, from: success.data) else {
                    print("Parsing failed.")
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if servicesListResponse.status {
                    successCompletion(servicesListResponse)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: servicesListResponse.message ?? "No message returned"])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo: [NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        })
    }
}

struct JobRequestParams : Codable {

    let serviceIds : [JobRequestServiceId]?
    let barberId : String?
    let availabilityId : String?
    let date : String?

    enum CodingKeys: String, CodingKey {
        case barberId = "barber_id"
        case availabilityId = "availability_id"
        case date = "date"
        case serviceIds = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        serviceIds = try values.decodeIfPresent([JobRequestServiceId].self, forKey: .serviceIds)
        barberId = try values.decodeIfPresent(String.self, forKey: .barberId)
        availabilityId = try values.decodeIfPresent(String.self, forKey: .availabilityId)
        date = try values.decodeIfPresent(String.self, forKey: .date)
    }
}

struct JobRequestServiceId : Codable {
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "service_id"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }
}
