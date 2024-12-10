//
//  BarberEditProfileView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 23/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import IQKeyboardManagerSwift
import UIImageCropper
import OpalImagePicker
import Photos
import PlacesPicker
import GooglePlaces
import GoogleMaps

class BarberEditProfileView : BaseView, Routeable {
    
    @IBOutlet weak var fullNameField : UITextField!
    @IBOutlet weak var contactNumberField : UITextField!
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var locationTest : UITextField!
    @IBOutlet weak var updateProfileBtn : MoCutsAppButton!
    @IBOutlet weak var uploadImageMainView : UIView!
    @IBOutlet weak var uploadImageView : UIImageView!
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var navView : UIView!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var messageField : UITextView!
    @IBOutlet weak var messagePlaceholder : UILabel!
    @IBOutlet weak var removeLocationBtn: UIButton!
    let locationWarning = "Your profile won't appear in searches without your location."
    private var latitude: String = ""
    private var longitude: String = ""
    private var placeName: String = ""
    let opalImagePicker = OpalImagePickerController()
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    var profileSelectedImage: UIImage?
    var edit : Bool = false
    let imagePicker = UIImagePickerController()
    let cropper = UIImageCropper(cropRatio: 283/200)
    private var number: String = ""
    private var isoModel: IsoCountryInfo? = nil
    var isBarberImage : Bool = true
    var galleryImages : [UIImage] = []
    var galleryImagesOne : [GalleryResponseModel] = []
    var barberProfile : User_Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setView()
        self.setButton()
        self.setCollectionView()
        viewModel = BarberEditProfileViewModel()
        (viewModel as! BarberEditProfileViewModel).getBarberProfile()
        (viewModel as! BarberEditProfileViewModel).getBarberImages(userId: UserPreferences.userModel?.id ?? 0)
        setBarberData()
        setBarberImages()
        editProfileSuccessRoute()
        errorTextMessage()
        setupCropper()
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func setupCropper() {
        cropper.delegate = self
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.addAnimatingGradient()
        }
        removeLocationBtn.isHidden = false
        self.fullNameField.autocapitalizationType = .words
        self.fullNameField.keyboardType = .default
        self.fullNameField.layer.borderColor = UIColor.lightGray.cgColor
        self.fullNameField.layer.borderWidth = 1.0
        self.fullNameField.layer.cornerRadius = 4
        self.fullNameField.delegate = self
        self.fullNameField.setLeftPaddingPoints(5)
        self.fullNameField.setRightPaddingPoints(5)
        
        self.locationTest.autocapitalizationType = .words
        self.locationTest.keyboardType = .namePhonePad
        self.locationTest.layer.borderColor = UIColor.lightGray.cgColor
        self.locationTest.layer.borderWidth = 1.0
        self.locationTest.layer.cornerRadius = 4
        self.locationTest.delegate = self
        self.locationTest.setLeftPaddingPoints(5)
        self.locationTest.setRightPaddingPoints(5)
        self.locationTest.isUserInteractionEnabled = false
        
        self.contactNumberField.isUserInteractionEnabled = true
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
        self.emailField.isUserInteractionEnabled = false
        
        self.messageField.textColor = UIColor(hex: "#212021")
        self.messageField.isUserInteractionEnabled = true
        self.messageField.autocapitalizationType = .sentences
        self.messageField.keyboardType = .default
        self.messageField.layer.borderColor = UIColor(hex: "#8D8D8D").cgColor
        self.messageField.layer.borderWidth = 1.0
        self.messageField.layer.cornerRadius = 4
        
        messageField.delegate = self
        messageField.textColor = UIColor(hex: "#212021")
        messageField.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        self.contactNumberField.addTarget(self, action: #selector(contactPressed), for: .allEvents)
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BarberPortfolioImageCell", bundle: nil), forCellWithReuseIdentifier: "BarberPortfolioImageCell")
        collectionView.register(UINib(nibName: "BarberAddImageCell", bundle: nil), forCellWithReuseIdentifier: "BarberAddImageCell")
    }
    
