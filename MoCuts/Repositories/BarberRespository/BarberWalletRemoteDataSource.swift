//
//  BarberWalletRemoteDataSource.swift
//  MoCuts
//
//  Created by Ahmed Khan on 28/10/2021.
//
import Foundation
import UIKit

struct BarberWalletRemoteDataSource {

    func withdrawAmount(amount: Int, successCompletion: @escaping (_ response: GenericResponse<WithdrawalResponseItem>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        
        Router.APIRouter(endPoint: .withdraw, appendingURL: "", parameters: ["amount": amount], method: .post) {
            response in
            
            switch response {
            case .success(let success):
                guard let jobs = try? JSONDecoder().decode(GenericResponse<WithdrawalResponseItem>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if jobs.status {
                    successCompletion(jobs)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: jobs.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
    
    func generateLink(successCompletion: @escaping (_ response: GenericResponse<ConnectLinkResponse>) -> Void, failureCompletion: @escaping (_ error: Error) -> Void) {
        Router.APIRouter(endPoint: .generateConnectAccountLink, appendingURL: "", parameters: [:], method: .get) {
            response in
            
            switch response {
            case .success(let success):
                guard let connectResponse = try? JSONDecoder().decode(GenericResponse<ConnectLinkResponse>.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                if connectResponse.status {
                    successCompletion(connectResponse)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: connectResponse.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
    
    func connectPaypal(token: String, successCompletion: @escaping (_ response: BaseRequestResponse) -> Void, failureCompletion: @escaping (_ error: Error) -> Void){
        
        Router.APIRouter(endPoint: .connectPaypal, appendingURL: "", parameters: ["id_token": token], method: .post) {
            response in
            
            switch response {
            case .success(let success):
                guard let paypalRes = try? JSONDecoder().decode(BaseRequestResponse.self, from: success.data) else {
                    print("parsing failed")
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: "Couldn't decode data"])
                    failureCompletion(error)
                    return
                }
                
                if paypalRes.status {
                    successCompletion(paypalRes)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo:[NSLocalizedDescriptionKey: paypalRes.message ?? ""])
                    failureCompletion(error)
                }
            case .failure(let failure):
                let error = NSError(domain: "", code: failure.code ?? 0, userInfo:[NSLocalizedDescriptionKey: failure.message])
                failureCompletion(error)
            }
        }
    }
}
