//
//  SignUpView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import PlacesPicker
import GooglePlaces
import GoogleMaps

//@available(iOS 13.0, *)
class SignUpView: BaseView, Routeable {
    
    @IBOutlet weak var fullNameField : UITextField!
    @IBOutlet weak var contactNumberField : UITextField!
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var locationField : UITextField!
    @IBOutlet weak var passwordField : UITextField!
    @IBOutlet weak var confirmPasswordField : UITextField!
    @IBOutlet weak var confirmPasswordEye : UIImageView!
    @IBOutlet weak var passwordEye : UIImageView!
    @IBOutlet weak var signUpBtn : MoCutsAppButton!
    
//    let locationManager = CLLocationManager()
    
    private var number: String = ""
    private var isoModel: IsoCountryInfo? = nil
    var userMode : UserMode = .customer
    var passwordEyeBool : Bool = false
    var confirmPasswordEyeBool : Bool = false
    
    private var latitude: String = ""
    private var longitude: String = ""
    private var placeName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager.delegate = self
        viewModel = SignUpViewModel()
        routeToHomeView()
        errorTextMessage()
        passwordNotMatched()
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
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
 
        if userMode == .customer {
            (viewModel as! SignUpViewModel).role = 2
        } else if userMode == .barber {
            (viewModel as! SignUpViewModel).role = 3
        }
        self.fullNameField.isUserInteractionEnabled = true
        self.contactNumberField.isUserInteractionEnabled = true
        self.emailField.isUserInteractionEnabled = true
        self.locationField.isUserInteractionEnabled = true
        self.passwordField.isUserInteractionEnabled = true
        self.confirmPasswordField.isUserInteractionEnabled = true
        
        self.fullNameField.textColor = UIColor(hex: "#212021")
        self.contactNumberField.textColor = UIColor(hex: "#212021")
        self.emailField.textColor = UIColor(hex: "#212021")
        self.locationField.textColor = UIColor(hex: "#212021")
        self.passwordField.textColor = UIColor(hex: "#212021")
        self.confirmPasswordField.textColor = UIColor(hex: "#212021")
        
        self.passwordEye.tintColor = UIColor(hex: "#9A9A9A")
        self.confirmPasswordEye.tintColor = UIColor(hex: "#9A9A9A")
        
        self.fullNameField.autocapitalizationType = .words
//        self.fullNameField.keyboardType = .namePhonePad
        self.fullNameField.layer.borderColor = UIColor.lightGray.cgColor
        self.fullNameField.layer.borderWidth = 1.0
        self.fullNameField.layer.cornerRadius = 4
        self.fullNameField.delegate = self
        self.fullNameField.setLeftPaddingPoints(5)
        self.fullNameField.setRightPaddingPoints(5)
        
        self.contactNumberField.autocapitalizationType = .none
        self.contactNumberField.keyboardType = .numberPad
        self.contactNumberField.layer.borderColor = UIColor.lightGray.cgColor
        self.contactNumberField.layer.borderWidth = 1.0
        self.contactNumberField.layer.cornerRadius = 4
        self.contactNumberField.delegate = self
        self.contactNumberField.setLeftPaddingPoints(5)
        self.contactNumberField.setRightPaddingPoints(5)
        
        self.emailField.autocapitalizationType = .none
        self.emailField.keyboardType = .emailAddress
        self.emailField.layer.borderColor = UIColor.lightGray.cgColor
        self.emailField.layer.borderWidth = 1.0
        self.emailField.layer.cornerRadius = 4
        self.emailField.delegate = self
        self.emailField.setLeftPaddingPoints(5)
        self.emailField.setRightPaddingPoints(5)
        
