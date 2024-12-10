//
//  LoginVIew.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 20/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
import Firebase

//@available(iOS 13.0, *)
class LoginView: BaseView, Routeable {
    
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var passwordField : UITextField!
    @IBOutlet weak var passwordEye : UIImageView!
    @IBOutlet weak var signInBtn : MoCutsAppButton!
    
    var passwordEyeBool : Bool = false
    var userMode : UserMode = .customer
    var strEmail : String = ""
    var strID : String = ""
    var strName : String = ""
    var tokenString : String = ""
    var socialPlatform : String = ""
    var clientId : String = ""
    var dbRef: DatabaseReference!
    var firebaseParam = [String:String]()
    var errorType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel()
        setLoginSuccessRoute()
        errorTextMessage()
        dbRef = Database.database().reference()
        
        if errorType == "show" {
            DispatchQueue.main.async {
                ToastView.getInstance().showToast(inView: self.view, textToShow: "You must be authorized to complete this request!",backgroundColor: Theme.appOrangeColor)
            }
        }
        
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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.emailField.isUserInteractionEnabled = true
        self.passwordField.isUserInteractionEnabled = true
        
        self.emailField.textColor = UIColor(hex: "#212021")
        self.emailField.autocapitalizationType = .none
        self.emailField.keyboardType = .emailAddress
        self.emailField.layer.borderColor = UIColor.lightGray.cgColor
        self.emailField.layer.borderWidth = 1.0
        self.emailField.layer.cornerRadius = 4
        self.emailField.delegate = self
        self.emailField.setLeftPaddingPoints(5)
        self.emailField.setRightPaddingPoints(5)
        
        self.passwordField.textColor = UIColor(hex: "#212021")
        self.passwordField.autocapitalizationType = .words
        self.passwordField.keyboardType = .default
        self.passwordField.layer.borderColor = UIColor.lightGray.cgColor
        self.passwordField.layer.borderWidth = 1.0
        self.passwordField.layer.cornerRadius = 4
        self.passwordField.delegate = self
        self.passwordField.setLeftPaddingPoints(5)
        self.passwordField.setRightPaddingPoints(30)
        
