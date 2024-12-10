//
//  Utilities.swift
//  MoCuts
//
//  Created by Mohammad Zawwar Mohammad Zawwar on 11/06/2018.
//  Copyright © 2018 Appiskey. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import SystemConfiguration
import Helpers
import Reachability
import Firebase
import SwiftyJSON 
import CommonComponents


/// Basic Utility class to provide needy function in app.
class Utilities : NSObject {
    
    static let shared = Utilities()
    private override init () {
        super.init()
    }
    
    /// To add Shadow to any view.
    ///
    /// - Parameters:
    ///   - view: view which needed be shadowed.
    ///   - color: color need to apply as shadow.
    
    func setHolderView (view : UIView, color : UIColor) {
        
        view.layer.shadowColor = color.cgColor
        
        view.layer.shadowOffset = CGSize(width: 1, height: 0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 3.0
    }
    
    func stringToDate(date : String, format : String) -> Date {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: date)!
    }
    
    func getSecondsInWords(seconds: Double, isMins: Bool = false) -> String {
        
        var secondsInWords = ""
        let doubleFormat = "%.1f"
        let min = isMins ? "min" : "minute"
        if seconds == Constants.MINUTE {
            secondsInWords = "1.0 \(min)"
        } else if seconds == Constants.HOUR {
            secondsInWords = "1.0 hour"
        } else if seconds == Constants.DAY {
            secondsInWords = "1.0 day"
        } else if seconds == Constants.WEEK {
            secondsInWords = "1.0 week"
        } else if seconds < Constants.MINUTE {
            secondsInWords = "\(String(format: doubleFormat, seconds)) seconds"
        } else if seconds < Constants.HOUR {
            secondsInWords = "\(String(format: doubleFormat, seconds/Constants.MINUTE)) \(min)s"
        } else if seconds < Constants.DAY {
            secondsInWords = "\(String(format: doubleFormat, seconds/Constants.HOUR)) hours"
        } else if seconds < Constants.WEEK {
            secondsInWords = "\(String(format: doubleFormat, seconds/Constants.DAY)) days"
        } else {
            secondsInWords = "\(String(format: doubleFormat, seconds/Constants.WEEK)) weeks"
        }
        return secondsInWords
    }
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //Setting status bar color
    func setStatusBarColor1(color: UIColor?=UIColor.white){
        
        if #available(iOS 13.0, *) {
           let statusBar1 =  UIView()
           statusBar1.frame = UIApplication.shared.keyWindow?.windowScene?.statusBarManager!.statusBarFrame as! CGRect
           statusBar1.backgroundColor = color

           UIApplication.shared.keyWindow?.addSubview(statusBar1)

        } else {

           let statusBar1: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
           statusBar1.backgroundColor = color
        }
      
    }
    
    ///present view controller with model presentation style
    ///
    /// - Parameters:
    ///   - vc: view controller to show
    ///   - fromVC: from viewcontroller on which modal presentation is to be done
    func presentModally(vc: UIViewController, fromVC : UIViewController){
        
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            fromVC.present(vc, animated: true, completion: nil)
        }
    }
    
    /// To find out is email is valid or not.
    ///
    /// - Parameter email: email to be checked.
    /// - Returns: return is valid email or not.
    func validateEmail(email : String) -> Bool{
        let value = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", value)
        let result =  emailTest.evaluate(with: email)
        return result
    }
    
    func getHardwareID() -> String {
        let deviceToken = UIDevice.current.identifierForVendor!.uuidString
        return deviceToken
    }
    
    func getDeviceType() -> String {
        return "ios"
    }
    
    /// Set Image from web url and round the image.
    ///
    /// - Parameters:
    ///   - imageUrl: Url of the image (only end Point)
    ///   - urlType: End point type.
    ///   - imageView: view on image have to be shown.
    ///   - placeholder: placholder image string.
    //    func setImage (imageUrl : String, urlType : AppURL.URLTypes, imageView : UIImageView, placeholder: String = "img", needsCorner: Bool = true) {
    //        
    //        if let urlTextEscaped = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
    //            
    //            let urlString = URL(string: AppURL.getURL(with: urlType) + urlTextEscaped )
    //            DispatchQueue.main.async {
    //                imageView.isHidden = false
    //            }
    //            imageView.sd_setShowActivityIndicatorView(true)
    //            imageView.sd_setIndicatorStyle(.gray)
    //            
    //            imageView.sd_setImage(with: urlString, placeholderImage: UIImage(named:placeholder), options: [], completed: { (image, error, cache, url) in
    //                if error == nil {
    //                    DispatchQueue.main.async {
    //                        imageView.image = image
    //                        if needsCorner {
    //                            imageView.layer.cornerRadius = imageView.bounds.height * 0.5
    //                            imageView.clipsToBounds = true
    //                        }
    //                    }
    //                }
    //            })
    //        }
    //    }
    
    /// General function to set Navigation.
    ///
    /// - Parameters:
    ///   - backButton: back button to be shown on next controller.
    ///   - leftBarItem: left button to show.
    ///   - rightBarItem: right button to show.
    ///   - title: Title to show
    ///   - vc: view controller on which view controller should be visible.
    ///   - isTransparent: when navigation should be clear
    ///   - isBottomLine: when to hide bottom shadow of navigation.
    ///   - titleView: title view to be shown instead of title.
    func setNavigationBar(backButton: UIBarButtonItem?=nil, leftBarItem: UIBarButtonItem?=nil, rightBarItem: UIBarButtonItem?=nil, title: String, vc: UIViewController, isTransparent: Bool = false, isBottomLine: Bool = false, titleView: UIView?=nil){
        
        let font = UIFont(name: "\(Constants.regularFont)-Bold", size: 24)
        
        if(rightBarItem != nil){
            rightBarItem?.setTitleTextAttributes([NSAttributedString.Key.font:font!], for: .normal)
            vc.navigationItem.rightBarButtonItem = rightBarItem
            
            
        }
        if backButton != nil {
            vc.navigationItem.backBarButtonItem = backButton
        }
        if(leftBarItem != nil){
            leftBarItem?.setTitleTextAttributes([NSAttributedString.Key.font:font!], for: .normal)
            vc.navigationItem.leftBarButtonItem = leftBarItem
        }
        
        if !(titleView != nil){
            vc.navigationItem.title = title
        }else{
            vc.navigationItem.titleView = titleView!
        }
        
        if !isTransparent{
            
            vc.navigationController?.navigationBar.barTintColor = Theme.appOrangeColor
            vc.navigationController?.navigationBar.backgroundColor = .black
            vc.navigationController?.navigationBar.tintColor = UIColor.black
            vc.navigationController?.navigationBar.isTranslucent = false
            if !isBottomLine {
                vc.navigationController?.navigationBar.shadowImage = UIImage()
            }
            
        }else{
            
            vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            vc.navigationController?.navigationBar.shadowImage = UIImage()
            vc.navigationController?.navigationBar.barTintColor = .clear//color
            vc.navigationController?.navigationBar.backgroundColor = .clear
            vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            vc.navigationController?.navigationBar.isTranslucent = true
        }
        
        vc.navigationItem.backBarButtonItem?.title = ""
        vc.navigationController?.navigationItem.backBarButtonItem?.title=""
        vc.navigationItem.backBarButtonItem?.tintColor = UIColor.clear
        vc.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        vc.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        //        vc.navigationItem.setHidesBackButton(true, animated: false)
        
        
        let titleDict: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font:font!]
        vc.navigationController?.navigationBar.titleTextAttributes = titleDict
    }
    
    func setTitle(title:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 0, height: 0))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        //titleLabel.font = UIFont(name: "Noteworthy-Bold", size: 20)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, titleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        
        return titleView
    }
    
    func shakeView(view: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
        view.layer.add(animation, forKey: "position")
    }
    
    /// General function to show alert.
    ///
    /// - Parameters:
    ///   - title: Title of alert.
    ///   - message: Message of alert.
    ///   - actions: array of action to be shown with alert.
    ///   - defaultActionTitle: to show default option title.
    ///   - isDefaultActionReq: default action.
    ///   - vc: view controller to show alert on.
    func showAlert (title : String? , message : String?, actions: [UIAlertAction]?=nil, alertStyle : UIAlertController.Style = .alert, defaultActionTitle: String?="Done", isDefaultActionReq: Bool=true, vc: UIViewController?=nil, dismissTime: Double? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        if actions != nil{
            for action in actions!{
                //                if action.style == .default {
                //                    action.setValue(.purple, forKey: "titleTextColor")
                //                }
                alertController.addAction(action)
            }
        }
        if isDefaultActionReq{
            let alertAction = UIAlertAction(title: defaultActionTitle, style: .default, handler: nil)
            alertController.addAction(alertAction)
        }
        DispatchQueue.main.async {
            if vc == nil {
                
                self.topController()?.present(alertController, animated: true, completion: nil)
                
//                                self.topController(completion: { (controller) in
//                                    controller.present(alertController, animated: true, completion: nil)
//                                })
                
            } else {
                vc!.present(alertController, animated: true, completion: nil)
            }
            
        }
        
        if let seconds = dismissTime {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                if vc == nil {
                    //                    self.topController(completion: { (controller) in
                    //                        controller.dismiss(animated: true)
                    //                    })
                    
                } else {
                    vc!.dismiss(animated: true)
                }
            }
        }
        
    }
    
    
    
    //    func clearFcmOnLogout(){
    //        (UIApplication.shared.delegate as! AppDelegate).removeAndGetFCMAgain()
    //    }
    
    func logoutUser(){
        
        //        UserModel().logoutApi(completion: { (model, message) in
        //
        //        })
        //
        //        self.clearFcmOnLogout()
        //
        //        DispatchQueue.main.async {
        //            GIDSignIn.sharedInstance()?.signOut()
        //            LoginManager.init().logOut()
        //            Router.configuration = RouterConfiguration.init(baseURL: Enviroment.baseURL,
        //                                                            authorizationToken: nil)
        //            ChildSessionValidator.sharedInstance.deleteChildSessionAndRelatedStuff()
        //            Utilities.shared.decideAndMakeRootVCForUser()
        //        }
        
    }
    
    // Function for presenting Top Controller
    func topController() -> UIViewController? {
        
        if var viewController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = viewController.presentedViewController {
                viewController = presentedViewController
            }
            return viewController
        }
        return nil
    }
    
    private var reachability: Reachability!
    
    //    func decideAndMakeRootVCForUser(){
    //        if self.isAppOpenFirstTime(){
    //            self.appOpenedFirstTime()
    //            DispatchQueue.main.async {
    //                let vc : ParentLoginView = AppRouter.instantiateViewController(storyboard: .ParentAuth)
    //                let nvc = UINavigationController(rootViewController: vc)
    //                Helper.getInstance.makeSpecificViewRoot(vc: nvc)
    //            }
    //        } else {
    //            if UserModel().getAppUser() != nil {
    //                reachability = try? Reachability()
    //                if self.reachability.connection != .unavailable {
    //                    UserModel().getProfile { (user, message) in
    //                        if let childSession = ChildUserModel().getChildSession() {
    //                            self.makeRootForChild(session: childSession)
    //                        } else {
    //                            DispatchQueue.main.async {
    //                                self.makeRootForLoggedInUser()
    //                            }
    //                        }
    //                    }
    //                } else {
    //                    if let childSession = ChildUserModel().getChildSession() {
    //                        self.makeRootForChild(session: childSession)
    //                    } else {
    //                        DispatchQueue.main.async {
    //                            self.makeRootForLoggedInUser()
    //                        }
    //                    }
    //                    self.reachability.whenReachable = { _ in
    //                        UserModel().getProfile { (user, message) in }
    //                    }
    //                    do {
    //                        try reachability.startNotifier()
    //                    } catch {
    //                        print("Unable to start notifier")
    //                    }
    //                }
    //            }
    //            else {
    //                DispatchQueue.main.async {
    //                    let vc : ParentLoginView = AppRouter.instantiateViewController(storyboard: .ParentAuth)
    //                    let nvc = UINavigationController(rootViewController: vc)
    //                    DispatchQueue.main.async {
    //                        Helper.getInstance.makeSpecificViewRoot(vc: nvc)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    //    func makeRootForChild(session: ChildSession) {
    //
    //        let id = session.child_id
    //
    //        DispatchQueue.main.async {
    //            let vc : ChildHomeView = AppRouter.instantiateViewController(storyboard: .Child)
    //            vc.childID = id
    //            let nvc = UINavigationController(rootViewController: vc)
    //            Helper.getInstance.makeSpecificViewRoot(vc: nvc)
    //        }
    //    }
    
    //    func makeRootForLoggedInUser(){
    //        if let user = UserModel().getAppUser(){
    //            var nvc: UINavigationController!
    //           // let consentCheck = !user.consent
    //            let passcodeCheck = user.passcode == nil
    //            DispatchQueue.main.async {
    ////                if consentCheck {
    ////                        let vc : ParentConsentView = AppRouter.instantiateViewController(storyboard: .ParentAuth)
    ////                        vc.isFromAppDelegate = true
    ////                        nvc = UINavigationController(rootViewController: vc)
    ////
    ////                } else
    //                if passcodeCheck {
    ////                        let vc : PasscodePopUp = AppRouter.instantiateViewController(storyboard: .ParentAuth)
    ////                        vc.screenCase = .setupPasscode
    ////                        nvc = UINavigationController(rootViewController: vc)
    //
    //
    //                        let vc : PasscodePopUp = AppRouter.instantiateViewController(storyboard: .ParentAuth)
    //                        vc.screenCase = .setupPasscode
    //                        nvc = UINavigationController(rootViewController: vc)
    //
    //
    //                }
    //                else {
    //                        let vc : ParentHomeView = AppRouter.instantiateViewController(storyboard: .Parent)
    //                        nvc = UINavigationController(rootViewController: vc)
    //
    //                }
    //                DispatchQueue.main.async {
    //                    Helper.getInstance.makeSpecificViewRoot(vc: nvc)
    //                    Utilities.shared.getDeviceToken()
    //                }
    //            }
    //        }
    //    }
    
    
    
    
    //    func isAppOpenFirstTime() -> Bool{
    //        return (UserDefaults.standard.object(forKey: "isFirstTime") == nil) ? true : false
    //    }
    
    //    func appOpenedFirstTime(){
    //        UserDefaults.standard.set("Yes", forKey: "isFirstTime")
    //    }
    
    //    func getFireBaseTime(completion: @escaping (Date?) -> Void){
    //        let firebaseRef = Database.database().reference(withPath: "iOS_TimeStamp")//Firebas
    //        // Tell the server to set the current timestamp at this location.
    //        firebaseRef.setValue(ServerValue.timestamp())
    //
    //        // Read the value at the given location. It will now have the time.
    //        firebaseRef.observeSingleEvent(of: .value) { (snapshot) in
    //            if let time = snapshot.value as? TimeInterval {
    //                // Cast the value to an NSTimeInterval
    //                // and divide by 1000 to get seconds.
    //                let timeInterval = Date(timeIntervalSince1970: time/1000)
    //                print(timeInterval)
    //                return completion(timeInterval)
    //            }
    //            return completion(nil)
    //        }
    //    }
    
    class func formateDate(_ date:Date, dateFormat:String) ->String
    {
        let formatrer:DateFormatter = DateFormatter();
        formatrer.dateFormat = dateFormat;
        
        return formatrer.string(from: date);
    } //F.E.
    
    func convertServerDateStrToDate(serStr: String){
        let dateStr = serStr.components(separatedBy: " GMT")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE, dd MMM yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        setServerDate(date: dateFormatter.date(from: dateStr.first!))
    }
    
    func getServerDate() -> Date{
        return UserDefaults.standard.value(forKey: "ServerDate") as? Date ?? Date()
    }
    
    func setServerDate(date: Date?){
        UserDefaults.standard.set(date, forKey: "ServerDate")
    }
    
    class func convertDateFormater(_ date: String, oldFormat:String, newFormat:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = oldFormat
        let date = dateFormatter.date(from: date)
        if let date = date{
            dateFormatter.dateFormat = newFormat
            return  dateFormatter.string(from: date)
        }
        return ""
    }
    
    func getAge(dob : String) -> String{
           let convertIntoDate = DateFormatterHelper.convertStringToDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", stringToConvert: dob, isUTC: false)
                  
                  //2 - get today date
                  let today = Date()
                  
                  //3 - create an instance of the user's current calendar
                  let calendar = Calendar.current
                  
                  //4 - use calendar to get difference between two dates
                  let components = calendar.dateComponents([.year, .month, .day], from: convertIntoDate!, to: today)
                  
                  let ageYears  = components.year
                  let ageMonths = components.month
                  let ageDays   = components.day
                  
                  if ageYears! != 0 {
                      let age = "\(ageYears!) years \(ageMonths!) months"
                      return age
                  }
                  else if ageMonths == 0 {
                      let age = "\(ageDays!) days"
                      return age
                  }
                  else {
                      let age = "\(ageMonths!) months"
                      return age
                  }
           
       }
    
    func getMonthInLetters(month: Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return "Log.wtf()"
        }
    }
}

