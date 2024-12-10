//
//  StatusPopupView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 09/09/2021.
//

import UIKit
import Foundation

class StatusPopupView: UIViewController {

    @IBOutlet weak var statusImage : UIImageView!
    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var errorText : UILabel!
    @IBOutlet weak var errorTextButton : UIButton!
    
    var status : Bool = true
    var errorMessage : String = "Error decoding data"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        errorText.textAlignment = NSTextAlignment.left
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.errorTextButton.setTitle(self.errorMessage, for: .normal)
//            self.errorText.text = self.errorMessage
            self.bgView.roundCorners(usingCorners: [.topLeft, .topRight], cornertRadius: CGSize(width: 8, height: 8))
            if self.status {
//                self.statusImage.isHidden = true
                self.bgView.backgroundColor = UIColor( red: 113/225, green: 158/225, blue: 25/225, alpha: 1)
                self.statusImage.image = UIImage(named: "WhiteCheckMark")
            } else {
                self.bgView.backgroundColor = UIColor( red: 190/225, green: 18/225, blue: 24/225, alpha: 1)
                self.statusImage.image = UIImage(named: "WhiteWrongCheck")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
//        self.errorText.sizeToFit()
//        self.errorText.numberOfLines = 0
        errorTextButton.titleLabel?.font = Theme.getAppFont(withSize: 13)
        errorTextButton.titleLabel?.numberOfLines = 3
        errorTextButton.titleLabel?.lineBreakMode = .byCharWrapping
        errorTextButton.contentVerticalAlignment = .top
        errorTextButton.contentHorizontalAlignment = .left
        errorTextButton.isUserInteractionEnabled = false
        errorTextButton.autoresizesSubviews = true
        errorTextButton.autoresizingMask = .flexibleWidth
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
