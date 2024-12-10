//
//  ChangePasswordView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class ChangePasswordView: BaseView, Routeable {
    
    @IBOutlet weak var currentPasswordField : UITextField!
    @IBOutlet weak var newPasswordField : UITextField!
    @IBOutlet weak var confirmNewPasswordField : UITextField!
    @IBOutlet weak var changePasswordBtn : MoCutsAppButton!
    @IBOutlet weak var currentPasswordEye : UIImageView!
    @IBOutlet weak var newPasswordEye : UIImageView!
    @IBOutlet weak var confirmNewPasswordEye : UIImageView!
    
    var currentPasswordEyeBool : Bool = false
    var newPasswordEyeBool : Bool = false
    var confirmNewPasswordEyeBool : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ChangePasswordViewModel()
        self.setView()
        changePasswordSuccessRoute()
        passwordNotMatched()
        errorTextMessage()
    }
    
    func setButton() {
        self.changePasswordBtn.buttonColor = .orange
        self.changePasswordBtn.setText(text: "Change Password")
        self.changePasswordBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            self.currentPasswordField.resignFirstResponder()
            self.newPasswordField.resignFirstResponder()
            self.confirmNewPasswordField.resignFirstResponder()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                (self.viewModel as! ChangePasswordViewModel).changePassword(currentPassword: self.currentPasswordField.text ?? "", newPassword: self.newPasswordField.text ?? "", confirmNewPassword: self.confirmNewPasswordField.text ?? "")
            }
        })
    }
    
    func changePasswordSuccessRoute() {
        (self.viewModel as! ChangePasswordViewModel).setChangePasswordRoute = { [weak self] in
            guard let self = self else {
                return
            }
            self.routeBack(navigation: .pop)
        }
    }
    
    func passwordNotMatched() {
        (viewModel as! ChangePasswordViewModel).validatePassword = { [weak self] in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                ToastView.getInstance().showToast(inView: self.view, textToShow: "Passwords do not match.",backgroundColor: Theme.appOrangeColor)
            }
        }
    }
    
    func errorTextMessage() {
        (self.viewModel as! ChangePasswordViewModel).validateField = { [weak self] errorText in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                ToastView.getInstance().showToast(inView: self.view, textToShow: errorText,backgroundColor: Theme.appOrangeColor)
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
        }
        
        self.currentPasswordField.delegate = self
        self.newPasswordField.delegate = self
        self.confirmNewPasswordField.delegate = self
        
        self.currentPasswordEye.tintColor = UIColor(hex: "#9A9A9A")
        self.newPasswordEye.tintColor = UIColor(hex: "#9A9A9A")
        self.confirmNewPasswordEye.tintColor = UIColor(hex: "#9A9A9A")

        self.currentPasswordField.textColor = UIColor(hex: "#212021")
        self.newPasswordField.textColor = UIColor(hex: "#212021")
        self.confirmNewPasswordField.textColor = UIColor(hex: "#212021")
        
        
        self.currentPasswordField.isUserInteractionEnabled = true
        self.newPasswordField.isUserInteractionEnabled = true
        self.confirmNewPasswordField.isUserInteractionEnabled = true

        
        
        self.currentPasswordField.autocapitalizationType = .none
        self.currentPasswordField.keyboardType = .default
        self.currentPasswordField.layer.borderColor = UIColor.lightGray.cgColor
        self.currentPasswordField.layer.borderWidth = 1.0
        self.currentPasswordField.layer.cornerRadius = 4
        self.currentPasswordField.setLeftPaddingPoints(5)
        self.currentPasswordField.setRightPaddingPoints(30)
        
        self.newPasswordField.autocapitalizationType = .none
        self.newPasswordField.keyboardType = .default
        self.newPasswordField.layer.borderColor = UIColor.lightGray.cgColor
        self.newPasswordField.layer.borderWidth = 1.0
        self.newPasswordField.layer.cornerRadius = 4
        self.newPasswordField.setLeftPaddingPoints(5)
        self.newPasswordField.setRightPaddingPoints(30)
        
        self.confirmNewPasswordField.autocapitalizationType = .none
        self.confirmNewPasswordField.keyboardType = .default
        self.confirmNewPasswordField.layer.borderColor = UIColor.lightGray.cgColor
        self.confirmNewPasswordField.layer.borderWidth = 1.0
        self.confirmNewPasswordField.layer.cornerRadius = 4
        self.confirmNewPasswordField.setLeftPaddingPoints(5)
        self.confirmNewPasswordField.setRightPaddingPoints(30)
    }
    
    @IBAction func currentPasswordEyeBtn(_ sender : UIButton) {
        if currentPasswordEyeBool {
            currentPasswordEyeBool = false
            self.currentPasswordEye.image = UIImage(named: "closedEye")?.withRenderingMode(.alwaysTemplate)
            self.currentPasswordField.isSecureTextEntry = true
        } else {
            currentPasswordEyeBool = true
            self.currentPasswordEye.image = UIImage(named: "openEye")?.withRenderingMode(.alwaysTemplate)
            self.currentPasswordField.isSecureTextEntry = false
        }
    }
    
    @IBAction func newPasswordEyeBtn(_ sender : UIButton) {
        if newPasswordEyeBool {
            newPasswordEyeBool = false
            self.newPasswordEye.image = UIImage(named: "closedEye")?.withRenderingMode(.alwaysTemplate)
            newPasswordField.isSecureTextEntry = true
        } else {
            newPasswordEyeBool = true
            self.newPasswordEye.image = UIImage(named: "openEye")?.withRenderingMode(.alwaysTemplate)
            newPasswordField.isSecureTextEntry = false
        }
    }
    
    @IBAction func confirmNewPasswordEyeBtn(_ sender : UIButton) {
        if confirmNewPasswordEyeBool {
            confirmNewPasswordEyeBool = false
            self.confirmNewPasswordEye.image = UIImage(named: "closedEye")?.withRenderingMode(.alwaysTemplate)
            confirmNewPasswordField.isSecureTextEntry = true
        } else {
            confirmNewPasswordEyeBool = true
            self.confirmNewPasswordEye.image = UIImage(named: "openEye")?.withRenderingMode(.alwaysTemplate)
            confirmNewPasswordField.isSecureTextEntry = false
        }
    }
}

extension ChangePasswordView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == currentPasswordField{
            textField.resignFirstResponder()
            newPasswordField.becomeFirstResponder()
        } else if textField == newPasswordField {
            textField.resignFirstResponder()
            confirmNewPasswordField.becomeFirstResponder()
        } else if textField == confirmNewPasswordField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.canBeConverted(to: String.Encoding.ascii){
             return false
        }
        
        if textField == newPasswordField || textField == confirmNewPasswordField || textField == currentPasswordField {
            let maxLength = 100
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}
