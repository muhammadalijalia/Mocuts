//
// HIMCustomTextFieldView.swift
// InventoryMeApp
//
// Copyright © 2019 Appiskey. All rights reserved.
//

import Foundation
import UIKit
import Helpers
import CommonComponents
@objc protocol AppFieldViewDelegate{
    @objc optional func appFieldView(_ field: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func appFieldViewShouldEndEditing(_ field: UITextField) -> Bool
}

class AppFieldView: CustomNibView {
    
    enum TypeOfView{
        case dropDown
        case textField
        case password
        case numberField
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
    
    var view: UIView!
    var delegate: AppFieldViewDelegate?
    
    @IBOutlet weak var animatablePlaceholderLbl: AppLabel!
    @IBOutlet weak var rightIconBtn: UIButton!
    @IBOutlet weak var rightIconImageCustom: UIImageView!
    @IBOutlet weak var bottomConstraintOfErrorLbl: NSLayoutConstraint!
    @IBOutlet weak var errorLbl: AppLabel!
    @IBOutlet weak var textField: AppTextField!
    @IBOutlet weak var buttonOnTextField: UIButton!
    @IBOutlet weak var titleLbl: AppLabel!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    var limitOfCharacters : Int = 100
    private var textViewType : TypeOfView = .textField
    private var originalTransformOfAnimatedLbl: CGAffineTransform!
    
    private let viewTotalHeightWithErrorMsgWithTitle : CGFloat = 99
    private let viewTotalHeightWithoutTitle : CGFloat = 83
    private let viewTotalHeightWithoutTitleAndErrorMsg : CGFloat = 61
    private let viewTotalHeight : CGFloat = 77
    private var dropDownAction : (() -> Void)? = nil
    private var rightBtnAction : ((UIButton) -> Void)? = nil
    var isRequired: Bool = false
    
    private var placerHolderColor: UIColor = .lightGray
    
    private let kRequiredError = "* This field is required."
    var textBoxViewModel : TextBoxViewModel!
    
    internal override func setupView() {
        
        super.setupView()
        self.textBoxViewModel = TextBoxViewModel(delegate: self)
        self.textField.autocorrectionType = .no
        self.textField.autocapitalizationType = .sentences
        self.textField.delegate = self
        self.textField.setupFont()
        self.errorLbl.isHidden = true
        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        if UIDevice.current.model == "iPad" {
            self.textField.font = Theme.getAppFont(withSize: 25)
        } else {
            self.textField.font = Theme.getAppFont(withSize: 15)
        }
        self.bgView.layer.borderWidth = 1
        self.bgView.layer.borderColor = UIColor.lightGray.cgColor
        self.bgView.layer.cornerRadius = 4
        self.rightIconImageCustom.tintColor = UIColor(hex: "#9A9A9A")
    }
    
    func setCustomFieldView(titleTxt: String?=nil,
                            typeOfView: TypeOfView,
                            placeholder: String,
                            rightImage: UIImage?=nil,
                            imageTintColor : UIColor?=nil,
                            isRequiredField: Bool=false,
                            dropDownAction: (() -> Void)?=nil,
                            rightBtnAction: ((UIButton)->Void)?=nil, validation: Validation = .general){
        
        self.setTextFieldPlaceHolder(string: placeholder)
        self.titleLbl.alpha = 0.0
        self.isRequired = isRequiredField
        self.textViewType = typeOfView
        textBoxViewModel.fieldValidation = validation
        
        
        if self.textViewType == .numberField{
            self.buttonOnTextField.isUserInteractionEnabled = false
            self.textField.keyboardType = .numberPad
        }else if self.textViewType == .textField || self.textViewType == .password{
            self.buttonOnTextField.isUserInteractionEnabled = false
            self.textField.keyboardType = .default
            if self.textViewType == .password{
                self.textField.isSecureTextEntry = true
            }
        }else{
            self.buttonOnTextField.isUserInteractionEnabled = true
            self.textField.isUserInteractionEnabled = false
        }
        if titleTxt != nil{
            self.setTitleLbl(string: titleTxt!)
        }else{
            self.titleHeight.constant = 0
        }
        
        if rightImage != nil{
            self.rightIconBtn.isUserInteractionEnabled = true
            self.rightIconBtn.isHidden = false
            self.rightIconImageCustom.isHidden = false
            self.rightIconImageCustom.image = rightImage
            self.rightIconImageCustom.contentMode = .scaleAspectFit
            
        }else{
            self.rightIconBtn.isUserInteractionEnabled = false
            self.rightIconBtn.isHidden = true
            self.rightIconImageCustom.isHidden = true
        }
        if dropDownAction != nil{
            self.dropDownAction = dropDownAction!
        }
        if rightBtnAction != nil{
            self.rightBtnAction = rightBtnAction!
        }
        
        // self.backgroundColor = UIColor.init(hex: "F6F7F7")
        self.backgroundColor = .clear
        self.bgView.backgroundColor = .clear
        
    }
    
