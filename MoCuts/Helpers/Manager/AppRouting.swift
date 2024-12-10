//
//  AppRouting.swift
//  MoCuts
//
//  Copyright © 2018 Appiskey. All rights reserved.
//

import Foundation
import UIKit
import  Helpers

/// App class for navigation.
class AppRouter {
    
    enum Navigation {
        case push
        case present
        case modal
    }
    
    enum BackNavigation {
        case dismiss
        case pop
        case popToRootVC
    }
    
    enum UserType {
        case barber
        case customer
        case firstTime
    }
    
    var userType : UserType = .firstTime
    /// Static function which cast class into object type from storyboard
    /// i.e let vc:SomeClassController = AppRouter.instantiateViewController(storyboard: .stordyboardname)
    /// This will cast vc automatically to SomeClassController
    ///
    /// - Parameters:
    ///   - storyboard: storyboard from listed storyboards
    ///   - bundle: can be nil which change to default automatically.
    /// - Returns: Intialized object of class.
    static func instantiateViewController<controller: UIViewController>(storyboard: UIStoryboard.Storyboard, bundle: Bundle? = nil ) -> controller {
        
        guard let viewController = UIStoryboard(name: storyboard.filename, bundle: bundle).instantiateViewController(withIdentifier: controller.identifier) as? controller else {
            fatalError("Couldn't instantiate view controller with identifier \(controller.identifier) ")
        }
        
        return viewController
    }
    
    /// Static function which cast class into object of UINib
    /// i.e let vc:SomeClassController = AppRouter.instantiateViewControllerFromNib()
    /// This will cast vc automatically to SomeClassController
    ///
    /// - Parameter bundle: can be nil which change to default automatically.
    /// - Returns: Intialized object of class.
    static func instantiateViewControllerFromNib<controller: UIViewController>(bundle: Bundle? = nil ) -> controller {
        let viewController = controller(nibName: controller.identifier, bundle: bundle)
        return viewController
    }
    
    ///setting initial root view controller
    //    static func decideAndMakeRoot(userType : UserType) {
    static func decideAndMakeRoot() {
        
        var tokenn : String = ""
        
        let authenticationRepo = AuthenticationRepository()
        authenticationRepo.getLocalUserToken { token in
            if let access_token = token {
                Router.configuration = RouterConfiguration.init(baseURL: Enviroment.baseURL, authorizationToken: access_token.token)
                tokenn = access_token.token ?? ""
                authenticationRepo.getUserProfile(from: .automatic) { user in
                    Router.configuration = RouterConfiguration.init(baseURL: Enviroment.baseURL, authorizationToken: tokenn)

                    
                    if let user = user {
                        if user.is_verified == 1 {
                            if user.role == 2 {
                                DispatchQueue.main.async {
                                    let vc : TabBarView
                                        = AppRouter.instantiateViewController(storyboard: .tabbar)
                                    let nvc = UINavigationController(rootViewController: vc)
                                    Helper.getInstance.makeSpecificViewRoot(vc: nvc)
                                }
                            } else if user.role == 3 {
                                DispatchQueue.main.async {
                                    let vc : BarberTabBarView
                                        = AppRouter.instantiateViewController(storyboard: .Barbertabbar)
                                    let nvc = UINavigationController(rootViewController: vc)
                                    Helper.getInstance.makeSpecificViewRoot(vc: nvc)
                                }
                            }

                            
                        } else if user.is_verified == 0 {
                            DispatchQueue.main.async {
                                let vc : GetStartedView
                                    = AppRouter.instantiateViewController(storyboard: .authentication)
                                let nvc = UINavigationController(rootViewController: vc)
                                Helper.getInstance.makeSpecificViewRoot(vc: nvc)
                            }
                        }
                    }
                } failureCompletion: { error in
                    let dismissButton = UIAlertAction(title: "Dismiss", style: .destructive) { (UIAlertAction) in
                        
                    }
                    Helper.getInstance.showAlert(title: "Error", message:  error.localizedDescription, actions: [dismissButton], isDefaultActionReq: false)
                }
            } else {
                DispatchQueue.main.async {
                    let vc : GetStartedView
                        = AppRouter.instantiateViewController(storyboard: .authentication)
                    let nvc = UINavigationController(rootViewController: vc)
                    Helper.getInstance.makeSpecificViewRoot(vc: nvc)
                }
            }
        }
    }
    
    static func makeNewRootVC(rootVC: UIViewController, shouldAnimate: Bool = true){
        if shouldAnimate {
            var snapshot:UIView!
            DispatchQueue.main.async {
                snapshot = (UIApplication.shared.keyWindow?.snapshotView(afterScreenUpdates: true))!
                rootVC.view.addSubview(snapshot);
                
                UIApplication.shared.keyWindow?.rootViewController = rootVC;
                UIView.transition(with: snapshot, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    snapshot.layer.opacity = 0;
                }, completion: { (status) in
                    snapshot.removeFromSuperview()
                })
            }
        } else {
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController = rootVC;
            }
        }
    }
}

// MARK: - Storyboards
extension UIStoryboard {
    
    /// Define everystoryboard name here. start your every storyboard name with capitalized string, otherwise it will crash.
    enum Storyboard : String {
        
        case authentication
        case tabbar
        case Barbertabbar
        case more
        case home
        case services
        case wallet
        case Barberwallet
        case Barberhome
        case Customernotification
        case Barbernotification
        case Barberprofile
        case Barbermore
        case Customerbarberprofile
        case Barbertrack
        case Customertrack
        case main
        
        /// Capitalize everyStoryboard name.
        var filename : String {
            return rawValue.capitalized
        }
    }
}

extension UIViewController  {
    
    /// Add functionality to every viewController to get string of it's class(viewController) name
    static var identifier: String {
        return String(describing: self)
    }
}

protocol Routeable {
    func route(to vc: UIViewController, navigation:AppRouter.Navigation)
    func routeBack(navigation backNavigation:AppRouter.BackNavigation)
}
extension Routeable where Self:UIViewController {
    
    func route(to vc: UIViewController, navigation:AppRouter.Navigation) {
        switch navigation {
        case .push:
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .present:
            DispatchQueue.main.async {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        case .modal:
            DispatchQueue.main.async {
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func routeBack(navigation backNavigation:AppRouter.BackNavigation) {
        switch backNavigation {
        case .dismiss:
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        case .pop:
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        case .popToRootVC:
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
