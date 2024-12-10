//
//  BarberHomeRepository.swift
//  MoCuts
//
//  Created by Saif Ahmed  on 29/09/2021.
//

import Foundation
import Reachability

class BarberHomeRepository: BaseRepository {
    
    private var remoteDataSource: BarberHomeRemoteDataSource!
    
    override init() {
        remoteDataSource = BarberHomeRemoteDataSource()
    }
    
    func getJobs(barberID: String, isRequested: Bool = false, isToday: Bool = false, serviceHistory: Bool = false, isUpcoming: Bool = false, month: String = "", year: String = "",query: String = "", limit: Int, offset: Int, successCompletion: @escaping (_ response: GenericResponse<BarberHomeModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        var url: String = "?barber_id=\(barberID)&limit=\(limit)&offset=\(offset)&month=\(month)&year=\(year)&query=\(query)"
        
        if isRequested {
            url = url + "&status=5"
             print("================= \(url) =================")
            
        } else if isToday {
            let todayDate = Utilities.formateDate(Date(), dateFormat: "yyyy-MM-dd")
            
            url = url + "&date=\(todayDate)"
            print("================= \(url) =================")
            
        } else if isUpcoming {
            url = url + "&upcoming=1"
            
            print("================= \(url) =================")
        }
        else if serviceHistory
        {
            url = url + "&status=30"
            print("================= \(url) =================")
        }
        
        remoteDataSource.getJobs(appendingUrl: url) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func getJobsForEditProfile(barberId: String, successCompletion: @escaping (_ response: GenericResponse<BarberHomeModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        let url: String = "?barber_id=\(barberId)&limit=100&orderBy=date&sortBy=desc"
        
        remoteDataSource.getJobs(appendingUrl: url) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func getPendingJobs(successCompletion: @escaping (_ response: GenericResponse<PendingJobs>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        remoteDataSource.getPendingJobs() { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func getJob(jobId: String, successCompletion: @escaping (_ response: GenericResponse<BarberBaseModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        let url: String = "/\(jobId)"
        remoteDataSource.getJob(appendingUrl: url) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func getJobsForHistory(barberID: String, month: String = "", year: String = "",query: String = "", status: String = "", isFiltered: Int = 0, offset: Int, successCompletion: @escaping (_ response: GenericResponse<BarberHomeModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        let url: String = "?barber_id=\(barberID)&limit=10&offset=\(offset)&month=\(month)&year=\(year)&query=\(query)&status=\(status)&is_filtered=\(isFiltered)"
        print("================= \(url) =================")
        
        remoteDataSource.getJobs(appendingUrl: url) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func addBarberService(params: [String:Any], successCompletion: @escaping (_ response: GenericResponse<Services>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.addBarberService(dict: params) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func changeServiceStatus(serviceId: Int, isEnable: Bool, successCompletion: @escaping (_ response: GenericResponse<Services>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.changeServiceStatus(serviceID: serviceId, isEnable: isEnable) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func editService(serviceId: Int, params: [String:Any], successCompletion: @escaping (_ response: GenericResponse<Services>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.editService(serviceID: serviceId, params: params){ response in            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func deleteService(serviceId: Int, successCompletion: @escaping (_ response: GenericResponse<Services>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.deleteService(serviceID: serviceId){ response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func getBarberByID(barberID: String,successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void){
        
        let appendingURL = "/\(barberID)"
        
        Router.APIRouter(endPoint: .getBarberById, appendingURL: appendingURL, parameters: nil, method: .get) { (response) in
            
            switch response {
            
            case .success(let success):
                
                guard let userModel = try? JSONDecoder().decode(GenericResponse<User_Model>.self, from: success.data) else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if userModel.status {
                    successCompletion(userModel)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: userModel.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
    
    func editBarberProfile(name : String , phone : String , email : String , location : String , lat : String , long : String , about : String ,newImagesArray: [UIImage]?, profileImg: UIImage?, successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        let dict : [String : Any] = ["name":name,
                                     "phone":phone,
                                     "email": email,
                                     "address": location,
                                     "latitude": lat,
                                     "longitude": long,
                                     "about": about
                                    ]
        
        remoteDataSource.editBarberProfile(dict: dict,newImagesArray: newImagesArray, profileImg: profileImg) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func removeBarberGaleryImage(id: Int, successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void)
    {
        let dict : [String : Any] = ["ids" : [id]]
        
        remoteDataSource.removeBarberGaleryPicture(dict: dict) { response in
            successCompletion(response)
        } failureCompletion: { (error) in
            failureCompletion(error)
        }

    }
    
    
    func addTimeSlot(params: [String:Any], successCompletion: @escaping (_ response: GenericResponse<Availability_String>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.addTimeSlot(dict: params) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    
    func getTimeSlotsByID(userID: Int, successCompletion: @escaping (_ response: GenericArrayResponse<Availabilities>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void){
        
        let appendingURL = "?user_id=\(userID)"
        
        Router.APIRouter(endPoint: .availabilities, appendingURL: appendingURL, parameters: nil, method: .get) { (response) in
            
            switch response {
            
            case .success(let success):
                
                guard let availabilities = try? JSONDecoder().decode(GenericArrayResponse<Availabilities>.self, from: success.data) else {
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
    
    func editTimeSlot(slotId: Int, params: [String:Any], successCompletion: @escaping (_ response: GenericResponse<Availability>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.editTimeSlot(slotID: slotId, params: params){ response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func deleteTimeSlot(slotID: Int, successCompletion: @escaping (_ response: GenericResponse<Availability>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.deleteService(slotID: slotID){ response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func changeSlotStatus(slotID: Int, isEnable: Bool, successCompletion: @escaping (_ response: GenericResponse<Availability>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.changeSlotStatus(serviceID: slotID, isEnable: isEnable) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func acceptService(serviceID: Int, params: [String:Any],successCompletion: @escaping (_ response: GenericResponse<Availability>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.acceptService(serviceID: serviceID,params: params) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func getNotifications(offset:Int = 1, successCompletion: @escaping (_ response: GenericResponse<NotificationsResponseItem>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        let url: String = "?offset=\(offset)"
        remoteDataSource.getNotifications(appendingURL: url) {
            response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func markNotificationAsRead(notificationId: String, successCompletion: @escaping (_ response: GenericResponse<NotificationsResponseItem>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        remoteDataSource.markNotificationAsRead(notificationId: notificationId) {
            response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func getWithdrawalsHistory(appendingURL: String = "" , successCompletion: @escaping (_ response: GenericResponse<WithdrawHistoryResponseItem>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.getWithdrawalsHistory(appendingURL: appendingURL) {
            response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
}
