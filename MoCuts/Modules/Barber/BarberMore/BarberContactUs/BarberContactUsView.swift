//
//  BarberContactUsView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 17/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import IQKeyboardManagerSwift

class BarberContactUsView: BaseView, Routeable {
    
    @IBOutlet weak var fullNameField : UITextField!
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var messageField : UITextView!
    @IBOutlet weak var messagePlaceholder : UILabel!
    @IBOutlet weak var phone : UILabel!
    @IBOutlet weak var email : UILabel!
    @IBOutlet weak var submitBtn : MoCutsAppButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BarberContactUsViewModel()
        setupViewModelObserver()
    }
    
    func setupViewModelObserver() {
        (viewModel as! BarberContactUsViewModel).setContactUsRoute = { [weak self] response in
            guard let self = self else { return }
            self.routeBack(navigation: .pop)
        }
        (viewModel as! BarberContactUsViewModel).setSettingsRoute = { [weak self] phone, email in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.email.text = email
                self.phone.text = phone
            }
        }
        (viewModel as! BarberContactUsViewModel).getSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setView()
        self.setData()
        self.setButton()
        self.showErrorText()
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func setData() {
        fullNameField.text = UserPreferences.userModel?.name ?? ""
        emailField.text = UserPreferences.userModel?.email ?? ""
    }
    
    func setView(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, title: "Contact Us", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
        self.fullNameField.textColor = UIColor(hex: "#212021")
        self.fullNameField.isUserInteractionEnabled = true
        self.fullNameField.autocapitalizationType = .words
        self.fullNameField.keyboardType = .namePhonePad
        self.fullNameField.layer.borderColor = UIColor(hex: "#8D8D8D").cgColor
        self.fullNameField.layer.borderWidth = 1.0
        self.fullNameField.layer.cornerRadius = 4
        self.fullNameField.delegate = self
        self.fullNameField.setLeftPaddingPoints(5)
        self.fullNameField.setRightPaddingPoints(5)
        
        self.emailField.textColor = UIColor(hex: "#212021")
        self.emailField.isUserInteractionEnabled = true
        self.emailField.autocapitalizationType = .none
        self.emailField.keyboardType = .emailAddress
        self.emailField.layer.borderColor = UIColor(hex: "#8D8D8D").cgColor
        self.emailField.layer.borderWidth = 1.0
        self.emailField.layer.cornerRadius = 4
        self.emailField.delegate = self
        self.emailField.setLeftPaddingPoints(5)
        self.emailField.setRightPaddingPoints(5)
        
        self.messageField.textColor = UIColor(hex: "#212021")
        self.messageField.isUserInteractionEnabled = true
        self.messageField.autocapitalizationType = .sentences
        self.messageField.keyboardType = .default
        self.messageField.layer.borderColor = UIColor(hex: "#8D8D8D").cgColor
        self.messageField.layer.borderWidth = 1.0
        self.messageField.layer.cornerRadius = 4
        
        messageField.delegate = self
        messagePlaceholder.alpha = 1
        messageField.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func setButton() {
        self.submitBtn.buttonColor = .orange
        self.submitBtn.setText(text: "Submit")
        self.submitBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            self.fullNameField.resignFirstResponder()
            self.emailField.resignFirstResponder()
            self.messageField.resignFirstResponder()
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                (self.viewModel as! BarberContactUsViewModel).contactUs(fullName: self.fullNameField, emailID: self.emailField, message: self.messageField)
            }
        })
    }
    
    func showErrorText() {
        (viewModel as! BarberContactUsViewModel).validateField = { [weak self] text in
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                ToastView.getInstance().showToast(inView: self.view, textToShow: text,backgroundColor: Theme.appOrangeColor)
            }
        }
    }
}

extension BarberContactUsView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameField{
            textField.resignFirstResponder()
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            textField.resignFirstResponder()
            messageField.becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.canBeConverted(to: String.Encoding.ascii){
             return false
        }
        
        if textField == fullNameField {
            let maxLength = 25
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}

extension BarberContactUsView : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if !text.canBeConverted(to: String.Encoding.ascii) {
            return false
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        messagePlaceholder.alpha = textView.text.isEmpty ? 1 : 0
    }
}
