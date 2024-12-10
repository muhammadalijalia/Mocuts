//
//  AppDelegate.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 19/07/2021.
//

import UIKit
import GooglePlaces
import FBSDKCoreKit
import GoogleSignIn
import AuthenticationServices
import Firebase
import PlacesPicker
import FirebaseMessaging
import Stripe
import Helpers

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let networkAdapter : NetworkChangeNotifiable = NetworkChangeClass()
    var notificationHandler = NotificationHandler()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        StripeAPI.defaultPublishableKey = Constants.stripePublishableKey
        
        GMSPlacesClient.provideAPIKey(Constants.googleApisKey)
        PlacePicker.configure(googleMapsAPIKey: Constants.googleApisKey, placesAPIKey: Constants.googleApisKey)

        settingIQKeyBoard()
        initializeLoader()
        Router.configuration = RouterConfiguration.init(baseURL: Enviroment.baseURL, authorizationToken: nil)
        
        let vc: AnimatedLaunchScreenVC = AppRouter.instantiateViewController(storyboard: .main)
        let nvc = UINavigationController(rootViewController: vc)
        AppRouter.makeNewRootVC(rootVC: nvc, shouldAnimate: false)
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
                // Show the app's signed-in state.
            }
        }
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        self.setupPush()
        UserPreferences.fcmToken = "ABC 123"
        Messaging.messaging().delegate = self
        application.applicationIconBadgeNumber = 0 // For Clear Badge Counts
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barTintColor = UIColor(hex: "#04396C")
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        return false
    }

    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene sessionp is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setupPush() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    //MARK: PUSH NOTIFICATION DELEGATES
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        switch UIApplication.shared.applicationState {
            //Update Notification badges
            case .active:
                print("active")
                break
                //Handle notification when app is is in background/inactive but not killed
            case .background, .inactive:
                print("bg/inactive")
            default:break
        }
        completionHandler(.newData)
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print("deviceToken:\nlol")
        Messaging.messaging().apnsToken = deviceToken
        
        //MARK: Must `retrieveFCMToken` after device token is set
        Messaging.messaging().retrieveFCMToken(forSenderID: Constants.senderId , completion: { token, error in
            if error == nil {
                print("fcmToken:\n\(token ?? "")")
                UserPreferences.fcmToken = token ?? "ABC 123"
            }
        })
//        Messaging.messaging().subscribe(toTopic: "topic1")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
//        let notificationData = notification.request.content.userInfo
        
        switch UIApplication.shared.applicationState {
            case .active:
                break
            default:break
        }
        if #available(iOS 14.0, *) {
            completionHandler([[.banner, .sound]])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("notification received")
        let userInfo = response.notification.request.content.userInfo as! [String : Any]
        switch UIApplication.shared.applicationState {
        case .active:
            notificationHandler.shouldDelay = false
            notificationHandler.handleNotification(dataObj: userInfo)
        case .inactive:
            notificationHandler.shouldDelay = true
            notificationHandler.handleNotification(dataObj: userInfo)
        case .background:
            Timer.scheduledTimer(withTimeInterval: 3.6, repeats: false, block: { [weak self] timer in
                timer.invalidate()
                guard let self = self else { return }
                self.notificationHandler.shouldDelay = true
                self.notificationHandler.handleNotification(dataObj: userInfo)
            })
        @unknown default:
            self.notificationHandler.handleNotification(dataObj: userInfo)
        }

        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [response.notification.request.identifier])
        completionHandler()
    }
}

//MARK: MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        guard let fcmToken = fcmToken else { return }
        let tokenDict = ["token": fcmToken]
        UserPreferences.fcmToken = fcmToken
        print("fcmToken:\n\(fcmToken)")
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: tokenDict)
    }
}
