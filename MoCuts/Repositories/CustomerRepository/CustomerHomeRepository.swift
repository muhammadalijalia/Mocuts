//
//  CustomerHomeRepository.swift
//  MoCuts
//
//  Created by Ahmed Khan on 02/11/2021.
//

import Foundation
import Reachability

class CustomerHomeRepository: BaseRepository {
    
    private var remoteDataSource: CustomerHomeRemoteDataSource!
    
    override init() {
        remoteDataSource = CustomerHomeRemoteDataSource()
    }
    
    func getBarbers(params: [String:Any], successCompletion: @escaping (_ response: GenericResponse<BarberListModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        var appendToUrlText = ""
        var i = 0
        for param in params {
            appendToUrlText += "\(i == 0 ? "?" : "&")\(param.key)=\(param.value)"
            i += 1
        }
        
        remoteDataSource.getBarbers(appendingUrl: appendToUrlText) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func getJobs(userId: String, isPending: Bool = false, isToday: Bool = false, serviceHistory: Bool = false, isUpcoming: Bool = false, limit: Int, offset: Int, successCompletion: @escaping (_ response: GenericResponse<BarberHomeModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        var url: String = "?user_id=\(userId)&limit=\(limit)&offset=\(offset)"
        
        if isPending {
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
    
    func getJobsForEditProfile(userId: String, successCompletion: @escaping (_ response: GenericResponse<BarberHomeModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        let url: String = "?user_id=\(userId)&limit=100&orderBy=date&sortBy=desc"
        
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
    
    func cancelService(serviceID: Int, params: [String:Any],successCompletion: @escaping (_ response: GenericResponse<Availability>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.cancelService(serviceID: serviceID,params: params) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func editProfile(name: String, phone: String, email: String, location: String, lat: String, long: String, profileImg: UIImage?, successCompletion: @escaping (_ response: GenericResponse<User_Model>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        let dict : [String : Any] = ["name":name,
                                     "phone":phone,
                                     "email": email,
                                     "address": location,
                                     "latitude": lat,
                                     "longitude": long]
        
        
        remoteDataSource.editProfile(dict: dict, profileImg: profileImg) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func updateJob(serviceID: Int, params: [String:Any],successCompletion: @escaping (_ response: GenericResponse<Availability>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        remoteDataSource.updateJob(serviceID: serviceID,params: params) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
    
    func getJobsForHistory(userId: String, month: String = "", year: String = "",query: String = "", status: String = "", isFiltered: Int = 0, offset: Int, successCompletion: @escaping (_ response: GenericResponse<BarberHomeModel>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        let url: String = "?user_id=\(userId)&limit=10&offset=\(offset)&month=\(month)&year=\(year)&query=\(query)&status=\(status)&orderBy=date&sortBy=desc&is_filtered=\(isFiltered)"
        print("================= \(url) =================")
        
        remoteDataSource.getJobs(appendingUrl: url) { response in
            successCompletion(response)
        } failureCompletion: { error in
            failureCompletion(error)
        }
    }
}