        self.locationField.autocapitalizationType = .words
        self.locationField.keyboardType = .default
        self.locationField.layer.borderColor = UIColor.lightGray.cgColor
        self.locationField.layer.borderWidth = 1.0
        self.locationField.layer.cornerRadius = 4
        self.locationField.delegate = self
        self.locationField.addTarget(self, action: #selector(openLocationPicker), for: .touchDown)
        self.locationField.setLeftPaddingPoints(5)
        self.locationField.setRightPaddingPoints(5)
        
        self.passwordField.autocapitalizationType = .words
        self.passwordField.keyboardType = .default
        self.passwordField.layer.borderColor = UIColor.lightGray.cgColor
        self.passwordField.layer.borderWidth = 1.0
        self.passwordField.layer.cornerRadius = 4
        self.passwordField.delegate = self
        self.passwordField.setLeftPaddingPoints(5)
        self.passwordField.setRightPaddingPoints(30)
        
        self.confirmPasswordField.autocapitalizationType = .words
        self.confirmPasswordField.keyboardType = .default
        self.confirmPasswordField.layer.borderColor = UIColor.lightGray.cgColor
        self.confirmPasswordField.layer.borderWidth = 1.0
        self.confirmPasswordField.layer.cornerRadius = 4
        self.confirmPasswordField.delegate = self
        self.confirmPasswordField.setLeftPaddingPoints(5)
        self.confirmPasswordField.setRightPaddingPoints(30)
        
        contactNumberField.addTarget(self, action: #selector(contactPressed), for: .allEvents)
    }
    
    func updateLocationName(coordinates: CLLocationCoordinate2D) {
        let gmsGeocoder = GMSGeocoder()
        viewModel.isLoading = true
        gmsGeocoder.reverseGeocodeCoordinate(coordinates, completionHandler: {
            response, error in
            if error == nil {
                if let places = response?.results() {
                    if let place = places.first, place.lines?.count > 0 {
                        self.locationField.text = place.lines?[0] ?? ""
                        self.placeName = self.locationField.text ?? ""
                    }
                }
            }
            self.viewModel.isLoading = false
        })
    }
    
    func setButton() {
        self.signUpBtn.buttonColor = .orange
        self.signUpBtn.setText(text: "Sign Up")
        self.signUpBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            self.fullNameField.resignFirstResponder()
            self.contactNumberField.resignFirstResponder()
            self.emailField.resignFirstResponder()
            self.passwordField.resignFirstResponder()
            self.confirmPasswordField.resignFirstResponder()
            self.locationField.resignFirstResponder()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                (self.viewModel as! SignUpViewModel).signUp(fullName: self.fullNameField.text ?? "", contactNo: self.contactNumberField.text ?? "", email: self.emailField.text ?? "", password: self.passwordField.text ?? "", confirmPassword: self.confirmPasswordField.text ?? "", latitude: self.latitude, longitude: self.longitude, location: self.locationField.text ?? "".encodeUrl()!)
            }
        })
    }
    
    
    func errorTextMessage() {
        (self.viewModel as! SignUpViewModel).validateField = { [weak self] errorText in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                ToastView.getInstance().showToast(inView: self.view, textToShow: errorText,backgroundColor: Theme.appOrangeColor)
            }
        }
    }
    
    func routeToHomeView() {
        (viewModel as! SignUpViewModel).setSignupRoute = { [weak self] userModel in
            DispatchQueue.main.async {
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
    }
    
    func passwordNotMatched() {
        (viewModel as! SignUpViewModel).validatePassword = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                ToastView.getInstance().showToast(inView: self.view, textToShow: "Password doesn't match.",backgroundColor: Theme.appOrangeColor)
            }
        }
    }
    
    @objc func openLocationPicker(textField: UITextField) {
        
    }
    
