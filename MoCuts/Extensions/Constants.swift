//
//  Constants.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 6/27/19.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import Foundation
import UIKit
/// Class to keep all constant at one place.
struct Constants {
    static var minDigitsReqInPhoneNumber = 10
    static var maxDigitsReqInPhoneNumber = 15
    
    static var htmlHeader = "<html><body text = white><meta name='viewport' content='width=device-width, initial-scale=1.0'/>"
    static var htmlWidthStyle = "<style> img { max-width:100%; } </style>"
    static var htmlFooterOrEnd = "</body></html>"
    
    enum Colors{
        case white
        case black
    }
    
    enum PageType {
        case pp
        case tc
        case about
    }
    
    static func htmlHeader(color: Colors = .black) -> String{
        return "<html><body text = \((color == .white) ? "white" : "black")><meta name='viewport' content='width=device-width, initial-scale=1.0'/>"
    }
    
    ///MARK:- Date Constants
    static let dateFormat = "yyyy-MM-dd HH:mm:ss"
    static let availabilitiesComparisonFormat = "yyyy-MM-dd hh:mm aa"
    static let availibilitesDateFormat = "yyyy-MM-dd"
    static let withdrawalDateFormat = "MMM, yy"
    static let withdrawalUIDateFormat = "dd/MM/yyyy"
    static let withdrawalTimeFormat = "HH:mm:ss"
    static let withdrawalUITimeFormat = "hh:mm aa"
    static let SECOND : Double = 1
    static let MINUTE : Double = SECOND * 60
    static let HOUR : Double = MINUTE * 60
    static let DAY : Double = HOUR * 24
    static let WEEK : Double = DAY * 7
    
    ///MARK: - Radius
    static let slightyRoundRadius : CGFloat = 4.0
    
    ///MARK: - Font
    static let defaultSize : CGFloat = 20.0
    
    static let regularFont : String = "Jost-Regular"
    static let mediumFont : String = "Jost-Medium"
    static let semiboldFont : String = "Jost-SemiBold"
    static let boldFont : String = "Jost-Bold"
    static let lightFont : String = "Jost-Light"
    static let thinFont : String = "Jost-Thin"
    static let blackFont : String = "Jost-Black"
    static let extraboldFont : String = "Jost-ExtraBold"
    static let extralightFont : String = "Jost-ExtraLight"
    
    ///MARK: - Location
    static let latitude = ""
    static let longitude = ""
    static var ratingPopupActive : Bool = false
    
    ///MARK: - Website
    static let mainWebsite : String = ""
    
    static let client_secret : String = ""
    static let client_id : Int = 2
    static let grant_type : String = ""
    static let method : String = ""
    
    static let NotApplicable : String = "Not Applicable"
    static let Null : String = "<null>"

    
    //MARK: Stripe Default Publishable Key
    static let stripePublishableKey = "pk_live_1JCxx9ohgd8AyiJ0rnCN3ikg"
    //"pk_test_x7YFCrHITdGbbvEV9maPrNCQ"
    
//    static let googleApisKey = "AIzaSyBzbOb7JNOwscU6kwLI8VSIDzVhZX4fz7o"
    static let googleApisKey = "AIzaSyA11GgfTuOL-Q3_iPysp-8P0_5HMgSf7zE"
    /// Subscription and Trial Period PopUp Text
    
    static let senderId = "1085995696151"
    
    struct NotificationType {
        static let JOB_REQUEST = 5
        static let JOB_ACCEPTED = 10
        static let JOB_REJECTED = 15
        static let BARBER_CANCELLED_JOB = 20
        static let BARBER_ON_THE_WAY = 25
        static let BARBER_ARRIVED = 30
        static let BARBER_COMPLETED_JOB = 35
        static let BARBER_REVIEWED = 40
        static let CUSTOMER_CANCELLED_JOB = 45
        static let CUSTOMER_MARKED_COMPLETE = 50
        static let CUSTOMER_REVIEWED = 55
        static let CHAT_MESSAGE = 60
    }
}