enum JobStatusType:Int{
    case requested = 5 , accepted = 10, arrived = 15, barberCancelled = 20, userCanceled = 25, completed = 30, reviewed = 35
}

struct JobStatus {
    static let REQUESTED = 5
    static let REJECTED = 6
    static let ACCEPTED = 10
    static let ON_THE_WAY = 11
    static let ARRIVED = 15
    static let UNSERVED = 16
    static let BARBER_CANCELLED = 20
    static let USER_CANCELLED = 25
    static let BARBER_MARKED_COMPLETED = 26
    static let COMPLETED = 30
    static let REVIEWED = 35
    static let BARBER_REVIEWED = 40
}

enum ServicesState {
    case today
    case upcoming
    case pending
}

struct StopWatch {

    var totalSeconds: Int

    var years: Int {
        return totalSeconds / 31536000
    }

    var days: Int {
        return (totalSeconds % 31536000) / 86400
    }

    var hours: Int {
        return (totalSeconds % 86400) / 3600
    }

    var minutes: Int {
        return (totalSeconds % 3600) / 60
    }

    var seconds: Int {
        return totalSeconds % 60
    }

    //simplified to what OP wanted
    var hoursMinutesAndSeconds: (hours: Int, minutes: Int, seconds: Int) {
        return (hours, minutes, seconds)
    }
}

//REQUESTED: 5,
//ACCEPTED: 10,
//ARRIVED: 15,
//BARBER_CANCELLED: 20,
//USER_CANCELLED: 25,
//COMPLETED: 30,
//REVIEWED: 35
