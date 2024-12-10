//
//  BarberAddNewCardView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 06/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class BarberAddNewCardView: BaseView, Routeable {
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var cardHolderField : AppFieldView!
    @IBOutlet weak var cardNumberField : AppFieldView!
    @IBOutlet weak var cvvField : AppFieldView!
    @IBOutlet weak var expiredDateField : AppFieldView!
    @IBOutlet weak var addCardBtn : MoCutsAppButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        viewModel = GetStartedViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setView()
        self.setButton()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "BarberAddNewCardCell", bundle: nil), forCellWithReuseIdentifier: "BarberAddNewCardCell")
//        tableView.separatorStyle = .none
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: nil, title: "Add New Card", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
        
        TextFieldHandler.shared.register(textFields: [cardHolderField.textField, cardNumberField.textField, cvvField.textField,
//                                                      locationField.textField,
                                                      expiredDateField.textField])
        
        self.cardHolderField.setCustomFieldView(titleTxt: "Card Holder Name",
                                               typeOfView: .textField,
                                               placeholder: "Card Holder Name",rightImage: nil,
                                               isRequiredField: false,validation: .name)
        
        self.cardNumberField.setCustomFieldView(titleTxt: "Card Number",
                                                  typeOfView: .numberField,
                                                  placeholder: "Card Number",rightImage: nil,
                                                  isRequiredField: false,validation: .phone)
        
        self.cvvField.setCustomFieldView(titleTxt: "CVV",
                                                  typeOfView: .password,
                                                  placeholder: "CVV",rightImage: nil,
                                                  isRequiredField: false,validation: .password)
        
        self.expiredDateField.setCustomFieldView(titleTxt: "Expired Date",
                                                  typeOfView: .textField,
                                                  placeholder: "Expired Date",rightImage: nil,
                                                  isRequiredField: false,validation: .general)
        
        self.cardHolderField.textField.autocapitalizationType = .words
        self.cardHolderField.textField.keyboardType = .namePhonePad
        
        self.cardNumberField.textField.autocapitalizationType = .none
        self.cardNumberField.textField.keyboardType = .numberPad
        
        self.cvvField.textField.autocapitalizationType = .none
        self.cvvField.textField.keyboardType = .numberPad
                
        self.expiredDateField.textField.autocapitalizationType = .none
        self.expiredDateField.textField.keyboardType = .numbersAndPunctuation
    }
    
    func setButton() {
        self.addCardBtn.buttonColor = .orange
        self.addCardBtn.setText(text: "Add Card")
        self.addCardBtn.setAction(actionP: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        })
    }
}

extension BarberAddNewCardView : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarberAddNewCardCell", for: indexPath) as! BarberAddNewCardCell
        if indexPath.row == 0 {
            cell.paymentMethodImage.image = UIImage(named: "masterCardCell")
        } else if indexPath.row == 1 {
            cell.paymentMethodImage.image = UIImage(named: "PayPalCell")
        } else if indexPath.row == 2 {
            cell.paymentMethodImage.image = UIImage(named: "ApplePayCell")
        } else if indexPath.row == 3 {
            cell.paymentMethodImage.image = UIImage(named: "googlePayCell")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 80)
    }
}
