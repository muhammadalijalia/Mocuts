//
//  MyProfileView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 30/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class MyProfileView: BaseView, Routeable {
    
    @IBOutlet weak var fullNameField : UITextField!
    @IBOutlet weak var contactNumberField : UITextField!
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var locationField : UITextField!
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var navView : UIView!
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MyProfileViewModel()
        self.setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setView()
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
        
        self.fullNameField.autocapitalizationType = .words
        self.fullNameField.keyboardType = .namePhonePad
        self.fullNameField.setLeftPaddingPoints((5))
        self.fullNameField.setRightPaddingPoints((5))
        self.fullNameField.layer.borderColor = UIColor.lightGray.cgColor
        self.fullNameField.layer.borderWidth = 1.0
        self.fullNameField.layer.cornerRadius = 4

        
        self.contactNumberField.autocapitalizationType = .none
        self.contactNumberField.keyboardType = .numberPad
        self.contactNumberField.setLeftPaddingPoints((5))
        self.contactNumberField.setRightPaddingPoints((5))
        self.contactNumberField.layer.borderColor = UIColor.lightGray.cgColor
        self.contactNumberField.layer.borderWidth = 1.0
        self.contactNumberField.layer.cornerRadius = 4

        self.emailField.autocapitalizationType = .none
        self.emailField.keyboardType = .emailAddress
        self.emailField.setLeftPaddingPoints((5))
        self.emailField.setRightPaddingPoints((5))
        self.emailField.layer.borderColor = UIColor.lightGray.cgColor
        self.emailField.layer.borderWidth = 1.0
        self.emailField.layer.cornerRadius = 4

        self.locationField.autocapitalizationType = .words
        self.locationField.keyboardType = .namePhonePad
        self.locationField.setLeftPaddingPoints((5))
        self.locationField.setRightPaddingPoints((5))
        self.locationField.layer.borderColor = UIColor.lightGray.cgColor
        self.locationField.layer.borderWidth = 1.0
        self.locationField.layer.cornerRadius = 4

    }
    
    func setData()
    {
            DispatchQueue.main.async {
                self.fullNameField.text = UserPreferences.userModel?.name
                self.contactNumberField.text = UserPreferences.userModel?.phone
                self.emailField.text = UserPreferences.userModel?.email
                self.locationField.text = UserPreferences.userModel?.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
                self.profileImageView.sd_setImage(with: URL(string: UserPreferences.userModel?.image_url ?? ""), placeholderImage: UIImage())
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
    
    @IBAction func editBtnTapped(_ sender : UIButton) {
        let vc : EditProfileView = AppRouter.instantiateViewController(storyboard: .more)
        vc.delegate = self
        self.route(to: vc, navigation: .push)
    }
    
    @IBAction func backBtnTapped(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyProfileView: EditProfileViewDelegate {
    func updateData(newData: User_Model, image: UIImage?) {
        DispatchQueue.main.async {
            self.fullNameField.text = newData.name
            self.contactNumberField.text = newData.phone
            self.emailField.text = newData.email
            self.locationField.text = newData.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
            if let image = image {
                self.profileImageView.image = image
            }
        }
    }
}
