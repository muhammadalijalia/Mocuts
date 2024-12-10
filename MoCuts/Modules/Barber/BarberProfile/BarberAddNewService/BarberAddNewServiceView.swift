//
//  BarberAddNewServiceView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 16/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class BarberAddNewServiceView: BaseView, Routeable {
    
    @IBOutlet weak var serviceTitleField : UITextField!
    @IBOutlet weak var serviceFeeField : UITextField!
    @IBOutlet weak var serviceTimeField : UITextField!
    @IBOutlet weak var addNewServiceBtn : MoCutsAppButton!
    
    var serviceFee: String = ""
    var serviceDuration: String = ""
    
    var setNewServiceRoute : ((GenericResponse<Services>) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BarberAddNewServiceViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setView()
        self.setButton()
        setNewServiceAddedRoute()
        errorTextMessage()
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: nil, title: "Add New Services", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
        
        self.serviceTitleField.isUserInteractionEnabled = true
        self.serviceTitleField.delegate = self
        self.serviceTitleField.textColor = UIColor(hex: "#212021")
        self.serviceTitleField.autocapitalizationType = .words
//        self.serviceTitleField.keyboardType = .namePhonePad
        self.serviceTitleField.layer.borderColor = UIColor.lightGray.cgColor
        self.serviceTitleField.layer.borderWidth = 1.0
        self.serviceTitleField.layer.cornerRadius = 4
        self.serviceTitleField.setLeftPaddingPoints(5)
        self.serviceTitleField.setRightPaddingPoints(5)
        
        self.serviceFeeField.isUserInteractionEnabled = true
        self.serviceFeeField.delegate = self
        self.serviceFeeField.textColor = UIColor(hex: "#212021")
        self.serviceFeeField.autocapitalizationType = .none
        self.serviceFeeField.keyboardType = .phonePad
        self.serviceFeeField.layer.borderColor = UIColor.lightGray.cgColor
        self.serviceFeeField.layer.borderWidth = 1.0
        self.serviceFeeField.layer.cornerRadius = 4
        self.serviceFeeField.setLeftPaddingPoints(5)
        self.serviceFeeField.setRightPaddingPoints(5)
        
        self.serviceTimeField.isUserInteractionEnabled = false
        self.serviceTimeField.textColor = UIColor(hex: "#212021")
        self.serviceTimeField.autocapitalizationType = .words
        self.serviceTimeField.layer.borderColor = UIColor.lightGray.cgColor
        self.serviceTimeField.layer.borderWidth = 1.0
        self.serviceTimeField.layer.cornerRadius = 4
        self.serviceTimeField.setLeftPaddingPoints(5)
        self.serviceTimeField.setRightPaddingPoints(5)
        
        serviceFeeField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textfield: UITextField) {
        if textfield.text == "$"
        {
            textfield.text = ""
            textfield.placeholder = "Please enter service fee"
        }
        else
        {
            var text = textfield.text
            text = text?.replacingOccurrences(of: "$", with: "")
            self.serviceFee = text ?? ""
            text = "$" + (text ?? "")
            textfield.text = text
        }
    }
    
    func setButton() {
        self.addNewServiceBtn.buttonColor = .blue
        self.addNewServiceBtn.setText(text: "Add Service")
        self.addNewServiceBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            self.serviceTitleField.resignFirstResponder()
            self.serviceFeeField.resignFirstResponder()
            self.serviceTimeField.resignFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                (self.viewModel as! BarberAddNewServiceViewModel).addNewService(serviceTitle: self.serviceTitleField, serviceFee: self.serviceFeeField, serviceTime: self.serviceTimeField, servicePrice: self.serviceFee, serviceDuration: self.serviceDuration)
            }
        })
    }
    
    func errorTextMessage() {
        (self.viewModel as! BarberAddNewServiceViewModel).validateField = { [weak self] errorText in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                ToastView.getInstance().showToast(inView: self.view, textToShow: errorText,backgroundColor: Theme.appOrangeColor)
            }
        }
    }
    
    func setNewServiceAddedRoute() {
        (self.viewModel as! BarberAddNewServiceViewModel).setNewServiceRoute = { [weak self] service in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.setNewServiceRoute?(service)
                self.routeBack(navigation: .pop)
            }
        }
        
    }
    
    @IBAction func serviceTimeBtnAction(_ sender : UIButton) {
        let attributedString = NSAttributedString(string: "\nSelect Time Duration", attributes: [
            NSAttributedString.Key.font : Theme.getAppMediumFont(withSize: 18),
            NSAttributedString.Key.foregroundColor : UIColor.black
        ])
        
        let alert = UIAlertController(title: "Select Time Duration", message: nil, preferredStyle: .actionSheet)
        let subview = alert.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertContentView.layer.cornerRadius = 15
        alert.view.tintColor = Theme.appOrangeColor
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "15 Mins", style: .default, handler: { _ in
            self.serviceTimeField.text = "15 Mins"
            self.serviceDuration = "15"
        }))
        
        alert.addAction(UIAlertAction(title: "30 Mins", style: .default, handler: { _ in
            self.serviceTimeField.text = "30 Mins"
            self.serviceDuration = "30"
        }))
        alert.addAction(UIAlertAction(title: "1 Hour", style: .default, handler: { _ in
            self.serviceTimeField.text = "1 Hour"
            self.serviceDuration = "60"
        }))
        alert.addAction(UIAlertAction(title: "1.5 Hours", style: .default, handler: { _ in
            self.serviceTimeField.text = "1.5 Hours"
            self.serviceDuration = "90"
        }))
        alert.addAction(UIAlertAction(title: "2 Hours", style: .default, handler: { _ in
            self.serviceTimeField.text = "2 Hours"
            self.serviceDuration = "120"
        }))
        alert.addAction(UIAlertAction(title: "2.5 Hours", style: .default, handler: { _ in
            self.serviceTimeField.text = "2.5 Hours"
            self.serviceDuration = "150"
        }))
        alert.addAction(UIAlertAction(title: "3 Hours", style: .default, handler: { _ in
            self.serviceTimeField.text = "3 Hours"
            self.serviceDuration = "180"
        }))
        alert.addAction(UIAlertAction(title: "3.5 Hours", style: .default, handler: { _ in
            self.serviceTimeField.text = "3.5 Hours"
            self.serviceDuration = "210"
        }))
        alert.addAction(UIAlertAction(title: "4 Hours", style: .default, handler: { _ in
            self.serviceTimeField.text = "4 Hours"
            self.serviceDuration = "240"
        }))
        alert.addAction(UIAlertAction(title: "4.5 Hours", style: .default, handler: { _ in
            self.serviceTimeField.text = "4.5 Hours"
            self.serviceDuration = "270"
        }))
        alert.addAction(UIAlertAction(title: "5 Hours", style: .default, handler: { _ in
            self.serviceTimeField.text = "5 Hours"
            self.serviceDuration = "300"
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension BarberAddNewServiceView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == serviceTitleField {
            textField.resignFirstResponder()
            serviceFeeField.becomeFirstResponder()
        } else if textField == serviceFeeField {
            textField.resignFirstResponder()
            serviceTimeField.becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.canBeConverted(to: String.Encoding.ascii){
            return false
        }
        
        if textField == serviceFeeField {
            //            let allowedCharacters = CharacterSet.decimalDigits
            //            let characterSet = CharacterSet(charactersIn: string)
            //            return allowedCharacters.isSuperset(of: characterSet)
            let aSet = CharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        return true
    }
}
