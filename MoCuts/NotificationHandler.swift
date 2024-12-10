//
//  NotificationHandler.swift
//  MoCuts
//
//  Created by Ahmed Khan on 29/11/2021.
//

import Foundation
import UIKit
import CommonComponents

class NotificationHandler {
    
    //role: 2 for customer.
    //role: 3 for barber.
    
    var notification: PushNotificationModel?
    var shouldDelay = true
    func handleNotification(dataObj:[String:Any]) {
        
        let dict = Utilities.convertToDictionary(text: dataObj["payload"] as? String ?? "")
        
        notification = PushNotificationModel(
            message: dict?["message"] as? String,
            notifiableId: ((dict?["notifiable_id"] as? Int) == nil ? Int(dict?["notifiable_id"] as? String ?? "0") : (dict?["notifiable_id"] as? Int)),
            notificationId: ((dict?["notification_id"] as? Int) == nil ? Int(dict?["notification_id"] as? String ?? "0") : (dict?["notification_id"] as? Int)),
            refId: ((dict?["ref_id"] as? Int) == nil ? Int(dict?["ref_id"] as? String ?? "0") : (dict?["ref_id"] as? Int)),
            referencedUserId: ((dict?["referenced_user_id"] as? Int) == nil ? Int(dict?["referenced_user_id"] as? String ?? "0") : (dict?["referenced_user_id"] as? Int)),
            role: ((dict?["role"] as? Int) == nil ? Int(dict?["role"] as? String ?? "0") : (dict?["role"] as? Int)),
            title: dict?["title"] as? String,
            type: ((dict?["type"] as? Int) == nil ? Int(dict?["type"] as? String ?? "0") : (dict?["type"] as? Int)))
        
        if notification == nil {
            return
        }
        
        markNotificationRead(isBarber: notification?.role == 3, notificationId: String(notification?.notificationId ?? 0))
        
        if let role = notification?.role {
            let vm = BarberHomeListViewModel()
            vm.setJobFailureRoute = {
                ProgressHUD.dismiss()
            }
            vm.setJobRoute = { job in
                ProgressHUD.dismiss()
                if role == 2 {
                    switch self.notification?.type ?? 0 {
                    case Constants.NotificationType.BARBER_ARRIVED,
                         Constants.NotificationType.BARBER_ON_THE_WAY,
                         Constants.NotificationType.BARBER_COMPLETED_JOB:
                        if job.status == 16 {
                            self.goToCustomerServiceDetailView(job: job)
                        } else {
                            self.goToTrackingView(job: job)
                        }
                    case Constants.NotificationType.BARBER_CANCELLED_JOB,
                         Constants.NotificationType.JOB_ACCEPTED,
                         Constants.NotificationType.JOB_REJECTED:
                        self.goToCustomerServiceDetailView(job: job)

                    case Constants.NotificationType.CHAT_MESSAGE:
                        if [JobStatus.ARRIVED, JobStatus.ON_THE_WAY, JobStatus.BARBER_MARKED_COMPLETED, JobStatus.BARBER_REVIEWED].contains(job.status ?? 0) {
                            self.goToChatView(job: job, isCustomer: true)
                        }
                    case Constants.NotificationType.BARBER_REVIEWED:
                        self.goToReview(job: job.user_id ?? -1)
                    default:
                        break
                    }
                } else if role == 3 {
                    switch self.notification?.type ?? 0 {
                    case Constants.NotificationType.CUSTOMER_MARKED_COMPLETE,
                         Constants.NotificationType.CUSTOMER_CANCELLED_JOB,
                         Constants.NotificationType.JOB_REQUEST:
                        self.goToServiceDetailView(job: job)
                    case Constants.NotificationType.CHAT_MESSAGE:
                        if [JobStatus.ARRIVED, JobStatus.ON_THE_WAY, JobStatus.BARBER_MARKED_COMPLETED, JobStatus.BARBER_REVIEWED].contains(job.status ?? 0) {
                            self.goToChatView(job: job, isCustomer: false)
                        }
                    case Constants.NotificationType.CUSTOMER_REVIEWED:
                        self.goToReview(job: job.barber_id ?? -1)
                    default:
                        break
                    }
                }
            }
            vm.getJob(jobId: String(notification?.refId ?? 0))
            ProgressHUD.animationType = .circleStrokeSpin
            ProgressHUD.show(nil, interaction: false)
        }
    }
    
    func markNotificationRead(isBarber: Bool, notificationId: String) {
        if isBarber {
            let vm = BarberNotificationViewModel()
            vm.markRead(notificationId: notificationId)
        } else {
            let vm = CustomerNotificationViewModel()
            vm.markRead(notificationId: notificationId)
        }
    }
}

