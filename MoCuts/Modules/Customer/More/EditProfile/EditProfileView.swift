//
//  EditProfileView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 13/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import UIImageCropper
import PlacesPicker
import GooglePlaces
import GoogleMaps

protocol EditProfileViewDelegate: AnyObject {
    func updateData(newData: User_Model, image: UIImage?)
}

class EditProfileView: BaseView, Routeable {
    
    @IBOutlet weak var fullNameField : UITextField!
    @IBOutlet weak var contactNumberField : UITextField!
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var locationTest : UITextField!
    
    @IBOutlet weak var updateProfileBtn : MoCutsAppButton!
    @IBOutlet weak var uploadImageMainView : UIView!
    @IBOutlet weak var uploadImageView : UIImageView!
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var navView : UIView!
    @IBOutlet weak var editProfileBtn : UIButton!
    @IBOutlet weak var removeLocationBtn: UIButton!
    var delegate: EditProfileViewDelegate?
    let userModel = UserPreferences.userModel
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    let imagePicker = UIImagePickerController()
    let cropper = UIImageCropper(cropRatio: 283/200)
    var profileSelectedImage: UIImage?
    
    private var latitude: String = ""
    private var longitude: String = ""
    private var placeName: String = ""
    private var isoModel: IsoCountryInfo? = nil
    private var number: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EditProfileViewModel()
        editProfileSuccessRoute()
        errorTextMessage()
        setData()
        setupCropper()
    }
    func setupCropper() {
        cropper.picker = self.imagePicker
        cropper.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setView()
        self.setButton()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.addAnimatingGradient()
        }
        editProfileBtn.isHidden = true
        removeLocationBtn.isHidden = false
        self.fullNameField.autocapitalizationType = .words
        self.fullNameField.keyboardType = .namePhonePad
        self.fullNameField.layer.borderColor = UIColor.lightGray.cgColor
        self.fullNameField.layer.borderWidth = 1.0
        self.fullNameField.layer.cornerRadius = 4
        self.fullNameField.delegate = self
        fullNameField.setLeftPaddingPoints(5)
        fullNameField.setRightPaddingPoints(5)
        
        self.locationTest.autocapitalizationType = .words
        self.locationTest.keyboardType = .namePhonePad
        self.locationTest.layer.borderColor = UIColor.lightGray.cgColor
        self.locationTest.layer.borderWidth = 1.0
        self.locationTest.layer.cornerRadius = 4
        self.locationTest.delegate = self
        self.locationTest.isUserInteractionEnabled = false
        locationTest.setLeftPaddingPoints(5)
        locationTest.setRightPaddingPoints(5)
        
        self.contactNumberField.isUserInteractionEnabled = true
        self.contactNumberField.autocapitalizationType = .none
        self.contactNumberField.keyboardType = .numberPad
        self.contactNumberField.layer.borderColor = UIColor.lightGray.cgColor
        self.contactNumberField.layer.borderWidth = 1.0
        self.contactNumberField.layer.cornerRadius = 4
        self.contactNumberField.delegate = self
        contactNumberField.setLeftPaddingPoints(5)
        contactNumberField.setRightPaddingPoints(5)
        
        self.emailField.autocapitalizationType = .none
        self.emailField.keyboardType = .emailAddress
        self.emailField.layer.borderColor = UIColor.lightGray.cgColor
        self.emailField.layer.borderWidth = 1.0
        self.emailField.layer.cornerRadius = 4
        self.emailField.delegate = self
        emailField.setLeftPaddingPoints(5)
        emailField.setRightPaddingPoints(5)
        emailField.isUserInteractionEnabled = false
        
        contactNumberField.addTarget(self, action: #selector(contactPressed), for: .allEvents)
    }
    
    func setButton() {
        self.updateProfileBtn.buttonColor = .orange
        self.updateProfileBtn.setText(text: "Update Profile")
        self.updateProfileBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            self.fullNameField.resignFirstResponder()
            self.contactNumberField.resignFirstResponder()
            self.emailField.resignFirstResponder()
            self.locationTest.resignFirstResponder()
            
            DispatchQueue.main.async {
                (self.viewModel as! EditProfileViewModel).editProfile(fullName: self.fullNameField, contactNumber: self.contactNumberField, emailID: self.emailField, location: self.locationTest, lat: self.latitude, long: self.longitude, profileImg: self.profileSelectedImage)
            }
        })
    }
    
    func editProfileSuccessRoute() {
        (self.viewModel as! EditProfileViewModel).setUpdateProfileRoute = { userModelResponse in
            UserPreferences.userModel = userModelResponse
            self.setData(shouldSetImage: false)
            self.delegate?.updateData(newData: userModelResponse, image: self.profileSelectedImage)
            self.routeBack(navigation: .pop)
        }
    }
    
    func getPendingJobs() {
        
        (self.viewModel as! EditProfileViewModel).setPendingJobsRoute = { [weak self] pendingJobsModel in
            guard let self = self else {
                return
            }
            let pendingJobsCount = pendingJobsModel.jobsCount ?? -1
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if pendingJobsCount == 0 {
                    self.latitude = ""
                    self.longitude = ""
                    self.placeName = ""
                    self.locationTest.text = ""
                    self.placeName = ""
                    self.removeLocationBtn.isHidden = true
                } else {
                    ToastView.getInstance().showToast(inView: self.view, textToShow: "You cannot remove location as your job(s) are in progress.",backgroundColor: Theme.appOrangeColor)
                }
            }
        }
        (self.viewModel as! EditProfileViewModel).getPendingJobs()
    }
    
    func errorTextMessage() {
        (self.viewModel as! EditProfileViewModel).validateField = { [weak self] errorText in
            DispatchQueue.main.async {
                guard let self = self else { return }
                ToastView.getInstance().showToast(inView: self.view, textToShow: errorText,backgroundColor: Theme.appOrangeColor)
            }
        }
    }
    
    func setData(shouldSetImage:Bool = true)
    {
        DispatchQueue.main.async {
            
            self.fullNameField.text = self.userModel?.name
            self.contactNumberField.text = self.userModel?.phone
            self.emailField.text = self.userModel?.email
            self.latitude = self.userModel?.latitude ?? ""
            self.longitude = self.userModel?.longitude ?? ""
            self.locationTest.text = self.userModel?.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
            self.removeLocationBtn.isHidden = self.locationTest.text == ""
            if shouldSetImage {
                self.profileImageView.sd_setImage(with: URL(string: self.userModel?.image_url ?? ""))
            }
        }
    }
    
    private func addAnimatingGradient() {
        self.navView.backgroundColor = UIColor.clear
        let gradientOne = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.6).cgColor
        let gradientTwo = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.01).cgColor
        gradientSet.append([gradientOne, gradientTwo])
        gradient.frame = self.navView.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.locations = [0.0, 1.0]
        gradient.drawsAsynchronously = true
        self.navView.layer.insertSublayer(gradient, at :0)
    }
    
    @objc func contactPressed() {
        let vc = PhoneNumberPickerVC()
        vc.setUpPhonePicker(maximumExcludingDailingCode: 15,
                            minmumDigitsRequired: 10,
                            backBarItemImage: nil,
                            isTransparentNavigation: true,
                            navigationBarItemColor: .darkGray,
                            textColors: .gray)
        vc.delegate = self
        vc.isCodeRequired = false
        vc.countryModel = self.isoModel
        vc.selectedNumber = self.number
        let nvc = UINavigationController.init(rootViewController: vc)
        self.route(to: nvc, navigation: .present)
    }
    
    @IBAction func backBtnTapped(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removeLocationTapped() {
        if self.locationTest.text != "" {
            getPendingJobs()
        }
    }
    
    @IBAction func uploadImageBtnTapped(_ sender : UIButton) {
        
        let alert = UIAlertController(title: "Capture/Upload Image", message: nil, preferredStyle: .actionSheet)
        let subview = alert.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertContentView.layer.cornerRadius = 15
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func locationBtnTapped(_ sender: Any) {
        let controller = PlacePicker.placePickerController()
        controller.delegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        self.show(navigationController, sender: nil)
    }
}

extension EditProfileView : PhoneNumberPickerVCDelegate {
    func phoneNumberPicker(number: String, isoModel: IsoCountryInfo) {
        self.number = number
        self.isoModel = isoModel
        self.contactNumberField.text = "\(self.isoModel!.calling)\(self.number)"
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension EditProfileView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameField{
            fullNameField.resignFirstResponder()
            _ = contactNumberField.becomeFirstResponder()
        } else if textField == contactNumberField {
            contactNumberField.resignFirstResponder()
            _ = locationTest.becomeFirstResponder()
        } else if textField == locationTest {
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
        } else if textField == locationTest {
            let maxLength = 100
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}

//MARK: UIImageCropperDelegate
extension EditProfileView : UIImageCropperProtocol {
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = croppedImage
        profileSelectedImage = croppedImage
    }
}

//MARK: PlacesPickerDelegate
extension EditProfileView: PlacesPickerDelegate {
    func placePickerControllerDidCancel(controller: PlacePickerController) {
        controller.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func placePickerController(controller: PlacePickerController, didSelectPlace place: GMSPlace) {
        controller.navigationController?.dismiss(animated: true, completion: nil)
        
        self.latitude = "\(place.coordinate.latitude)"
        self.longitude = "\(place.coordinate.longitude)"
        self.placeName = place.formattedAddress ?? ""
        updateLocationName(coordinates: place.coordinate)
    }
}

extension EditProfileView {
    func updateLocationName(coordinates: CLLocationCoordinate2D) {
        let gmsGeocoder = GMSGeocoder()
        viewModel.isLoading = true
        gmsGeocoder.reverseGeocodeCoordinate(coordinates, completionHandler: {
            response, error in
            if error == nil {
                if let places = response?.results() {
                    if let place = places.first, place.lines?.count > 0 {
                        self.locationTest.text = place.lines?[0] ?? ""
                        self.placeName = self.locationTest.text ?? ""
                        self.removeLocationBtn.isHidden = self.locationTest.text == ""
                    }
                }
            }
            self.viewModel.isLoading = false
        })
    }
}
