//
//  HomeResponseModels.swift
//  MoCuts
//
//  Created by Saif Ahmed  on 29/09/2021.
//

import Foundation
import UIKit


struct BarberHomeModel : Codable {
    let total : Int?
    let perPage : Int?
    let page : Int?
    let lastPage : Int?
    var data : [BarberBaseModel]?

    enum CodingKeys: String, CodingKey {

        case total = "total"
        case perPage = "perPage"
        case page = "page"
        case lastPage = "lastPage"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        perPage = try values.decodeIfPresent(Int.self, forKey: .perPage)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        lastPage = try values.decodeIfPresent(Int.self, forKey: .lastPage)
        data = try values.decodeIfPresent([BarberBaseModel].self, forKey: .data)
    }

}

struct BarberBaseModel : Codable {
    var id : Int?
    var user_id : Int?
    var barber_id : Int?
    var availability_id : Int?
    var date : String?
    var sub_total : Int?
    var sales_tax : Int?
    var commission : Int?
    var total : Double?
    var status : Int?
    var created_at : String?
    var updated_at : String?
    var barber : Barber?
    var user : User_Model?
    var job_services : [Job_Services]?
    var availability : Availability?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case barber_id = "barber_id"
        case availability_id = "availability_id"
        case date = "date"
        case sub_total = "sub_total"
        case sales_tax = "sales_tax"
        case commission = "commission"
        case total = "total"
        case status = "status"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case barber = "barber"
        case user = "user"
        case job_services = "job_services"
        case availability = "availability"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        barber_id = try values.decodeIfPresent(Int.self, forKey: .barber_id)
        availability_id = try values.decodeIfPresent(Int.self, forKey: .availability_id)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        sub_total = try values.decodeIfPresent(Int.self, forKey: .sub_total)
        sales_tax = try values.decodeIfPresent(Int.self, forKey: .sales_tax)
        commission = try values.decodeIfPresent(Int.self, forKey: .commission)
        total = try values.decodeIfPresent(Double.self, forKey: .total)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        barber = try values.decodeIfPresent(Barber.self, forKey: .barber)
        user = try values.decodeIfPresent(User_Model.self, forKey: .user)
        job_services = try values.decodeIfPresent([Job_Services].self, forKey: .job_services)
        availability = try values.decodeIfPresent(Availability.self, forKey: .availability)
    }

}

struct Barber : Codable {
    
    let id : Int?
    let name : String?
    let email : String?
    let about : String?
    let phone : String?
    let image : String?
    let address : String?
    let latitude : String?
    let longitude : String?
    let stripe_customer_id : String?
    let connect_account_id : String?
    let average_rating : Double?
    let total_reviews : Int?
    let wallet_amount : Double?
    let social_platform : String?
    let client_id : String?
    let token : String?
    let verification_code : String?
    let push_notification : Int?
    let is_social_login : Int?
    let is_verified : Int?
    let is_approved : Int?
    let is_blocked : Int?
    let created_at : String?
    let updated_at : String?
    let image_url : String?
    let medium_image_url : String?
    let small_image_url : String?
    let services : [String]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case email = "email"
        case about = "about"
        case phone = "phone"
        case image = "image"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case stripe_customer_id = "stripe_customer_id"
        case connect_account_id = "connect_account_id"
        case average_rating = "average_rating"
        case total_reviews = "total_reviews"
        case wallet_amount = "wallet_amount"
        case social_platform = "social_platform"
        case client_id = "client_id"
        case token = "token"
        case verification_code = "verification_code"
        case push_notification = "push_notification"
        case is_social_login = "is_social_login"
        case is_verified = "is_verified"
        case is_approved = "is_approved"
        case is_blocked = "is_blocked"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case image_url = "image_url"
        case medium_image_url = "medium_image_url"
        case small_image_url = "small_image_url"
        case services = "services"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        about = try values.decodeIfPresent(String.self, forKey: .about)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        stripe_customer_id = try values.decodeIfPresent(String.self, forKey: .stripe_customer_id)
        connect_account_id = try values.decodeIfPresent(String.self, forKey: .connect_account_id)
        average_rating = try values.decodeIfPresent(Double.self, forKey: .average_rating)
        total_reviews = try values.decodeIfPresent(Int.self, forKey: .total_reviews)
        wallet_amount = try values.decodeIfPresent(Double.self, forKey: .wallet_amount)
        social_platform = try values.decodeIfPresent(String.self, forKey: .social_platform)
        client_id = try values.decodeIfPresent(String.self, forKey: .client_id)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        verification_code = try values.decodeIfPresent(String.self, forKey: .verification_code)
        push_notification = try values.decodeIfPresent(Int.self, forKey: .push_notification)
        is_social_login = try values.decodeIfPresent(Int.self, forKey: .is_social_login)
        is_verified = try values.decodeIfPresent(Int.self, forKey: .is_verified)
        is_approved = try values.decodeIfPresent(Int.self, forKey: .is_approved)
        is_blocked = try values.decodeIfPresent(Int.self, forKey: .is_blocked)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        medium_image_url = try values.decodeIfPresent(String.self, forKey: .medium_image_url)
        small_image_url = try values.decodeIfPresent(String.self, forKey: .small_image_url)
        services = try values.decodeIfPresent([String].self, forKey: .services)
    }

}