    private func showOrHideErrorLbl(isShow: Bool){
        if isShow {
            Animations.shared().fadeIn(view: self.errorLbl) { (status) in
//                print("Fade in animation")
            }
        } else {
            Animations.shared().fadeOut(view: self.errorLbl) { (status) in
//                print("Fade out animation")
            }
        }
    }
    
    private func setErrorLblConstraint(isShow: Bool){
        if isShow{
            self.bottomConstraintOfErrorLbl.constant = 8
        }else{
            self.bottomConstraintOfErrorLbl.constant = 0
        }
    }
    
    func setErrorLbl(text: String){
        self.errorLbl.text = text
        if text != "" {
            self.showOrHideErrorLbl(isShow: true)
        }else{
            self.showOrHideErrorLbl(isShow: false)
        }
    }
    
    func setRightImage(image: String){
        //        self.rightIconBtn.setImage(UIImage.init(named: image), for: UIControl.State.normal)
        
        self.rightIconImageCustom.image = UIImage(named: image)
    }
    
    func setTextFieldPlaceHolder(string: String){
        self.textField.attributedPlaceholder = NSAttributedString(string: "",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: placerHolderColor ])
        //,NSAttributedString.Key.font: Theme.getAppFont(withSize: 16)])
        // self.textField.placeholder = string
        self.animatablePlaceholderLbl.textColor = placerHolderColor
        self.animatablePlaceholderLbl.text = string
        
        if UIDevice.current.model == "iPad"{
            self.animatablePlaceholderLbl.font = Theme.getAppFont(withSize: 25)
            
        }else{
            self.animatablePlaceholderLbl.font = Theme.getAppFont(withSize: 15)
        }
        
        
        self.animatablePlaceholderLbl.sizeToFit()
    }
    
    func setTextFieldText(string: String){
        self.textField.text = string
    }
    
    func setTitleLbl(string : String){
        
        self.titleHeight.constant = 16
        self.titleLbl.text = string
    }
    
    func setDropDownAction(actionP: @escaping (() -> Void)){
        self.dropDownAction = actionP
    }
    
    func setRightBtnAction(button: UIButton){
        if self.textViewType == .password{
            self.rightIconBtn.isSelected = !self.rightIconBtn.isSelected
            if rightIconBtn.isSelected {
                self.textField.isSecureTextEntry = true
                self.rightIconImageCustom.image = UIImage(named: "openEye")?.withRenderingMode(.alwaysTemplate)
            }else{
                self.textField.isSecureTextEntry = false
                self.rightIconImageCustom.image = UIImage(named: "closedEye")?.withRenderingMode(.alwaysTemplate)
            }
        }
        self.rightBtnAction?(button)
    }
    
    func animatePlaceHolderLabel(){
        self.originalTransformOfAnimatedLbl = self.animatablePlaceholderLbl.transform
        self.translateView(viewToAnimate: self.animatablePlaceholderLbl,
                           translationX: 0.0,
                           translationY: -40,
                           completion: nil)
    }
    
    func translateView(viewToAnimate: UIView,
                       translationX: CGFloat,
                       translationY: CGFloat,
                       completion: (() -> Void)?){
        
        let originalTransform = viewToAnimate.transform
        let scaledTransform =
            
            originalTransform.translatedBy(x: translationX, y: translationY)
        self.animatablePlaceholderLbl.font = self.titleLbl.font
        UIView.animate(withDuration: 0.3, animations: {
            viewToAnimate.transform = scaledTransform
            self.titleLbl.alpha = 1.0
            self.animatablePlaceholderLbl.isHidden = true
        }) { (isSuccess) in
            if completion != nil{
                completion!()
            }
        }
    }
    
    func animatedPlaceholderToOriginalPlace(){
        //        if UIDevice.current.model == "iPad" {
        //            self.animatablePlaceholderLbl.font = Theme.getAppFont(withSize: 26)
        //        }else{
        self.animatablePlaceholderLbl.font = Theme.getAppFont(withSize: 16)
        //        }
        
        UIView.animate(withDuration: 0.2) {
            self.animatablePlaceholderLbl.isHidden = false
            self.animatablePlaceholderLbl.transform = self.originalTransformOfAnimatedLbl
        }
    }
    
    @IBAction func rightIconBtn(_ sender: UIButton) {
        if rightBtnAction != nil{
            self.setRightBtnAction(button: sender)
        }
    }
    
