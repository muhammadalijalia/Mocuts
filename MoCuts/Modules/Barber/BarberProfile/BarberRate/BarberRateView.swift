//
//  BarberRateView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 16/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import Cosmos
import IQKeyboardManagerSwift

@objc protocol BarberRateViewDelegate: AnyObject {
    @objc func reviewDone(view: BarberRateView)
}

class BarberRateView : BaseView, Routeable {
    
    @IBOutlet weak var titleText : UILabel!
    @IBOutlet weak var commentTextView : UITextView!
    @IBOutlet weak var submitBtn : MoCutsAppButton!
    @IBOutlet weak var cosmosView : CosmosView!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var reviewRequiredLabel: UILabel!
    var delegate: BarberRateViewDelegate?
    var jobId: Int?
    var toId: Int?
    
    var screenCase : UserMode = .customer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.keyboardType = .asciiCapable

        viewModel = BarberRateViewModel()
        setupViewModelObserver()
        cosmosView.settings.minTouchRating = 0.5
    }
    
    func setButton() {
        self.submitBtn.buttonColor = .orange
        self.submitBtn.setText(text: "Submit")
        self.submitBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            if self.commentTextView.isFirstResponder {
                self.commentTextView.resignFirstResponder()
            }
            var reviewComment = ""
            if self.commentTextView.textColor != UIColor.lightGray {
                reviewComment = self.commentTextView.text
            }
            if reviewComment == "" {
                self.reviewRequiredLabel.alpha = 1
                return
            }

            (self.viewModel as! BarberRateViewModel).postReview(rating: self.cosmosView.rating, review: reviewComment, jobId: (self.jobId ?? 0), toId: (self.toId ?? 0))
        })
    }
    
    func setupViewModelObserver() {
        (viewModel as! BarberRateViewModel).setReviewResponseRoute = { response in
            self.delegate?.reviewDone(view: self)
        }
        (viewModel as! BarberRateViewModel).setFailureRoute = { response in
//            DispatchQueue.main.async {
//                self.dismiss(animated: true, completion: {
//                    self.routeBack(navigation: .popToRootVC)
//                })
//            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setView()
        self.setButton()
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        mainView.layer.cornerRadius = 5
        commentTextView.layer.cornerRadius = 4
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = Theme.appTextFieldPlaceHolderColor.cgColor
        titleText.text = "Service has been completed.\nPlease rate your \(screenCase == .customer ? "barber" : "customer")."
        commentTextView.textColor = UIColor(hex: "#212021")
        commentTextView.isUserInteractionEnabled = true
        commentTextView.autocapitalizationType = .words
        commentTextView.keyboardType = .default
        commentTextView.layer.borderColor = UIColor(hex: "#8D8D8D").cgColor
        commentTextView.layer.borderWidth = 1.0
        commentTextView.layer.cornerRadius = 4
        
        commentTextView.delegate = self
        commentTextView.text = "Enter your comments here..."
        commentTextView.textColor = UIColor.lightGray
        commentTextView.selectedTextRange = commentTextView.textRange(from: commentTextView.beginningOfDocument, to: commentTextView.beginningOfDocument)
        commentTextView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        cosmosView.settings.fillMode = .half
    }
}

extension BarberRateView : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.containsEmoji {
            return false
        }
        reviewRequiredLabel.alpha = 0
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {
            commentTextView.text = "Enter your comments here..."
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor(hex: "#212021")
            commentTextView.text = text
        } else {
            return true
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
