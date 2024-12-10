//
//  CustomerSelectDateTimeRepository.swift
//  MoCuts
//
//  Created by Ahmed Khan on 15/11/2021.
//

import Foundation


class CustomerSelectDateTimeRepository {
    func getTimeSlotsByID(userID: Int, date: String = "", duration: String = "", successCompletion: @escaping (_ response: GenericArrayResponse<TimeSlot>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void){
        
        let appendingURL = "?user_id=\(userID)&date=\(date)&duration=\(duration)"
        
        
        Router.APIRouter(endPoint: .availabilitiesByDate, appendingURL: appendingURL, parameters: nil, method: .get) { (response) in
            
            switch response {
            
            case .success(let success):
                
                guard let availabilities = try? JSONDecoder().decode(GenericArrayResponse<TimeSlot>.self, from: success.data) else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if availabilities.status {
                    successCompletion(availabilities)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: availabilities.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
}
