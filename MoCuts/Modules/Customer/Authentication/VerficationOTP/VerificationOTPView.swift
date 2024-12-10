//
//  VerificationOTPView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

//@available(iOS 13.0, *)
class VerificationOTPView: BaseView, Routeable, UITextFieldDelegate {
    
    enum ScreenCase {
        case newUser
        case forgetPassword
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var resendBtnOutlet: UIButton!
    @IBOutlet weak var resendBtnView: UIView!
    @IBOutlet weak var notRecievedView: UIView!
    @IBOutlet weak var updatePhoneOutlet: UIButton!
    @IBOutlet weak var verifyBtn: MoCutsAppButton!
    @IBOutlet weak var txtfield1 : UITextField!
    @IBOutlet weak var txtfield2 : UITextField!
    @IBOutlet weak var txtfield3 : UITextField!
    @IBOutlet weak var txtfield4 : UITextField!
    @IBOutlet weak var timmerLabel: UILabel!
    
    var countdownTimer: Timer!
    var totalTime = 5
    var isFromForgetPass : Bool = false
    var email : String = ""
    var screenCase : ScreenCase = .newUser
    var userModel : User_Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = VerificationOTPViewModel()
        
        
        verificationSuccessRoute()
        self.notRecievedView.isHidden = false
        self.startTimer()
        txtfield1.delegate = self
        txtfield2.delegate = self
        txtfield3.delegate = self
        txtfield4.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .darkContent
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setView()
        setButton()
    }
    
    func setView(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        if screenCase == .newUser {
            self.email = userModel?.email ?? ""
            (viewModel as! VerificationOTPViewModel).email = self.email
            self.emailLabel.text = self.email
        } else {
            (viewModel as! VerificationOTPViewModel).email = self.email
            self.emailLabel.text = self.email
        }
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, title: "", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: .white, itemsColor: .black,  vc: self)
        }
        
        self.txtfield1.font = Theme.getAppMediumFont(withSize: 30)
        self.txtfield2.font = Theme.getAppMediumFont(withSize: 30)
        self.txtfield3.font = Theme.getAppMediumFont(withSize: 30)
        self.txtfield4.font = Theme.getAppMediumFont(withSize: 30)
        
        self.txtfield1.keyboardType = .numberPad
        self.txtfield2.keyboardType = .numberPad
        self.txtfield3.keyboardType = .numberPad
        self.txtfield4.keyboardType = .numberPad
        self.txtfield1.textAlignment = .center
        self.txtfield2.textAlignment = .center
        self.txtfield3.textAlignment = .center
        self.txtfield4.textAlignment = .center
        
        (viewModel as! VerificationOTPViewModel).setFields(txtbox1: txtfield1, txtbox2: txtfield2, txtbox3: txtfield3, txtbox4: txtfield4)
        
        txtfield1.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        txtfield2.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        txtfield3.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        txtfield4.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    func setButton() {
        self.verifyBtn.buttonColor = .orange
        self.verifyBtn.setText(text: "Verify")
        self.verifyBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            self.txtfield1.resignFirstResponder()
            self.txtfield2.resignFirstResponder()
            self.txtfield3.resignFirstResponder()
            self.txtfield4.resignFirstResponder()

            
            (self.viewModel as! VerificationOTPViewModel).verifyOTP(txtbox1: self.txtfield1.text ?? "", txtbox2: self.txtfield2.text ?? "", txtbox3: self.txtfield3.text ?? "", txtbox4: self.txtfield4.text ?? "")
        })
    }
    
    func startTimer() {
        self.resendBtnView.isHidden = true
        self.resendBtnOutlet.isHidden = true
        self.notRecievedView.isHidden = false
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timmerLabel.text = "\(timeFormatted(totalTime))"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        self.notRecievedView.isHidden = true
        self.resendBtnView.isHidden = false
        self.resendBtnOutlet.isHidden = false
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func verificationSuccessRoute() {
        
        (self.viewModel as! VerificationOTPViewModel).failure = { [weak self] in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.txtfield1.text = ""
                self.txtfield2.text = ""
                self.txtfield3.text = ""
                self.txtfield4.text = ""
//                self.txtfield1.becomeFirstResponder()
            }
        }
        
        (self.viewModel as! VerificationOTPViewModel).setVerificationRoute = { [weak self] code in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                if self.screenCase == .forgetPassword {
                    let vc : ResetPasswordView = AppRouter.instantiateViewController(storyboard: .authentication)
                    vc.email = self.email
                    vc.code = code
                    self.route(to: vc, navigation: .push)
                } else if self.screenCase == .newUser {
                    if self.userModel?.role == 2 {
                        let vc : TabBarView
                            = AppRouter.instantiateViewController(storyboard: .tabbar)
                        let nvc = UINavigationController(rootViewController: vc)
                        Helper.getInstance.makeSpecificViewRoot(vc: nvc)
                    } else if self.userModel?.role == 3 {
                        let vc : BarberTabBarView
                            = AppRouter.instantiateViewController(storyboard: .Barbertabbar)
                        let nvc = UINavigationController(rootViewController: vc)
                        Helper.getInstance.makeSpecificViewRoot(vc: nvc)
                    }
                }
            }
        }
    }
    
    @objc func textFieldDidChange(textField : UITextField){
        let text = textField.text
        if text?.count == 1{
            switch textField {
            case txtfield1:
                txtfield2.becomeFirstResponder()
            case txtfield2:
                txtfield3.becomeFirstResponder()
            case txtfield3:
                txtfield4.becomeFirstResponder()
            case txtfield4:
                txtfield4.becomeFirstResponder()
            default:
                break
            }
        }
        if text?.count == 0 {
            switch textField {
            case txtfield1:
                txtfield1.becomeFirstResponder()
            case txtfield2:
                txtfield1.becomeFirstResponder()
            case txtfield3:
                txtfield2.becomeFirstResponder()
            case txtfield4:
                txtfield3.becomeFirstResponder()
            default:
                break
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.canBeConverted(to: String.Encoding.ascii){
             return false
        }
        
        let newLength = (textField.text ?? "").count + string.count - range.length
        if newLength > 1 {
            return false
        }
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                print("Backspace was pressed")
                //(viewModel as! VerificationViewModel).didPressClear()
            }
        }
        return true
    }
    
    private func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    @IBAction func resendVerificationCode(_ sender: Any) {
        totalTime = 5
        self.timmerLabel.isHidden = false
        self.startTimer()
        if screenCase == .newUser
        {
            (viewModel as! VerificationOTPViewModel).forgetPassword(isForgot: 1)
        }
        else
        {
            (viewModel as! VerificationOTPViewModel).forgetPassword()
        }
    }
}
