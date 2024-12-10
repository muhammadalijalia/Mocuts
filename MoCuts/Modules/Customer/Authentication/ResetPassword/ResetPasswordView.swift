//
//  ResetPasswordView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

//@available(iOS 13.0, *)
class ResetPasswordView: BaseView, Routeable {
    
    @IBOutlet weak var newPasswordField : UITextField!
    @IBOutlet weak var confirmNewPasswordField : UITextField!
    @IBOutlet weak var resetPasswordBtn : MoCutsAppButton!
    @IBOutlet weak var confirmPasswordEye : UIImageView!
    @IBOutlet weak var passwordEye : UIImageView!

    var passwordEyeBool : Bool = false
    var confirmPasswordEyeBool : Bool = false
    var email : String = ""
    var code : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ResetPasswordViewModel()
        (viewModel as! ResetPasswordViewModel).email = self.email
        (viewModel as! ResetPasswordViewModel).code = self.code
        resetPasswordSuccessRoute()
        passwordNotMatched()
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
    
    func setView(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, title: "", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: .white, itemsColor: .black,  vc: self)
        }
        
        self.newPasswordField.delegate = self
        self.confirmNewPasswordField.delegate = self
        
        self.passwordEye.tintColor = UIColor(hex: "#9A9A9A")
        self.confirmPasswordEye.tintColor = UIColor(hex: "#9A9A9A")
        self.newPasswordField.textColor = UIColor(hex: "#212021")
        self.confirmNewPasswordField.textColor = UIColor(hex: "#212021")
        self.newPasswordField.isUserInteractionEnabled = true
        self.confirmNewPasswordField.isUserInteractionEnabled = true

        
        self.newPasswordField.autocapitalizationType = .none
        self.newPasswordField.keyboardType = .default
        self.newPasswordField.layer.borderColor = UIColor.lightGray.cgColor
        self.newPasswordField.layer.borderWidth = 1.0
        self.newPasswordField.layer.cornerRadius = 4
        self.newPasswordField.delegate = self
        self.newPasswordField.setLeftPaddingPoints(5)
        self.newPasswordField.setRightPaddingPoints(30)
        
        self.confirmNewPasswordField.autocapitalizationType = .none
        self.confirmNewPasswordField.keyboardType = .default
        self.confirmNewPasswordField.layer.borderColor = UIColor.lightGray.cgColor
        self.confirmNewPasswordField.layer.borderWidth = 1.0
        self.confirmNewPasswordField.layer.cornerRadius = 4
        self.confirmNewPasswordField.delegate = self
        self.confirmNewPasswordField.setLeftPaddingPoints(5)
        self.confirmNewPasswordField.setRightPaddingPoints(30)
        
    }
    
    @IBAction func passwordEye(_ sender : UIButton) {
        if passwordEyeBool {
            passwordEyeBool = false
            passwordEye.image = UIImage(named: "closedEye")
            self.passwordEye.image = UIImage(named: "closedEye")?.withRenderingMode(.alwaysTemplate)
            newPasswordField.isSecureTextEntry = true
        } else {
            passwordEyeBool = true
            passwordEye.image = UIImage(named: "openEye")
            self.passwordEye.image = UIImage(named: "openEye")?.withRenderingMode(.alwaysTemplate)
            newPasswordField.isSecureTextEntry = false
        }
    }
    
    @IBAction func confirmPasswordEye(_ sender : UIButton) {
        if confirmPasswordEyeBool {
            confirmPasswordEyeBool = false
            self.confirmPasswordEye.image = UIImage(named: "closedEye")?.withRenderingMode(.alwaysTemplate)
            confirmNewPasswordField.isSecureTextEntry = true
        } else {
            confirmPasswordEyeBool = true
            self.confirmPasswordEye.image = UIImage(named: "openEye")?.withRenderingMode(.alwaysTemplate)
            confirmNewPasswordField.isSecureTextEntry = false
        }
    }
    
    func setButton() {
        self.resetPasswordBtn.buttonColor = .orange
        self.resetPasswordBtn.setText(text: "Reset Password")
        self.resetPasswordBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            self.newPasswordField.resignFirstResponder()
            self.confirmNewPasswordField.resignFirstResponder()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                (self.viewModel as! ResetPasswordViewModel).resetPassword(newPassword: self.newPasswordField.text ?? "", confirmNewPassword: self.confirmNewPasswordField.text ?? "")
            }
        })
    }
    
    func errorTextMessage() {
        (self.viewModel as! ResetPasswordViewModel).validateField = { [weak self] errorText in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                ToastView.getInstance().showToast(inView: self.view, textToShow: errorText,backgroundColor: Theme.appOrangeColor)
            }
        }
    }
        
    func resetPasswordSuccessRoute() {
        (self.viewModel as! ResetPasswordViewModel).setResetPasswordRoute = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                let vc : LoginView
                    = AppRouter.instantiateViewController(storyboard: .authentication)
                let nvc = UINavigationController(rootViewController: vc)
                Alert.showAlert(title: "", message: "Password changed sucessfully!", vc: self) { (status) in
                    if status!
                    {
                        Helper.getInstance.makeSpecificViewRoot(vc: nvc)
                    }
                }
            }
        }
    }
    
    func passwordNotMatched() {
        (viewModel as! ResetPasswordViewModel).validatePassword = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                ToastView.getInstance().showToast(inView: self.view, textToShow: "Password doesn't match.",backgroundColor: Theme.appOrangeColor)
            }
        }
    }
}

extension ResetPasswordView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newPasswordField{
            textField.resignFirstResponder()
            _ = confirmNewPasswordField.becomeFirstResponder()
        } else if textField == confirmNewPasswordField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.canBeConverted(to: String.Encoding.ascii){
             return false
        }
        
        if textField == newPasswordField || textField == confirmNewPasswordField {
            let maxLength = 100
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}
