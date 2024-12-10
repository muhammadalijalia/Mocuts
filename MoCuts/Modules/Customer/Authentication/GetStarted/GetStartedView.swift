//
//  GetStartedView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 20/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

enum UserMode {
    case customer
    case barber
}

//@available(iOS 13.0, *)
class GetStartedView: BaseView, Routeable {
    
    @IBOutlet weak var signUpAsCustomer : MoCutsAppButton!
    @IBOutlet weak var signUpAsBarber : MoCutsAppButton!
    @IBOutlet weak var versionLabel: UILabel!
    var userMode : UserMode = .customer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GetStartedViewModel()
        self.setView()
        print("device \(UIDevice.current.modelName)")
        setVersion()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setButton()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .darkContent
        }
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setVersion() {
        
        versionLabel.text = "v\(UIApplication.shared.getAppVersion())"
    }
    
    func setButton() {
        self.signUpAsCustomer.buttonColor = .orange
        self.signUpAsCustomer.setText(text: "Sign Up as Customer")
        self.signUpAsCustomer.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            let vc : SignUpView = AppRouter.instantiateViewController(storyboard: .authentication)
            vc.userMode = .customer
            self.route(to: vc, navigation: .push)
        })
        
        self.signUpAsBarber.buttonColor = .clear
        self.signUpAsBarber.setText(text: "Sign Up as Barber")
        self.signUpAsBarber.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            let vc : SignUpView = AppRouter.instantiateViewController(storyboard: .authentication)
            vc.userMode = .barber
            self.route(to: vc, navigation: .push)
        })
    }
    
    @IBAction func signIn(_ sender : UIButton) {
        let vc : LoginView = AppRouter.instantiateViewController(storyboard: .authentication)
        self.route(to: vc, navigation: .push)
    }
}