struct Job_Services : Codable {
    let id : Int?
    let job_id : Int?
    let service_id : Int?
    let amount : Int?
    let duration : Int?
    let created_at : String?
    let updated_at : String?
    let service : Service?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case job_id = "job_id"
        case service_id = "service_id"
        case amount = "amount"
        case duration = "duration"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case service = "service"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        job_id = try values.decodeIfPresent(Int.self, forKey: .job_id)
        service_id = try values.decodeIfPresent(Int.self, forKey: .service_id)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        service = try values.decodeIfPresent(Service.self, forKey: .service)
    }

}


struct Service : Codable {
    let id : Int?
    let name : String?
    let price : Int?
    let duration : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case price = "price"
        case duration = "duration"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
    }

}


struct Availability : Codable {
    var id : Int?
    var user_id : Int?
    var day : Int?
    var start_time : String?
    var end_time : String?
    var is_active : Int?
    var created_at : String?
    var updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case day = "day"
        case start_time = "start_time"
        case end_time = "end_time"
        case is_active = "is_active"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
    
    init(id: Int, user_id: Int, day: Int, start_time: String, end_time: String, is_active: Int, created_at: String, updated_at: String) {
        self.id = id
        self.user_id = user_id
        self.day = day
        self.created_at = created_at
        self.end_time = end_time
        self.start_time = start_time
        self.is_active = is_active
        self.updated_at = updated_at
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        day = try values.decodeIfPresent(Int.self, forKey: .day)
        start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(String.self, forKey: .end_time)
        is_active = try values.decodeIfPresent(Int.self, forKey: .is_active)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}

struct Availability_String : Codable {
    let id : Int?
    let user_id : Int?
    let day : String?
    let start_time : String?
    let end_time : String?
    let is_active : Int?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case day = "day"
        case start_time = "start_time"
        case end_time = "end_time"
        case is_active = "is_active"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        day = try values.decodeIfPresent(String.self, forKey: .day)
        start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(String.self, forKey: .end_time)
        is_active = try values.decodeIfPresent(Int.self, forKey: .is_active)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }

}

struct NotificationsResponseItem : Codable {

    let notifications : NotificationsListModel?
    let unreadCount : Int?


    enum CodingKeys: String, CodingKey {
        case notifications = "notifications"
        case unreadCount = "unread_count"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        notifications = try values.decodeIfPresent(NotificationsListModel.self, forKey: .notifications)
        unreadCount = try values.decodeIfPresent(Int.self, forKey: .unreadCount)
    }
}

struct NotificationModel : Codable {

    var createdAt : String?
    var createdAtAgo: String?
    var id : Int?
    var image : String?
    var message : String?
    var notifiableId : Int?
    var readAt : String?
    var refId : Int?
    var referencedUserId : Int?
    var title : String?
    var type : Int?
    var updatedAt : String?


    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case createdAtAgo = "created_at_ago"
        case id = "id"
        case image = "image"
        case message = "message"
        case notifiableId = "notifiable_id"
        case readAt = "read_at"
        case refId = "ref_id"
        case referencedUserId = "referenced_user_id"
        case title = "title"
        case type = "type"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        createdAtAgo = try values.decodeIfPresent(String.self, forKey: .createdAtAgo)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        notifiableId = try values.decodeIfPresent(Int.self, forKey: .notifiableId)
        readAt = try values.decodeIfPresent(String.self, forKey: .readAt)
        refId = try values.decodeIfPresent(Int.self, forKey: .refId)
        referencedUserId = try values.decodeIfPresent(Int.self, forKey: .referencedUserId)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}

struct NotificationsListModel : Codable {

    var data : [NotificationModel]?
    let lastPage : Int?
    let page : Int?
    let perPage : Int?
    let total : Int?

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case lastPage = "lastPage"
        case page = "page"
        case perPage = "perPage"
        case total = "total"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lastPage = try values.decodeIfPresent(Int.self, forKey: .lastPage)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        perPage = try values.decodeIfPresent(Int.self, forKey: .perPage)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        data = try values.decodeIfPresent([NotificationModel].self, forKey: .data)
    }
}

