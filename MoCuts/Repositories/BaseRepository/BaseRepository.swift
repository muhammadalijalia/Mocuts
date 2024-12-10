//
//  BaseRepository.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 7/10/19.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import Foundation


class BaseRepository {
    
    var networkAdapter : NetworkChangeNotifiable = NetworkChangeClass()
    
    enum FetchingType {
        case remote
        case local
        case remoteUpdateLocal
        case localFetchingRemote
        case automatic
    }
    
    /// A general method to show alert to user coming from API Request.
    ///
    /// - Parameters:
    ///   - failure: Server failure response.
    ///   - vc: on view controller which error has to be shown.
    func switchFailure(_ failure: Failure, errorCompletion: @escaping (ServerErrorResponse?, String?) -> Void ) {
        
        if let data = failure.data {
            if let errorResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                errorCompletion(errorResponse, nil)
                return
            } else {
                errorCompletion(nil, Messages.wentWrongError)
            }
        } else {
            errorCompletion(nil, failure.message)
        }
    }
    
    /// A general method to show alert to user coming from API Request.
    ///
    /// - Parameters:
    ///   - failure: Server failure response.
    ///   - vc: on view controller which error has to be shown.
//    func switchPaymentFailure(_ failure: Failure, errorCompletion: @escaping (PaymentErrorResponse?, String?) -> Void ) {
//
//        if let data = failure.data {
//            if let errorResponse = try? JSONDecoder().decode(PaymentErrorResponse.self, from: data) {
//                errorCompletion(errorResponse, nil)
//                return
//            } else {
//                errorCompletion(nil, Messages.wentWrongError)
//            }
//        } else {
//            errorCompletion(nil, failure.message)
//        }
//    }
    
//    func switchPhoneVerifyFailure(_ failure: Failure, errorCompletion: @escaping (PhoneVerifyFailure?, String?) -> Void ) {
//
//        if let data = failure.data {
//            if let errorResponse = try? JSONDecoder().decode(PhoneVerifyFailure.self, from: data) {
//                errorCompletion(errorResponse, nil)
//                return
//            } else {
//                errorCompletion(nil, Messages.wentWrongError)
//            }
//        } else {
//            errorCompletion(nil, failure.message)
//        }
//    }
    
//    func switchReservationFailure(_ failure: Failure, errorCompletion: @escaping ([ReservationErrorResponse]?, String?) -> Void ) {
//
//        if let data = failure.data {
//            if let errorResponse = try? JSONDecoder().decode([ReservationErrorResponse]?.self, from: data) {
//                errorCompletion(errorResponse, nil)
//                return
//            } else {
//                errorCompletion(nil, Messages.wentWrongError)
//            }
//        } else {
//            errorCompletion(nil, failure.message)
//        }
//    }
//
//
//    func switchCheckInFailure(_ failure: Failure, errorCompletion: @escaping (ServerErrorResponse?, String?) -> Void ) {
//
//        if let data = failure.data {
//            if let errorResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
//                errorCompletion(errorResponse, nil)
//                return
//            } else {
//                errorCompletion(nil, Messages.wentWrongError)
//            }
//        } else {
//            errorCompletion(nil, failure.message)
//        }
    }

