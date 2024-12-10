//
//  UITextFieldExtension.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 09/09/2020.
//  Copyright © 2020 Appiskey. All rights reserved.
//

import Foundation
import Helpers
import CommonComponents
import UIKit
/*
class PPTextField: UITextField {
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        // loadNibContent()
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        //loadNibContent()
        initialSetup()
    }
    
    enum Validation {
        case none
        case general
        case name
        case email
        case password
        case normal_password
        case phone
    }
    
    //var maxLength: Int = 150
    var fieldMaxLength : Int = 10
    var viewModel: ESTextBoxViewModel = ESTextBoxViewModel()
    
    // Function for setting textFieldView
    func setTextFieldView(placeholder: String = "",
                          title: String? = nil,
                          imageName: String? = nil,
                          validation: Validation = .general,
                          textLength: Int = 30
    ){
        
        
        self.maxLength = textLength
        viewModel.fieldValidation = validation
        self.setFieldType()
        
    }
    
    func initialSetup() {
        
        // self.addTarget(self, action: #selector(textFieldDidBeign(_:)), for: .editingDidBegin)
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // self.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEnd)
        
        //self.setTheme()
        self.delegate = self
        self.observerChangeInErrorText()
        self.observerChangeInFieldText()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let t = textField.text
        self.viewModel.setFieldText(txt: t?.safelyLimitedTo(length: maxLength) ?? "")
    }
    
    @objc func textFieldDidEnd(_ textField: UITextField) {
        
        let _ = viewModel.validate()
        
    }
    
    private func setFieldType() {
        
        self.autocorrectionType = .no
        switch viewModel.fieldValidation {
        case .email:
            self.keyboardType = .emailAddress
        case .password, .normal_password:
            self.isSecureTextEntry = true
            self.autocapitalizationType = .none
        case .phone:
            self.keyboardType = .phonePad
        case .general, .none, .name:
            self.autocapitalizationType = .words
        }
    }
    
    private func setError(with message:String) {
        ToastView.getInstance().showToast(inView: self, textToShow: message)
    }
    
    private func observerChangeInFieldText(){
        viewModel.textFieldTextSetted = { (text) in
            DispatchQueue.main.async {
                self.text = text
            }
        }
    }
    
    private func observerChangeInErrorText(){
        viewModel.errorMsgTextSetted = { (error) in
            DispatchQueue.main.async {
                self.setError(with: error)
            }
        }
    }
}

class ESTextBoxViewModel {
    
    var textFieldTextSetted : ((String) -> Void)?
    var textFieldText: String = ""{
        didSet{
            self.textFieldTextSetted?(textFieldText)
        }
    }
    
    var errorMsgTextSetted : ((String) -> Void)?
    var errorMsgText: String = ""{
        didSet{
            self.errorMsgTextSetted?(errorMsgText)
        }
    }
    
    func setFieldText(txt: String){
        self.textFieldText = txt
        if self.textFieldText == "" {
            // errorMsgText = "Field is required"
        } else {
            //normalaizeField?()
        }
    }
    
    func setErrorText(txt: String){
        self.errorMsgText = txt
    }
    
    var fieldValidation : PPTextField.Validation = .general
    
    func checkChange() {
        
    }
    
    func validate() -> Bool{
        guard fieldValidation != .none else {
            return true
        }
        guard textFieldText != "" else {
            errorMsgText = "Field is required"
            
            return false
        }
        
        switch fieldValidation {
        case .none:
            
            return true
        case .general:
            if textFieldText.isEmpty {
                errorMsgText = "Field is required"
                return false
            }
            if (textFieldText.trimmingCharacters(in: .whitespaces).isEmpty) {
                errorMsgText = "Field is required"
                return false
            }
            return true
            
        case .name:
            if (textFieldText.count < 3)  {
                errorMsgText = "Name must have 3 characters"
                return false
            }
            
        case .email:
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailTest.evaluate(with: self.textFieldText) {
                errorMsgText = "Enter correct email address"
                return false
            }
            
        case .password:
            if textFieldText.count < 8 {
                errorMsgText = "Must contain 8 or more characters"
                return false
                
            } else if !self.contains(case: .uppercase, in: textFieldText){
                errorMsgText = "Must contain uppercase letter"
                return false
                
            } else if !self.contains(case: .lowercase, in: textFieldText){
                errorMsgText = "Must contain lowercase letter"
                return false
                
            } else if !self.contains(case: .number, in: textFieldText){
                errorMsgText = "Must contain number"
                return false
                
            } else if !self.contains(case: .special, in: textFieldText){
                errorMsgText = "Must contain special character"
                return false
            }
        case .normal_password:
            return true
        case .phone:
            if self.textFieldText.count < Constants.minDigitsReqInPhoneNumber ||
                self .textFieldText.count > Constants.maxDigitsReqInPhoneNumber{
                errorMsgText = "Number must be between 10-15 digits"
                return false
            }
            
            return true
            
        }
        // self.normalaizeField?()
        return true
    }
    
    func validateForAnother(text:String) -> Bool {
        return self.textFieldText == text
    }
    
    private enum PasswordCase: String {
        case uppercase = ".*[A-Z]+.*"
        case lowercase = ".*[a-z]+.*"
        case number = ".*[0-9]+.*"
        case special = "^(?=.*[-_!?/<>;:{}()*@#$%^&+=])(?=\\S+$).{4,}$"
    }
    private func contains(case pCase:PasswordCase, in searchTerm: String) -> Bool {
        
        do {
            let regex = try NSRegularExpression(pattern: pCase.rawValue)
            if let _ = regex.firstMatch(in: searchTerm, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, searchTerm.count)) {
                return true
            } else {
                return false
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
    }
}

extension PPTextField : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.viewModel.fieldValidation == .name {
            if range.location == 0, string != "", string.first! == " " {
                return false
            }
            if string != "" , ((textField.text!.count + (string.count - range.length)) >= 2), textField.text!.last! == " ", string.last! == " " {
                return false
            }
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        }
        if self.viewModel.fieldValidation == .general{
            if range.location == 0, string != "", string.first! == " " {
                return false
            }
        }
        return true
    }
}
*/
///MARK : TextField Extension
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 10 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}
extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}
