//
//  AddCardView.swift
//  MoCuts
//
//  Created by Farooq Haroon on 16/08/2024.
//

import UIKit
import MaterialComponents
import PayPal

class AddCardView: BaseView {
    
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var txtFieldCardNo: MDCFilledTextField!
    @IBOutlet weak var txtFieldExpires: MDCFilledTextField!
    @IBOutlet weak var txtFieldCSC: MDCFilledTextField!
    @IBOutlet weak var txtFieldFirstName: MDCFilledTextField!
    @IBOutlet weak var txtFieldLastName: MDCFilledTextField!
    @IBOutlet weak var txtFieldStreet: MDCFilledTextField!
    @IBOutlet weak var txtFieldApt: MDCFilledTextField!
    @IBOutlet weak var txtFieldCity: MDCFilledTextField!
    @IBOutlet weak var txtFieldState: MDCFilledTextField!
    @IBOutlet weak var txtFieldZipCode: MDCFilledTextField!
    @IBOutlet weak var txtFieldMobile: MDCFilledTextField!
    @IBOutlet weak var txtFieldEmail: MDCFilledTextField!
    @IBOutlet weak var switchShip: UISwitch!
    
    var amount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
    }
    
    @IBAction func actCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func actPayNow(_ sender: UIButton) {
        if validateFields() {
//            let card = Card(
//                 number: "4005519200000004",
//                 expirationMonth: "01",
//                 expirationYear: "2025",
//                 securityCode: "123",
//                 cardholderName: "Jane Smith",
//                 billingAddress: Address(addressLine1: <#T##String?#>, addressLine2: <#T##String?#>, locality: <#T##String?#>, region: <#T##String?#>, postalCode: <#T##String?#>, countryCode: <#T##String#>)
//                )
        }
    }
}
//MARK: - VALIDIATION AND CONFIGURATION
extension AddCardView {
    
    func configureTextFields() {
        // Card number
        txtFieldCardNo.label.text = "Card number"
        txtFieldCardNo.placeholder = "1234 5678 9123 4567"
        txtFieldCardNo.leadingAssistiveLabel.text = "Enter your card number"
        
        // Expiry date
        txtFieldExpires.label.text = "Expires"
        txtFieldExpires.placeholder = "MM/YY"
        
        // CSC
        txtFieldCSC.label.text = "CSC"
        txtFieldCSC.placeholder = "123"
        
        // First name
        txtFieldFirstName.label.text = "First name"
        txtFieldFirstName.placeholder = "John"
        
        // Last name
        txtFieldLastName.label.text = "Last name"
        txtFieldLastName.placeholder = "Doe"
        
        // Street address
        txtFieldStreet.label.text = "Street address"
        txtFieldStreet.placeholder = "123 Main St"
        
        // Apt, Ste, Bldg
        txtFieldApt.label.text = "Apt., ste., bldg."
        txtFieldApt.placeholder = "Apt. 4B"
        
        // City
        txtFieldCity.label.text = "City"
        txtFieldCity.placeholder = "New York"
        
        // State
        txtFieldState.label.text = "State"
        txtFieldState.placeholder = "NY"
        
        // ZIP code
        txtFieldZipCode.label.text = "ZIP code"
        txtFieldZipCode.placeholder = "10001"
        
        // Mobile
        txtFieldMobile.label.text = "Mobile"
        txtFieldMobile.placeholder = "+1 555-555-5555"
        
        // Email
        txtFieldEmail.label.text = "Email"
        txtFieldEmail.placeholder = "example@example.com"
        txtFieldEmail.leadingAssistiveLabel.text = "Enter your email address"
        
        switchShip.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        let fields: [MDCFilledTextField] = [
            txtFieldCardNo, txtFieldExpires, txtFieldCSC, txtFieldFirstName,
            txtFieldLastName, txtFieldStreet, txtFieldApt, txtFieldCity,
            txtFieldState, txtFieldZipCode, txtFieldMobile, txtFieldEmail
        ]
        fields.forEach { field in
            configureTextFieldAppearance(field)
        }
    }
    func clearErrorMessages() {
           [txtFieldCardNo, txtFieldExpires, txtFieldCSC, txtFieldFirstName, txtFieldLastName, txtFieldStreet, txtFieldZipCode, txtFieldMobile, txtFieldEmail].forEach { textField in
               textField?.leadingAssistiveLabel.text = nil
               txtFieldCSC.leadingAssistiveLabel.textColor = .black
               textField?.setUnderlineColor(UIColor.lightGray, for: .normal)
               textField?.setUnderlineColor(Theme.appNavigationBlueColor, for: .editing)
               
           }
       }