        self.passwordEye.tintColor = UIColor(hex: "#9A9A9A")
    }
    
    @IBAction func passwordEye(_ sender : UIButton) {
        if passwordEyeBool {
            passwordEyeBool = false
            passwordEye.image = UIImage(named: "closedEye")
            self.passwordEye.image = UIImage(named: "closedEye")?.withRenderingMode(.alwaysTemplate)
            passwordField.isSecureTextEntry = true
        } else {
            passwordEyeBool = true
            passwordEye.image = UIImage(named: "openEye")
            self.passwordEye.image = UIImage(named: "openEye")?.withRenderingMode(.alwaysTemplate)
            passwordField.isSecureTextEntry = false
        }
    }
    
    func errorTextMessage() {
        (self.viewModel as! LoginViewModel).validateField = { [weak self] errorText in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                ToastView.getInstance().showToast(inView: self.view, textToShow: errorText,backgroundColor: Theme.appOrangeColor)
            }
        }
    }
    
    func setButton() {
        self.signInBtn.buttonColor = .orange
        self.signInBtn.setText(text: "Sign In")
        self.signInBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            self.emailField.resignFirstResponder()
            self.passwordField.resignFirstResponder()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                (self.viewModel as! LoginViewModel).login(email: self.emailField.text ?? "", password: self.passwordField.text ?? "")
            }
        })
    }
    
    func setLoginSuccessRoute() {
        (self.viewModel as! LoginViewModel).setLoginRoute = { [weak self] userModel in
            guard let self = self else {
                return
            }
            if userModel.is_verified == 1 {
                if userModel.role == 2 {
                    DispatchQueue.main.async{
                        let vc : TabBarView
                            = AppRouter.instantiateViewController(storyboard: .tabbar)
                        let nvc = UINavigationController(rootViewController: vc)
                        Helper.getInstance.makeSpecificViewRoot(vc: nvc)
                    }
                } else if userModel.role == 3 {
                    DispatchQueue.main.async{
                        let vc : BarberTabBarView
                            = AppRouter.instantiateViewController(storyboard: .Barbertabbar)
                        let nvc = UINavigationController(rootViewController: vc)
                        Helper.getInstance.makeSpecificViewRoot(vc: nvc)
                    }
                }
            } else if userModel.is_verified == 0 {
                DispatchQueue.main.async{
                    let vc : VerificationOTPView
                        = AppRouter.instantiateViewController(storyboard: .authentication)
                    vc.screenCase = .newUser
                    vc.userModel = userModel
                    self.route(to: vc, navigation: .push)
                }
            }
        }
    }
    
    @IBAction func forgetPasswordBtn(_ sender : UIButton) {
        let vc : ForgetPasswordView = AppRouter.instantiateViewController(storyboard: .authentication)
        self.route(to: vc, navigation: .push)
    }
    
    @IBAction func signUpBtn(_ sender : UIButton) {
        self.routeBack(navigation: .popToRootVC)
//        let vc: GetStartedView = AppRouter.instantiateViewController(storyboard: .authentication)
//        self.route(to: vc, navigation: .push)
        
    }
    
    @IBAction func btnFb(_ sender: UIButton) {
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { loginResult, error in
        
//            loginManager.logOut()
            if error != nil {
                
            } else {
                if let result = loginResult {
                    if result.isCancelled {
                        print("cancelled")
                    } else {
                        self.tokenString = result.token?.tokenString ?? ""
                        self.socialPlatform = result.token?.graphDomain ?? ""
                        self.clientId = result.token?.userID ?? ""
                        print(result.grantedPermissions)
                        print(result.declinedPermissions)
                        
                        if result.grantedPermissions.contains("email") {
                            self.returnUserData()
                            loginManager.logOut()
                        }
                    }
                }
            }
        }
    }
    
    func returnUserData() {
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(normal), email"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
            } else {
                let resultDic = result as! NSDictionary
                
                self.strEmail = ((resultDic as AnyObject).value(forKey: "email") as? String) ?? ""
                self.strID = ((resultDic as AnyObject).value(forKey: "id") as? String) ?? ""
                self.strName = ((resultDic as AnyObject).value(forKey: "name") as? String) ?? ""
                
                (self.viewModel as! LoginViewModel).socialLogin(name: self.strName, email: self.strEmail, role: 2, socialPlatform: self.socialPlatform, clientId: self.clientId, token: self.tokenString)
            }
        })
    }
    
    @IBAction func btnGoogle(_ sender: UIButton) {
        let signInConfig = GIDConfiguration.init(clientID: "1085995696151-9k737nha3i4ihlvrcsoi7mrk3lh31smn.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = signInConfig
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else { return }
            guard let user = result?.user else { return }
            let emailAddress = user.profile?.email
            let fullName = user.profile?.name
            let userId = user.userID
            let idToken = user.idToken?.tokenString
            
            (self.viewModel as! LoginViewModel).socialLogin(name: fullName ?? "", email: emailAddress ?? "", role: 2, socialPlatform: "google", clientId: userId ?? "", token: idToken ?? "")
        }
    }
    
    @IBAction func btnApple(_ sender: UIButton) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension LoginView: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let appleID = appleIDCredential.user
            let fullName = (appleIDCredential.fullName?.givenName ?? "") + " " + (appleIDCredential.fullName?.familyName ?? "")
            let email = appleIDCredential.email ?? ""
            print("User id is \(appleID) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            if fullName.isEmpty || email.isEmpty {
                let iD = appleID.replacingOccurrences(of: ".", with: "+", options: .literal, range: nil)
                print(iD)
                
                dbRef.child("Users/Apple/\(iD)").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? [String : AnyObject] ?? [:]
                    print(value)
                    
                    let email  = (value["email"] as? String) ?? ""
                    let userName  = (value["userName"] as? String) ?? ""
                    
                    (self.viewModel as! LoginViewModel).socialLogin(name: userName, email: email, role: 2, socialPlatform: "apple", clientId: appleID, token: appleID)
                })
            } else {
                firebaseParam.updateValue(appleID, forKey: "iD")
                
                if !email.isEmpty  {
                    //SharedManager.shared.getAppleUserEmail = email
                    firebaseParam.updateValue(email, forKey: "email")
                }
                else {
                    let dummyEmail = "\(appleID)@mail.com"
                    firebaseParam.updateValue(dummyEmail, forKey: "email")
                }
                
                if !fullName.isEmpty  {
                    //SharedManager.shared.getAppleUserName = fullName
                    firebaseParam.updateValue(fullName, forKey: "userName")
                }
                
                let iD = appleID.replacingOccurrences(of: ".", with: "+", options: .literal, range: nil)
                
                if !fullName.isEmpty {
                    dbRef.child("Users/Apple/\(iD)").setValue(self.firebaseParam)
                }
                
                (viewModel as! LoginViewModel).socialLogin(name: fullName, email: email, role: 2, socialPlatform: "apple", clientId: appleID, token: appleID)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension LoginView: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.canBeConverted(to: String.Encoding.ascii){
             return false
        }
        
        if textField == passwordField {
            let maxLength = 100
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}