//    @objc func fetchCurrentLocation() {
//        // Implement fetching current location here
//        // You can use CoreLocation framework to get the user's current location
//        locationManager.startUpdatingLocation()
//    }

    @IBAction func backTapped() {
        self.routeBack(navigation: .pop)
    }
    @IBAction func openLocationPickerBtn(_ sender : UIButton) {
        let controller = PlacePicker.placePickerController()
        controller.delegate = self
//        let fetchLocationButton = UIButton(type: .system)
//        fetchLocationButton.setTitle("Fetch Current Location", for: .normal)
//        fetchLocationButton.addTarget(self, action: #selector(fetchCurrentLocation), for: .touchUpInside)
//        controller.view.addSubview(fetchLocationButton)
//        
//        // Add constraints for the button
//        fetchLocationButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            fetchLocationButton.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
//            fetchLocationButton.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor, constant: -150) // Adjust the position as per your UI
//        ])
        let navigationController = UINavigationController(rootViewController: controller)
        self.show(navigationController, sender: nil)
    }

    
    @IBAction func signInBtn(_ sender : UIButton) {
        let vc : LoginView = AppRouter.instantiateViewController(storyboard: .authentication)
        self.route(to: vc, navigation: .push)
    }
    
    @objc func contactPressed() {
        let vc = PhoneNumberPickerVC()
        vc.setUpPhonePicker(maximumExcludingDailingCode: 15,
                            minmumDigitsRequired: 10,
                            backBarItemImage: nil,
                            isTransparentNavigation: true,
                            navigationBarItemColor: .darkGray,
                            textColors: .gray)
        //vc.navigationFont = Theme.getAppFont(withSize: 15)
        vc.delegate = self
        vc.isCodeRequired = false
        vc.countryModel = self.isoModel
        vc.selectedNumber = self.number
        let nvc = UINavigationController.init(rootViewController: vc)
        self.route(to: nvc, navigation: .present)
    }
    
    @IBAction func termsCondition(_ sender : UIButton) {
        let vc : AboutUsView = AppRouter.instantiateViewController(storyboard: .more)
        vc.screenType = .tc
        self.route(to: vc, navigation: .push)
    }
    
    @IBAction func privacyPolicy(_ sender : UIButton) {
        let vc : AboutUsView = AppRouter.instantiateViewController(storyboard: .more)
        vc.screenType = .pp
        self.route(to: vc, navigation: .push)
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
    
    @IBAction func confirmPasswordEye(_ sender : UIButton) {
        if confirmPasswordEyeBool {
            confirmPasswordEyeBool = false
            self.confirmPasswordEye.image = UIImage(named: "closedEye")?.withRenderingMode(.alwaysTemplate)
            confirmPasswordField.isSecureTextEntry = true
        } else {
            confirmPasswordEyeBool = true
            self.confirmPasswordEye.image = UIImage(named: "openEye")?.withRenderingMode(.alwaysTemplate)
            confirmPasswordField.isSecureTextEntry = false
        }
    }
}

extension SignUpView : PhoneNumberPickerVCDelegate {
    func phoneNumberPicker(number: String, isoModel: IsoCountryInfo) {
        self.number = number
        self.isoModel = isoModel
        self.contactNumberField.text = "\(self.isoModel!.calling)-\(self.number)"
    }
}

extension SignUpView: PlacesPickerDelegate {
    func placePickerControllerDidCancel(controller: PlacePickerController) {
        controller.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func placePickerController(controller: PlacePickerController, didSelectPlace place: GMSPlace) {
        controller.navigationController?.dismiss(animated: true, completion: nil)
        
        self.latitude = "\(place.coordinate.latitude)"
        self.longitude = "\(place.coordinate.longitude)"
//        self.placeName = (place.formattedAddress ?? "").utf8EncodedString()
//        print(self.placeName + self.latitude + self.longitude)
        
        updateLocationName(coordinates: place.coordinate)
    }
}

extension SignUpView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameField{
            textField.resignFirstResponder()
            contactNumberField.becomeFirstResponder()
        } else if textField == contactNumberField {
            textField.resignFirstResponder()
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            textField.resignFirstResponder()
            confirmPasswordField.becomeFirstResponder()
        } else if textField == confirmPasswordField {
            textField.resignFirstResponder()
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

//extension SignUpView: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else {
//            return
//        }
//        
//        // Use the received location
//        print("Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
//        updateLocationName(coordinates: location.coordinate)
//        // Optionally, stop location updates if you only need one location
//        locationManager.stopUpdatingLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location manager error: \(error.localizedDescription)")
//    }
//}
