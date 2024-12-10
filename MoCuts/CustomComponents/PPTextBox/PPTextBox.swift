//
//  ViewWithTextField.swift
//  Scholarship
//
//  Created by Appiskey
//  Copyright © 2017 Appiskey. All rights reserved.
//

//import UIKit
//
//class PPTextBox: UIView {
//    
//    // Outlets and Variables
//    var view: UIView!
//    
//    @IBOutlet weak private var rightImageView: UIImageView!
//    @IBOutlet weak var textField: UITextField!
//    @IBOutlet weak var mainView: UIView!
//    @IBOutlet weak private var errorLbl: UILabel!
//    @IBOutlet weak var textBoxImageViewTrailingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var textBoxTextFieldLeadingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imgViewHeightConstraint: NSLayoutConstraint!
//    
//    var isFilled: Bool {
//        get {
//            
//            if textField.text! == "" {
//                errorLbl.isHidden = false
//                errorLbl.text = "Required"
//                return false
//                
//            } else {
//                errorLbl.isHidden = true
//                return true
//            }
//        }
//    }
//    
//    var textBoxViewModel = TextBoxViewModel()
//    
//    override init(frame: CGRect) {
//        // 1. setup any properties here
//        
//        // 2. call super.init(frame:)
//        super.init(frame: frame)
//        
//        // 3. Setup view from .xib file
//        xibSetup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        // 1. setup any properties here
//        
//        // 2. call super.init(coder:)
//        super.init(coder: aDecoder)
//        
//        // 3. Setup view from .xib file
//        xibSetup()
//        self.textField.autocorrectionType = .no
//    }
//    
//    func xibSetup() {
//        
//        view = loadViewFromNib()
//        
//        // use bounds not frame or it'll be offset
//        view.frame = bounds
//        
//        // Make the view stretch with containing view
//        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
//        
//        // Adding custom subview on top of our view (over any custom drawing > see note below)
//        
//        self.errorLbl.isHidden = true
//        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        
//        addSubview(view)
//        
//        self.setFont()
//        self.observerChangeInErrorText()
//        self.observerChangeInFieldText()
//        self.observerChangeInImage()
//    }
//    
//    func setFont(placeholder: String = "",
//                 placeHolderColor: UIColor = .white,
//                 textColor: UIColor = .white){
//        
//        let font = Theme.getAppFont(withSize: 15)
//        let iPadMediumFont = Theme.getAppMediumFont(withSize: 27)
//        let iPadFont = Theme.getAppFont(withSize: 27)
//        //        self.textField.placeholder = placeholder
//        self.textField.textColor = textColor
//        
//        
//        if UIDevice.current.model == "iPad" {
//            
//            self.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key .foregroundColor: placeHolderColor, NSAttributedString.Key.font : iPadMediumFont])
//            self.textField.font = iPadFont
//            textBoxTextFieldLeadingConstraint.constant = 20
//            textBoxImageViewTrailingConstraint.constant = 20
//            
//        } else {
//            self.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key .foregroundColor: placeHolderColor, NSAttributedString.Key.font : font])
//            self.textField.font = font
//        }
//    }
//    
//    // Function for load Nib on TextBox
//    func loadViewFromNib() -> UIView {
//        
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: "PPTextBox", bundle: bundle)
//        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
//        
//        return view
//    }
//    // Function for shake view when not valid
//    func shakeView() {
//        let animation = CABasicAnimation(keyPath: "position")
//        animation.duration = 0.07
//        animation.repeatCount = 4
//        animation.autoreverses = true
//        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
//        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
//        view.layer.add(animation, forKey: "position")
//    }
//    // Function for setting placeHolder
////    func setTextFieldPlaceHolder(string: String){
////        // self.textField.placeholder = string
////        let attributes = [
////            NSAttributedString.Key.foregroundColor: Theme.whiteColor,
////            NSAttributedString.Key.font : UIFont(name: "\(Constants.fontName)-Bold", size: 100)! // Note the !
////        ]
////        self.textField.attributedPlaceholder = NSAttributedString(string: string, attributes:attributes)
////        //self.textField.placeholderLabel.text = string
////    }
//    // Function for set TextField Text
//    func setTextFieldText(string: String){
//        self.textField.text = string
//    }
//    // Function for sest image
//    func setImage(string: String){
//        if UIDevice.current.model == "iPad" {
//            imgViewHeightConstraint.constant = 25
//        } else {
//            imgViewHeightConstraint.constant = 20
//        }
//        self.rightImageView.image = UIImage(named:string)
//    }
//    
//    func setTitle(string: String) {
//        
//    }
//
//    override func draw(_ rect: CGRect) {
//        
//        if UIDevice.current.model == "iPad" {
//            self.mainView.layer.borderWidth = 2
//            self.mainView.layer.borderColor = UIColor.white.cgColor
//            self.mainView.layer.cornerRadius = 12
//        }
//        else {
//            self.mainView.layer.borderWidth = 1
//            self.mainView.layer.borderColor = UIColor.white.cgColor
//            self.mainView.layer.cornerRadius = 8
//        }
//        
//        
//    }
//    // Function for setting textFieldView
//    func setTextFieldView(placeholder: String = "",
//                          title: String? = nil,
//                          imageName: String? = nil,
//                          placeHolderColor: UIColor = .white,
//                          textColor: UIColor = UIColor.white){
//        
//        self.textField.textColor = textColor//placeHolderColor
//        
//        self.setFont(placeholder: placeholder,
//                     placeHolderColor: placeHolderColor,
//                     textColor: textColor)
//        if let name = imageName, name != "" , let image = UIImage(named:name) {
//            self.rightImageView.image = image
//            self.textBoxViewModel.rightImage = image
//        } else {
//            self.rightImageView.image = nil
//        }
//        
//        
//    }
//    
//    func observerChangeInFieldText(){
//        textBoxViewModel.textFieldTextSetted = { (text) in
//            DispatchQueue.main.async {
//                self.textField.text = text
//            }
//        }
//    }
//    
//    func observerChangeInErrorText(){
//        textBoxViewModel.errorMsgTextSetted = { (error) in
//            DispatchQueue.main.async {
//                self.errorLbl.isHidden = false
//                self.errorLbl.text = error
//            }
//        }
//    }
//    
//    func observerChangeInImage(){
//        textBoxViewModel.rightImageSetted = { (image) in
//            DispatchQueue.main.async {
//                self.rightImageView.image = image
//            }
//        }
//    }
//    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        if textField.text == "" {
//            self.errorLbl.isHidden = false
//        } else {
//            self.errorLbl.isHidden = true
//            self.textBoxViewModel.setFieldText(txt: textField.text ?? "")
//        }
//    }
//    
//}


//class TextBoxViewModel{
//    var textFieldTextSetted : ((String) -> Void)?
//    var textFieldText: String = ""{
//        didSet{
//            self.textFieldTextSetted?(textFieldText)
//        }
//    }
//    
//    var errorMsgTextSetted : ((String) -> Void)?
//    var errorMsgText: String = ""{
//        didSet{
//            self.errorMsgTextSetted?(errorMsgText)
//        }
//    }
//    
//    var rightImageSetted : ((UIImage) -> Void)?
//    var rightImage: UIImage = UIImage(){
//        didSet{
//            self.rightImageSetted?(rightImage)
//        }
//    }
//    
//    func setFieldText(txt: String){
//        self.textFieldText = txt
//    }
//    
//    func setErrorText(txt: String){
//        self.errorMsgText = txt
//    }
//    
//    func rightImageChanged(image: UIImage){
//        self.rightImage = image
//    }
//    
//}
