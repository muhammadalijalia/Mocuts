//
//  BarberChangePasswordView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class BarberChangePasswordView: BaseView, Routeable {
    
    @IBOutlet weak var currentPasswordField : AppFieldView!
    @IBOutlet weak var newPasswordField : AppFieldView!
    @IBOutlet weak var confirmNewPasswordField : AppFieldView!
    @IBOutlet weak var changePasswordBtn : MoCutsAppButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BarberChangePasswordViewModel()
        self.setView()
        changePasswordSuccessRoute()
        passwordNotMatched()
    }
    
    func setButton() {
        self.changePasswordBtn.buttonColor = .orange
        self.changePasswordBtn.setText(text: "Change Password")
        self.changePasswordBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            (self.viewModel as! BarberChangePasswordViewModel).changePassword(currentPassword: self.currentPasswordField.textBoxViewModel, newPassword: self.newPasswordField.textBoxViewModel, confirmNewPassword: self.confirmNewPasswordField.textBoxViewModel)
        })
    }
    
    func changePasswordSuccessRoute() {
        (self.viewModel as! ChangePasswordViewModel).setChangePasswordRoute = {
            self.routeBack(navigation: .pop)
        }
    }
    
    func passwordNotMatched() {
        (viewModel as! BarberChangePasswordViewModel).validatePassword = {
            DispatchQueue.main.async {
                ToastView.getInstance().showToast(inView: self.view, textToShow: "Passwords do not match.",backgroundColor: Theme.appOrangeColor)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setButton()
    }
    
    @objc func editBtnTapped() {
        
    }
    
    func setView(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, title: "Change Password", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
            
            
            TextFieldHandler.shared.register(textFields: [currentPasswordField.textField, newPasswordField.textField, confirmNewPasswordField.textField, ])
            
            self.currentPasswordField.setCustomFieldView(titleTxt: "Current Password",
                                                         typeOfView: .password,
                                                         placeholder: "Current Password",rightImage: UIImage(named: "closedEye"),
                                                         isRequiredField: false,
                                                         rightBtnAction: { _ in
                                                           self.currentPasswordField.textField.isSecureTextEntry = !self.currentPasswordField.textField.isSecureTextEntry
                                                         },
                                                         validation: .normal_password)
            
            self.newPasswordField.setCustomFieldView(titleTxt: "New Password",
                                                     typeOfView: .password,
                                                     placeholder: "New Password",rightImage: UIImage(named: "closedEye"),
                                                     isRequiredField: false,
                                                     rightBtnAction: { _ in
                                                       self.newPasswordField.textField.isSecureTextEntry = !self.newPasswordField.textField.isSecureTextEntry
                                                     },
                                                     validation: .normal_password)
            
            self.confirmNewPasswordField.setCustomFieldView(titleTxt: "Confirm New Password",
                                                            typeOfView: .password,
                                                            placeholder: "Confirm New Password",rightImage: UIImage(named: "closedEye"),
                                                            isRequiredField: false,
                                                            rightBtnAction: { _ in
                                                              self.confirmNewPasswordField.textField.isSecureTextEntry = !self.confirmNewPasswordField.textField.isSecureTextEntry
                                                            },
                                                            validation: .normal_password)
            
            self.currentPasswordField.textField.autocapitalizationType = .none
            self.currentPasswordField.textField.keyboardType = .default
            
            self.newPasswordField.textField.autocapitalizationType = .none
            self.newPasswordField.textField.keyboardType = .default
            
            self.confirmNewPasswordField.textField.autocapitalizationType = .none
            self.confirmNewPasswordField.textField.keyboardType = .default
        }
    }
}
