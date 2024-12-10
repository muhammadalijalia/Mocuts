//
//  ForgetPasswordView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import IQKeyboardManagerSwift

//@available(iOS 13.0, *)
class ForgetPasswordView: BaseView, Routeable {
    
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var sendBtn : MoCutsAppButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ForgetPasswordViewModel()
        setForgetPasswordRoute()
        errorTextMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setView()
        self.setButton()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .darkContent
        }
    }
    
    
    func errorTextMessage() {
        (self.viewModel as! ForgetPasswordViewModel).validateField = { [weak self] errorText in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                ToastView.getInstance().showToast(inView: self.view, textToShow: errorText,backgroundColor: Theme.appOrangeColor)
            }
        }
    }
    
    func setView(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, title: "", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: .white, itemsColor: .black,  vc: self)
        }
        
        self.emailField.delegate = self
        self.emailField.isUserInteractionEnabled = true
        self.emailField.textColor = UIColor(hex: "#212021")
        self.emailField.autocapitalizationType = .none
        self.emailField.keyboardType = .emailAddress
        self.emailField.layer.borderColor = UIColor.lightGray.cgColor
        self.emailField.layer.borderWidth = 1.0
        self.emailField.layer.cornerRadius = 4
        self.emailField.setLeftPaddingPoints(5)
        self.emailField.setRightPaddingPoints(5)
    }
    
    func setButton() {
        self.sendBtn.buttonColor = .orange
        self.sendBtn.setText(text: "Send")
        self.sendBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            self.emailField.resignFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                (self.viewModel as! ForgetPasswordViewModel).forgetPassword(email: self.emailField.text ?? "")
            }
        })
    }
    
    func setForgetPasswordRoute() {
        (self.viewModel as! ForgetPasswordViewModel).setForgetPasswordRoute = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                let vc : VerificationOTPView = AppRouter.instantiateViewController(storyboard: .authentication)
                vc.email = self.emailField.text ?? ""
                vc.screenCase = .forgetPassword
                self.route(to: vc, navigation: .push)
            }
        }
    }
}

extension ForgetPasswordView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            textField.resignFirstResponder()
        }
        return true
    }
}