    func setButton() {
        self.updateProfileBtn.buttonColor = .orange
        self.updateProfileBtn.setText(text: "Save Changes")
        self.updateProfileBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            self.fullNameField.resignFirstResponder()
            self.contactNumberField.resignFirstResponder()
            self.emailField.resignFirstResponder()
            self.locationTest.resignFirstResponder()
            self.messageField.resignFirstResponder()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                (self.viewModel as! BarberEditProfileViewModel).editProfile(fullName: self.fullNameField, contactNumber: self.contactNumberField, emailID: self.emailField, location: self.locationTest,name: self.fullNameField.text ?? "", contact: self.contactNumberField.text ?? "", email: self.emailField.text ?? "" ,address: self.locationTest.text ?? "", lat: self.latitude, long: self.longitude, about: self.messageField.text ?? "",newImagesArray: self.galleryImages, profileImg: self.profileSelectedImage)
            }
        })
    }
    
    func setBarberData() {
        (viewModel as! BarberEditProfileViewModel).getBarberData = { [weak self] barber in
            
            
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                let model = (self.viewModel as! BarberEditProfileViewModel)
                self.fullNameField.text = model.name
                self.contactNumberField.text = model.contactNumber
                self.emailField.text = model.email
                self.longitude = model.longitude
                self.latitude = model.latitude
                self.locationTest.text = model.address.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
                self.removeLocationBtn.isHidden = self.locationTest.text == ""
                self.messageField.text = model.about
                self.messagePlaceholder.alpha = self.messageField.text == "" ? 1 : 0
                self.profileImageView.sd_setImage(with: URL(string: model.imageUrl), placeholderImage: UIImage())
            }
        }
    }
    
    func setBarberImages() {
        (viewModel as! BarberEditProfileViewModel).getBarberGalleryImage = { [weak self] images in
            if let images = images {
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    self.galleryImagesOne = images
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func editProfileSuccessRoute() {
        (self.viewModel as! BarberEditProfileViewModel).setUpdateProfileRoute = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.navigationController?.popViewController(animated: false)
            }
            
        }
    }
    
    func getPendingJobs() {
        (self.viewModel as! BarberEditProfileViewModel).setPendingJobsRoute = { [weak self] pendingJobsModel in
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
                    self.removeLocationBtn.isHidden = true
                    self.placeName = ""
                } else {
                    

                    ToastView.getInstance().showToast(inView: self.view, textToShow: "You cannot remove location as your job(s) are in progress.",backgroundColor: Theme.appOrangeColor)
                }
            }
        }
        (self.viewModel as! BarberEditProfileViewModel).getPendingJobs()
    }
    
    func errorTextMessage() {
        (self.viewModel as! BarberEditProfileViewModel).validateField = { [weak self] errorText in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                ToastView.getInstance().showToast(inView: self.view, textToShow: errorText,backgroundColor: Theme.appOrangeColor)
            }
        }
    }
    
    @IBAction func removeLocationTapped() {
        if locationTest.text != "" {
            getPendingJobs()
        }
    }
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    
    private func addAnimatingGradient() {
        self.navView.backgroundColor = UIColor.clear
        let gradientOne = UIColor.black.withAlphaComponent(0.7).cgColor
        let gradientTwo = UIColor.clear.cgColor
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
        //vc.navigationFont = Theme.getAppFont(withSize: 15)
        vc.delegate = self
        vc.isCodeRequired = false
        vc.countryModel = self.isoModel
        vc.selectedNumber = self.number
        let nvc = UINavigationController.init(rootViewController: vc)
        self.route(to: nvc, navigation: .present)
    }
    
    @IBAction func locationBtnTapped(_ sender: Any) {
        let controller = PlacePicker.placePickerController()
        controller.delegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        self.show(navigationController, sender: nil)
    }
    
    @IBAction func backBtnTapped(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadImageBtnTapped(_ sender : UIButton) {
        let alert = UIAlertController(title: "Capture/Upload Image", message: nil, preferredStyle: .actionSheet)
        let subview = alert.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertContentView.layer.cornerRadius = 15
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            guard let self = self else  {
                return
            }
            self.isBarberImage = true
            self.imagePicker.delegate = nil
            self.cropper.picker = self.imagePicker
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] _ in
            guard let self = self else  {
                return
            }
            self.isBarberImage = true
            self.cropper.picker = self.imagePicker
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension BarberEditProfileView : UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("printing picked image\(pickedImage)")
            if isBarberImage {
                profileImageView.contentMode = .scaleAspectFill
                profileImageView.image = pickedImage
                profileSelectedImage = pickedImage
            } else {
//                if !self.galleryImages.contains(pickedImage) {
//                    
//                }
                self.galleryImages.append(pickedImage)
                self.collectionView.reloadData()
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func handleOperationWithData(data: Data) {
        // Handle operations with data here...
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension BarberEditProfileView : PhoneNumberPickerVCDelegate {
    func phoneNumberPicker(number: String, isoModel: IsoCountryInfo) {
        self.number = number
        self.isoModel = isoModel
        self.contactNumberField.text = "\(self.isoModel!.calling)\(self.number)"
    }
}

extension BarberEditProfileView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameField{
            fullNameField.resignFirstResponder()
            _ = contactNumberField.becomeFirstResponder()
        } else if textField == contactNumberField {
            contactNumberField.resignFirstResponder()
            _ = emailField.becomeFirstResponder()
        } else if textField == emailField {
            emailField.resignFirstResponder()
            messageField.becomeFirstResponder()
        } else {
            
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !string.canBeConverted(to: String.Encoding.ascii) {
            return false
        }
        
        if textField == fullNameField {
            let maxLength = 41
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

extension BarberEditProfileView : UITextViewDelegate {
    
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

extension BarberEditProfileView : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        else if section == 1
        {
            return self.galleryImagesOne.count
        }
        else if section == 2
        {
            return self.galleryImages.count
        }
        return 1
        //        return self.galleryImagesOne.count + self.galleryImages.count + 1 //galleryImagesOne.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarberAddImageCell", for: indexPath) as! BarberAddImageCell
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarberPortfolioImageCell", for: indexPath) as! BarberPortfolioImageCell
            cell.delegate = self
            cell.indexPath = indexPath
            cell.deleteButton.imageView?.image = UIImage(named: "small-cross")
            cell.imagePet.layer.cornerRadius = 5
            cell.activity.isHidden = false
            cell.deleteButton.isHidden = true
            cell.imagePet.isHidden = true
            cell.activity.startAnimating()
            
            DispatchQueue.main.async {
                cell.deleteButton.isHidden = false
                cell.imagePet.isHidden = false
                cell.activity.isHidden = true
                cell.deleteButton.isUserInteractionEnabled = true
                
                if indexPath.section == 1 {
                    cell.imagePet.sd_setImage(with: URL(string: self.galleryImagesOne[indexPath.row].media_url ?? ""), placeholderImage: UIImage(named: "photo"))
                } else {
                    cell.imagePet.image = self.galleryImages[indexPath.row]
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.height - 20, height: collectionView.frame.height - 20)
        } else {
            return CGSize(width: collectionView.frame.height - 15, height: collectionView.frame.height - 20)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let alert = UIAlertController(title: "Capture/Upload Image", message: nil, preferredStyle: .actionSheet)
            let subview = alert.view.subviews.first! as UIView
            let alertContentView = subview.subviews.first! as UIView
            alertContentView.backgroundColor = UIColor.white
            alertContentView.layer.cornerRadius = 15
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                guard let self = self else  {
                    return
                }
                self.isBarberImage = false
                self.cropper.picker = nil
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.isBarberImage = false
                self.cropper.picker = nil
                self.opalImagePicker.imagePickerDelegate = self
                self.opalImagePicker.maximumSelectionsAllowed = 10
                self.present(self.opalImagePicker, animated: true, completion: nil)
                
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension BarberEditProfileView : BarberPortfolioImageCellMethod {
    func deleteImage(indexPath: IndexPath?) {
        if indexPath?.section == 1
        {
            Alert.showAlertWithYesNo(title: "Alert", message: "Are you sure you want to delete this gallery item?", vc: self) { (status) in
                if status!
                {
                    (self.viewModel as! BarberEditProfileViewModel).removeImage(id: self.galleryImagesOne[indexPath?.row ?? 0].id)
                    self.collectionView.reloadData()
                }
                else
                {
                    
                }
            }
        }
        else if indexPath?.section == 2
        {
            self.galleryImages.remove(at: indexPath?.row ?? 0)
            self.collectionView.reloadData()
        }
    }
}

extension BarberEditProfileView: OpalImagePickerControllerDelegate {
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
        opalImagePicker.imagePickerDelegate = nil
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        //Save Images, update UI
        if picker.maximumSelectionsAllowed == 1 {
            if assets.count > 0 {
                profileImageView.contentMode = .scaleAspectFill
                let pickedImage = assets[0]
                
                profileImageView.image = getUIImage(asset: pickedImage)
                profileSelectedImage = getUIImage(asset: pickedImage)
            }
        } else {
            for asset in assets {
                let im = self.getUIImage(asset: asset) ?? UIImage()
                self.galleryImages.append(im)
            }
            
            self.collectionView.reloadData()
            
        }
        opalImagePicker.imagePickerDelegate = nil
        //Dismiss Controller
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerNumberOfExternalItems(_ picker: OpalImagePickerController) -> Int {
        return 1
    }
    
    func imagePickerTitleForExternalItems(_ picker: OpalImagePickerController) -> String {
        return NSLocalizedString("External", comment: "External (title for UISegmentedControl)")
    }
    
    func imagePicker(_ picker: OpalImagePickerController, imageURLforExternalItemAtIndex index: Int) -> URL? {
        return URL(string: "https://placeimg.com/500/500/nature")
    }
    
}

extension BarberEditProfileView: PlacesPickerDelegate {
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

extension BarberEditProfileView {
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

extension BarberEditProfileView : UIImageCropperProtocol {
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = croppedImage
        profileSelectedImage = croppedImage
    }
}