extension NotificationHandler {
    func goToServiceDetailView(job: BarberBaseModel) {
        if shouldDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                let vc : BarberServiceRequestView = AppRouter.instantiateViewController(storyboard: .Barberhome)
                vc.hidesBottomBarWhenPushed = true
                let topVc = UIApplication.topViewController()
                let todayDate = Utilities.formateDate(Date(), dateFormat: "yyyy-MM-dd")
                if (topVc is BarberServiceRequestView) {
                    (topVc as! BarberServiceRequestView).jobType = todayDate == job.date ? .today : .upcoming
                    (topVc as! BarberServiceRequestView).serviceObject = job
                    (topVc as! BarberServiceRequestView).reportsSetup()
                    (topVc as! BarberServiceRequestView).setViewsAndData()
                } else {
                    vc.jobType = todayDate == job.date ? .today : .upcoming
                    vc.serviceObject = job
                    vc.hidesBottomBarWhenPushed = true
                    topVc?.navigationController?.pushViewController(vc, animated: true)
                }
            })
        } else {
            DispatchQueue.main.async {
                let vc : BarberServiceRequestView = AppRouter.instantiateViewController(storyboard: .Barberhome)
                vc.hidesBottomBarWhenPushed = true
                let topVc = UIApplication.topViewController()
                let todayDate = Utilities.formateDate(Date(), dateFormat: "yyyy-MM-dd")
                if (topVc is BarberServiceRequestView) {
                    (topVc as! BarberServiceRequestView).jobType = todayDate == job.date ? .today : .upcoming
                    (topVc as! BarberServiceRequestView).serviceObject = job
                    (topVc as! BarberServiceRequestView).reportsSetup()
                    (topVc as! BarberServiceRequestView).setViewsAndData()
                } else {
                    vc.jobType = todayDate == job.date ? .today : .upcoming
                    vc.serviceObject = job
                    vc.hidesBottomBarWhenPushed = true
                    topVc?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    func goToChatView(job: BarberBaseModel, isCustomer: Bool) {
        if shouldDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute:  {
                let vc : BarberChatView = AppRouter.instantiateViewController(storyboard: .Barbermore)
                vc.isCustomer = isCustomer
                vc.serviceObject = job
                vc.hidesBottomBarWhenPushed = true
                print("goToChatView")
                let topVc = UIApplication.topViewController()
                if !(topVc is BarberChatView) {
                    topVc?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    if (topVc as! BarberChatView).serviceObject.id != job.id {
                        topVc?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            })
        } else {
            DispatchQueue.main.async {
                let vc : BarberChatView = AppRouter.instantiateViewController(storyboard: .Barbermore)
                vc.isCustomer = isCustomer
                vc.serviceObject = job
                vc.hidesBottomBarWhenPushed = true
                print("goToChatView")
                let topVc = UIApplication.topViewController()
                if !(topVc is BarberChatView) {
                    topVc?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    if (topVc as! BarberChatView).serviceObject.id != job.id {
                        topVc?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    func goToCustomerServiceDetailView(job: BarberBaseModel) {
        if shouldDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute:  {
                let vc : ServiceDetailView = AppRouter.instantiateViewController(storyboard: .services)

                let topVc = UIApplication.topViewController()
                if (topVc is ServiceDetailView) {
                    (topVc as! ServiceDetailView).serviceObject = job
                    (topVc as! ServiceDetailView).reportsSetup()
                    (topVc as! ServiceDetailView).setViewsAndData()
                } else {
                    let todayDate = Utilities.formateDate(Date(), dateFormat: "yyyy-MM-dd")
                    vc.jobType = todayDate == job.date ? .today : .upcoming
                    vc.serviceObject = job
                    vc.hidesBottomBarWhenPushed = true
                    topVc?.navigationController?.pushViewController(vc, animated: true)
                }
            })
        } else {
            DispatchQueue.main.async {
                let vc : ServiceDetailView = AppRouter.instantiateViewController(storyboard: .services)

                let topVc = UIApplication.topViewController()
                if (topVc is ServiceDetailView) {
                    (topVc as! ServiceDetailView).serviceObject = job
                    (topVc as! ServiceDetailView).reportsSetup()
                    (topVc as! ServiceDetailView).setViewsAndData()
                } else {
                    let todayDate = Utilities.formateDate(Date(), dateFormat: "yyyy-MM-dd")
                    vc.jobType = todayDate == job.date ? .today : .upcoming
                    vc.serviceObject = job
                    vc.hidesBottomBarWhenPushed = true
                    topVc?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func goToTrackingView(job: BarberBaseModel) {
        if shouldDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute:  {

                let topVc = UIApplication.topViewController()
                if (topVc is CustomerOnMyWayView) {
                    (topVc as! CustomerOnMyWayView).serviceObject = job
                    (topVc as! CustomerOnMyWayView).listnerReg?.remove()
                    (topVc as! CustomerOnMyWayView).initViews()
                    (topVc as! CustomerOnMyWayView).setData()
                } else {
                    let vc : CustomerOnMyWayView = AppRouter.instantiateViewController(storyboard: .Customertrack)
                    vc.serviceObject = job
                    vc.hidesBottomBarWhenPushed = true
                    topVc?.navigationController?.pushViewController(vc, animated: true)
                }
            })
        } else {
            DispatchQueue.main.async {
                let topVc = UIApplication.topViewController()
                if (topVc is CustomerOnMyWayView) {
                    (topVc as! CustomerOnMyWayView).serviceObject = job
                    (topVc as! CustomerOnMyWayView).listnerReg?.remove()
                    (topVc as! CustomerOnMyWayView).initViews()
                    (topVc as! CustomerOnMyWayView).setData()
                } else {
                    let vc : CustomerOnMyWayView = AppRouter.instantiateViewController(storyboard: .Customertrack)
                    vc.serviceObject = job
                    vc.hidesBottomBarWhenPushed = true
                    topVc?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func goToReview(job: Int){
        DispatchQueue.main.async {
            let vc : NotificationRatingsReviewView = AppRouter.instantiateViewController(storyboard: .Customernotification)
            vc.hidesBottomBarWhenPushed = true
            let topVc = UIApplication.topViewController()
            vc.barberId = job
            topVc?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