    func configureTextFieldAppearance(_ textField: MDCFilledTextField) {
        
        textField.setNormalLabelColor(UIColor.black, for: .normal)
        textField.setFloatingLabelColor(UIColor.black, for: .normal)
        textField.setFilledBackgroundColor(UIColor.white, for: .normal)
        textField.setFilledBackgroundColor(UIColor.white, for: .editing)
        textField.setUnderlineColor(UIColor.lightGray, for: .normal)
        textField.setUnderlineColor(Theme.appNavigationBlueColor, for: .editing)
        textField.setNormalLabelColor(UIColor.darkGray, for: .editing)
        textField.layer.cornerRadius = 8.0
        textField.setUnderlineColor(UIColor.lightGray, for: .normal)
        textField.setUnderlineColor(Theme.appNavigationBlueColor, for: .editing)
    }
    
    func validateFields() -> Bool {
        var isValid = true
        clearErrorMessages()
        // Card number validation
        if txtFieldCardNo.text?.isEmpty ?? true {
            txtFieldCardNo.leadingAssistiveLabel.text = "Card number is required"
            txtFieldCardNo.leadingAssistiveLabel.textColor = .red
            txtFieldCardNo.setUnderlineColor(UIColor.red, for: .normal)
            txtFieldCardNo.setUnderlineColor(UIColor.red, for: .editing)
            isValid = false
        }
        
        // Expiry date validation
        if txtFieldExpires.text?.isEmpty ?? true {
            txtFieldExpires.leadingAssistiveLabel.text = "Expiry date is required"
            txtFieldExpires.leadingAssistiveLabel.textColor = .red
            txtFieldExpires.setUnderlineColor(UIColor.red, for: .normal)
            txtFieldExpires.setUnderlineColor(UIColor.red, for: .editing)
            isValid = false
        }
        
        // CSC validation
        if txtFieldCSC.text?.isEmpty ?? true {
            txtFieldCSC.leadingAssistiveLabel.text = "CSC is required"
            txtFieldCSC.leadingAssistiveLabel.textColor = .red
            txtFieldCSC.setUnderlineColor(UIColor.red, for: .normal)
            txtFieldCSC.setUnderlineColor(UIColor.red, for: .editing)
            isValid = false
        }
        
        // First name validation
        if txtFieldFirstName.text?.isEmpty ?? true {
            txtFieldFirstName.leadingAssistiveLabel.text = "First name is required"
            txtFieldFirstName.leadingAssistiveLabel.textColor = .red
            txtFieldFirstName.setUnderlineColor(UIColor.red, for: .normal)
            txtFieldFirstName.setUnderlineColor(UIColor.red, for: .editing)
            isValid = false
        }
        
        // Last name validation
        if txtFieldLastName.text?.isEmpty ?? true {
            txtFieldLastName.leadingAssistiveLabel.text = "Last name is required"
            txtFieldLastName.leadingAssistiveLabel.textColor = .red
            txtFieldLastName.setUnderlineColor(UIColor.red, for: .normal)
            txtFieldLastName.setUnderlineColor(UIColor.red, for: .editing)
            isValid = false
        }
        
        // Street validation
        if txtFieldStreet.text?.isEmpty ?? true {
            txtFieldStreet.leadingAssistiveLabel.text = "Street address is required"
            txtFieldStreet.leadingAssistiveLabel.textColor = .red
            txtFieldStreet.setUnderlineColor(UIColor.red, for: .normal)
            txtFieldStreet.setUnderlineColor(UIColor.red, for: .editing)
            isValid = false
        }
        
        // ZIP code validation
        if txtFieldZipCode.text?.isEmpty ?? true {
            txtFieldZipCode.leadingAssistiveLabel.text = "ZIP code is required"
            txtFieldZipCode.leadingAssistiveLabel.textColor = .red
            txtFieldZipCode.setUnderlineColor(UIColor.red, for: .normal)
            txtFieldZipCode.setUnderlineColor(UIColor.red, for: .editing)
            isValid = false
        }
        
        // Mobile validation
        if txtFieldMobile.text?.isEmpty ?? true {
            txtFieldMobile.leadingAssistiveLabel.text = "Mobile number is required"
            txtFieldMobile.leadingAssistiveLabel.textColor = .red
            txtFieldMobile.setUnderlineColor(UIColor.red, for: .normal)
            txtFieldMobile.setUnderlineColor(UIColor.red, for: .editing)
            isValid = false
        }
        
        // Email validation
        if let email = txtFieldEmail.text, !isValidEmail(email) {
            txtFieldEmail.leadingAssistiveLabel.text = "Please enter a valid email address"
            txtFieldEmail.leadingAssistiveLabel.textColor = .red
            txtFieldEmail.setUnderlineColor(UIColor.red, for: .normal)
            txtFieldEmail.setUnderlineColor(UIColor.red, for: .editing)
            isValid = false
        }
        
        return isValid
    }
    
    // Helper function to validate email format
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