    @IBAction func textFieldTapped(_ sender: UIButton) {
        if dropDownAction != nil{
            self.dropDownAction!()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.textBoxViewModel.setFieldText(txt: textField.text ?? "")
        if textField.text == "" {
            self.errorLbl.isHidden = false
        } else {
            self.errorLbl.isHidden = true
        }
    }
}

extension AppFieldView : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            
            self.titleLbl.textColor = Theme.appTextFieldPlaceHolderColor
            if textField.text == ""{
                self.animatePlaceHolderLabel()
            }
            self.setErrorLbl(text: "")
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            
            self.titleLbl.textColor = Theme.appTextFieldPlaceHolderColor
            if textField.text == "" {
                self.titleLbl.alpha = 0.0
                self.animatedPlaceholderToOriginalPlace()
                if self.isRequired {
                    self.setErrorLbl(text: self.kRequiredError)
                }
            }
        }
        if delegate != nil{
            return delegate!.appFieldViewShouldEndEditing!(textField)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (textField.text!.count + (string.count - range.length) > self.limitOfCharacters) && isBackSpace != -92 {
            return false
        }
        if textViewType == .password {
            if (string == " ") {
                return false
            }
        }
        if delegate != nil{
            return delegate!.appFieldView!(textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        return true
    }
}

//extension JoinMeetingView: UITextFieldDelegate {
//
//    // Use this if you have a UITextField
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // get the current text, or use an empty string if that failed
//        let currentText = textField.text ?? ""
//
//        // attempt to read the range they are trying to change, or exit if we can't
//        guard let stringRange = Range(range, in: currentText) else { return false }
//
//        // add their new text to the existing text
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//
//        // make sure the result is under 16 characters
//        return updatedText.count <= 10
//    }
//}

extension AppFieldView: FieldViewVMBinding{
    func textFieldTextChanged(text: String) {
        
        if (textBoxViewModel.fieldValidation == .phone) || self.textViewType == .dropDown{
            if textField.text == ""{
                self.animatePlaceHolderLabel()
            }
        }
        self.setErrorLbl(text: "")
        self.textField.text = text
    }
    
    func errorMessageChanged(text: String) {
        DispatchQueue.main.async {
            ToastView.getInstance().showToast(inView: self, textToShow: text,backgroundColor: Theme.appOrangeColor)
        }
        
        self.setErrorLbl(text: text)
    }
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////


protocol FieldViewVMBinding: class{
    func textFieldTextChanged(text: String)
    func errorMessageChanged(text: String)
}

class TextBoxViewModel {
    
    var normalaizeField : (() -> Void)?
    
    var delegate : FieldViewVMBinding!
    var textFieldText: String = ""{
        didSet{
            delegate.textFieldTextChanged(text: textFieldText)
        }
    }
    var errorMsgText: String = ""{
        didSet{
            delegate.errorMessageChanged(text: errorMsgText)
        }
    }
    
    init(delegate: FieldViewVMBinding) {
        self.delegate = delegate
    }
    
    func setFieldText(txt: String){
        self.textFieldText = txt
    }
    
    func setErrorText(txt: String){
        self.errorMsgText = txt
    }
    
    var fieldValidation : AppFieldView.Validation = .general
    
    func validate() -> Bool {
        guard fieldValidation != .none else {
            return true
        }
        guard textFieldText != "" else {
            errorMsgText = "Fields are required"
            return false
        }
        
        switch fieldValidation {
        case .none:
            return true
        case .general:
            if textFieldText.isEmpty {
                errorMsgText = "Fields are required"
                return false
            }
            if (textFieldText.trimmingCharacters(in: .whitespaces).isEmpty) {
                errorMsgText = "Fields are required"
                return false
            }
            return true
            
        case .name:
//            if (textFieldText.count < 3) {
//                errorMsgText = "Name must atleast have 3 characters"
//                return false
//            }
            if (textFieldText.count > 25) {
                errorMsgText = "Name must not be greater than 25 characters"
                return false
            }
            if (textFieldText.lastCharacterAsString == " ") {
                errorMsgText = "Remove space in last from name"
                return false
            }
            
        case .email:
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailTest.evaluate(with: self.textFieldText) {
                errorMsgText = "Enter valid email address"
                return false
            }
            
        case .password:
            
            if textFieldText.count < 8 {
                errorMsgText = "Password must contain 8 or more characters"
                return false
                
            }else if textFieldText.count > 32 {
                errorMsgText = "Password must contain less than 32 characters"
                return false
            }
            else if !self.contains(case: .uppercase, in: textFieldText){
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
            if textFieldText.count < 8 {
                errorMsgText = "Password should contain 8 or more characters"
                return false
                
            }else if textFieldText.count > 100 {
                errorMsgText = "Password should contain less than 100 characters"
                return false
            }
        case .phone:
            if self.textFieldText.count < Constants.minDigitsReqInPhoneNumber ||
                self .textFieldText.count > Constants.maxDigitsReqInPhoneNumber{
                errorMsgText = "Number must be between 10-15 digits"
                return false
            }
            return true
        }
        self.normalaizeField?()
        return true
    }
    
    func validateSamePassword(passwordField : String, confirmPasswordField : String) -> Bool {
        if passwordField != confirmPasswordField {
            return false
        }
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