struct WithdrawHistoryResponseItem : Codable {

    let data : [WithdrawalModel]?
    let lastPage : Int?
    let page : Int?
    let perPage : Int?
    let total : Int?
    let allTimeWithdraw: Int?
    let currentMonthWithdraw: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case lastPage = "lastPage"
        case page = "page"
        case perPage = "perPage"
        case total = "total"
        case allTimeWithdraw = "all_time_with_draw"
        case currentMonthWithdraw = "current_month_with_draw"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([WithdrawalModel].self, forKey: .data)
        lastPage = try values.decodeIfPresent(Int.self, forKey: .lastPage)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        perPage = try values.decodeIfPresent(Int.self, forKey: .perPage)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        allTimeWithdraw = try values.decodeIfPresent(Int.self, forKey: .allTimeWithdraw)
        currentMonthWithdraw = try values.decodeIfPresent(Int.self, forKey: .currentMonthWithdraw)
    }
}
struct WithdrawalModel : Codable {

    let amount : Int?
    let createdAt : String?
    let currency : String?
    let descriptionField : String?
    let id : Int?
    let jobId : String?
    let newAmount : Float?
    let previousAmount : Float?
    let status : String?
    let transactionId : String?
    let type : Int?
    let typeText : String?
    let updatedAt : String?
    let userId : Int?


    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case createdAt = "created_at"
        case currency = "currency"
        case descriptionField = "description"
        case id = "id"
        case jobId = "job_id"
        case newAmount = "new_amount"
        case previousAmount = "previous_amount"
        case status = "status"
        case transactionId = "transaction_id"
        case type = "type"
        case typeText = "type_text"
        case updatedAt = "updated_at"
        case userId = "user_id"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        jobId = try values.decodeIfPresent(String.self, forKey: .jobId)
        newAmount = try values.decodeIfPresent(Float.self, forKey: .newAmount)
        previousAmount = try values.decodeIfPresent(Float.self, forKey: .previousAmount)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        typeText = try values.decodeIfPresent(String.self, forKey: .typeText)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
    }
}

struct SettingsResponse : Codable {

    let about : String?
    let address : String?
    let appStoreLink : String?
    let baseUrl : String?
    let buildVersion : String?
    let commission : Int?
    let createdAt : String?
    let facebookLink : String?
    let id : Int?
    let penaltyCharges : Int?
    let phone : String?
    let email : String?
    let salesTax : Int?
    let title : String?
    let updatedAt : String?
    let year : Int?


    enum CodingKeys: String, CodingKey {
        case about = "about"
        case address = "address"
        case appStoreLink = "app_store_link"
        case baseUrl = "base_url"
        case buildVersion = "build_version"
        case commission = "commission"
        case createdAt = "created_at"
        case facebookLink = "facebook_link"
        case id = "id"
        case penaltyCharges = "penalty_charges"
        case phone = "phone"
        case email = "email"
        case salesTax = "sales_tax"
        case title = "title"
        case updatedAt = "updated_at"
        case year = "year"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        about = try values.decodeIfPresent(String.self, forKey: .about)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        appStoreLink = try values.decodeIfPresent(String.self, forKey: .appStoreLink)
        baseUrl = try values.decodeIfPresent(String.self, forKey: .baseUrl)
        buildVersion = try values.decodeIfPresent(String.self, forKey: .buildVersion)
        commission = try values.decodeIfPresent(Int.self, forKey: .commission)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        facebookLink = try values.decodeIfPresent(String.self, forKey: .facebookLink)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        penaltyCharges = try values.decodeIfPresent(Int.self, forKey: .penaltyCharges)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        salesTax = try values.decodeIfPresent(Int.self, forKey: .salesTax)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        year = try values.decodeIfPresent(Int.self, forKey: .year)
    }


}

struct ReportType : Codable {

    let createdAt : String?
    let id : Int?
    let name : String?
    let updatedAt : String?


    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id = "id"
        case name = "name"
        case updatedAt = "updated_at"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}

struct ReportResponse : Codable {
    let createdAt : String?
    let fromId : Int?
    let id : Int?
    let message : String?
    let reportTypeId : String?
    let toId : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case fromId = "from_id"
        case id = "id"
        case message = "message"
        case reportTypeId = "report_type_id"
        case toId = "to_id"
        case updatedAt = "updated_at"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        fromId = try values.decodeIfPresent(Int.self, forKey: .fromId)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        reportTypeId = try values.decodeIfPresent(String.self, forKey: .reportTypeId)
        toId = try values.decodeIfPresent(String.self, forKey: .toId)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}
