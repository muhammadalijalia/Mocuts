//
//  UserPreferences.swift
//  MoCuts
//
//  Created by Saif Ahmed  on 27/09/2021.
//

import Foundation
import ObjectMapper

class UserPreferences {
    
    class func clearPreference() {
            
//        let appDomain:NSString = Bundle.main.bundleIdentifier! as NSString;
//        UserDefaults.standard.removePersistentDomain(forName: appDomain as String);
        authToken = ""
        accessToken = nil
        userModel = nil
        
    }
    
    class var authToken:String{
        get{
            let userDefaults:UserDefaults = UserDefaults.standard;
            
            if let token:String = userDefaults.object(forKey: "auth_token") as? String {
                return token
            }
            return ""
        }
        set{
            let userDefaults:UserDefaults = UserDefaults.standard;
            userDefaults.set(newValue, forKey: "auth_token")
            userDefaults.synchronize();
        }
    }
    
    class var fcmToken:String {
        get{
            let userDefaults:UserDefaults = UserDefaults.standard;

            if let token:String = userDefaults.object(forKey: "fcmToken") as? String {
                return token
            }
            return ""
        }
        set{
            let userDefaults:UserDefaults = UserDefaults.standard;
            userDefaults.set(newValue, forKey: "fcmToken")
            userDefaults.synchronize();
        }
    }
    
    class var accessToken: Access_token? {
        get {
            let defaults = UserDefaults.standard
            if
                let data = defaults.data(forKey: "accessToken"),
                let user = try? JSONDecoder().decode(Access_token.self, from: data)
            {
                return user
            }
            return nil
        }
        
        set {
            let user = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(user, forKey: "accessToken")
        }
    }
    
    class var userModel: User_Model? {
            get {
                let defaults = UserDefaults.standard
                if
                    let data = defaults.data(forKey: "currentUser"),
                    let user = try? JSONDecoder().decode(User_Model.self, from: data)
                {
                    return user
                }
                return nil
            }
            
            set {
                let user = try? JSONEncoder().encode(newValue)
                UserDefaults.standard.set(user, forKey: "currentUser")
            }
        }
    
//    class var userModel: User_Model? {
//        get {
//            let userDefaults:UserDefaults = UserDefaults.standard;
//
//            if let data:Data = userDefaults.object(forKey: "user_model") as? Data {
//
//                do {
//                    /* NSDictionary to NSData */
//                    let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? User_Model//try NSKeyedUnarchiver.unarchivedObject(ofClass: User.self, from: data)
//                    return user
//
//                } catch { print(error) }
//
//            }
//            else {
//                return nil;
//            }
//            return nil;
//        }
//        set {
//            let userDefaults:UserDefaults = UserDefaults.standard;
//
//
//            do {
//                /* NSDictionary to NSData */
//                let data = try NSKeyedArchiver.archivedData(withRootObject: newValue!, requiringSecureCoding: true);
//
//                userDefaults.set(data, forKey: "user_model");
//                userDefaults.synchronize();
//            } catch {
//                print(error)
//
//            }
//
//
//
//        }
//    }
}
