//
//  BarberAddNewTimeSlotView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 22/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class BarberAddNewTimeSlotView: BaseView, Routeable {
    
    @IBOutlet weak var selectDayField : UITextField!
    @IBOutlet weak var startTimeField : UITextField!
    @IBOutlet weak var endTimeField : UITextField!
    @IBOutlet weak var addNewSlotBtn : MoCutsAppButton!
    
    var addBarberTimeSlot : ((GenericResponse<Availability_String>) -> Void)?
    
    var start_time: String = ""
    var end_time: String = ""
    var day: String = ""
    var minimumStartTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BarberAddNewTimeSlotViewModel()
        setAddNewTimeSlotRoute()
        errorTextMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setView()
        self.setButton()
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: nil, title: "Add New Time Slot", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
        
        self.selectDayField.isUserInteractionEnabled = false
        self.selectDayField.textColor = UIColor(hex: "#212021")
        self.selectDayField.autocapitalizationType = .words
        self.selectDayField.layer.borderColor = UIColor.lightGray.cgColor
        self.selectDayField.layer.borderWidth = 1.0
        self.selectDayField.layer.cornerRadius = 4
        self.selectDayField.setLeftPaddingPoints(5)
        self.selectDayField.setRightPaddingPoints(5)
        
        self.startTimeField.isUserInteractionEnabled = false
        self.startTimeField.textColor = UIColor(hex: "#212021")
        self.startTimeField.autocapitalizationType = .words
        self.startTimeField.layer.borderColor = UIColor.lightGray.cgColor
        self.startTimeField.layer.borderWidth = 1.0
        self.startTimeField.layer.cornerRadius = 4
        self.startTimeField.setLeftPaddingPoints(5)
        self.startTimeField.setRightPaddingPoints(5)
        
        self.endTimeField.isUserInteractionEnabled = false
        self.endTimeField.textColor = UIColor(hex: "#212021")
        self.endTimeField.autocapitalizationType = .words
        self.endTimeField.layer.borderColor = UIColor.lightGray.cgColor
        self.endTimeField.layer.borderWidth = 1.0
        self.endTimeField.layer.cornerRadius = 4
        self.endTimeField.setLeftPaddingPoints(5)
        self.endTimeField.setRightPaddingPoints(5)
        
    }
    
    func setButton() {
        self.addNewSlotBtn.buttonColor = .blue
        self.addNewSlotBtn.setText(text: "Add Time Slot")
        self.addNewSlotBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            (self.viewModel as! BarberAddNewTimeSlotViewModel).addNewTime(selectDay: self.selectDayField, startTime: self.startTimeField, endTime: self.endTimeField,day: self.day, start_time: self.start_time, end_time: self.end_time)
        })
    }
    
    func setAddNewTimeSlotRoute() {
        (viewModel as! BarberAddNewTimeSlotViewModel).setNewTimeAddRoute = { [weak self] slot in
            guard let self = self else {
                return
            }
            self.addBarberTimeSlot?(slot)
            self.routeBack(navigation: .pop)
        }
    }
    
    func errorTextMessage() {
        (self.viewModel as! BarberAddNewTimeSlotViewModel).validateField = { [weak self] errorText in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                ToastView.getInstance().showToast(inView: self.view, textToShow: errorText,backgroundColor: Theme.appOrangeColor)
            }
        }
    }
    
    @IBAction func selectDayBtnAction(_ sender : UIButton) {
        let attributedString = NSAttributedString(string: "Select Day", attributes: [
            NSAttributedString.Key.font : Theme.getAppMediumFont(withSize: 18),
            NSAttributedString.Key.foregroundColor : UIColor.black
        ])
        
        let alert = UIAlertController(title: "Select Day", message: nil, preferredStyle: .actionSheet)
        let subview = alert.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertContentView.layer.cornerRadius = 15
        alert.view.tintColor = Theme.appOrangeColor
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Monday", style: .default, handler: { _ in
            self.selectDayField.text = "Monday"
            self.day = "1"
        }))
        alert.addAction(UIAlertAction(title: "Tuesday", style: .default, handler: { _ in
            self.selectDayField.text = "Tuesday"
            self.day = "2"
        }))
        alert.addAction(UIAlertAction(title: "Wednesday", style: .default, handler: { _ in
            self.selectDayField.text = "Wednesday"
            self.day = "3"
        }))
        alert.addAction(UIAlertAction(title: "Thursday", style: .default, handler: { _ in
            self.selectDayField.text = "Thursday"
            self.day = "4"
        }))
        alert.addAction(UIAlertAction(title: "Friday", style: .default, handler: { _ in
            self.selectDayField.text = "Friday"
            self.day = "5"
        }))
        alert.addAction(UIAlertAction(title: "Saturday", style: .default, handler: { _ in
            self.selectDayField.text = "Saturday"
            self.day = "6"
        }))
        alert.addAction(UIAlertAction(title: "Sunday", style: .default, handler: { _ in
            self.selectDayField.text = "Sunday"
            self.day = "7"
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func startTimeSlotBtnAction(_ sender : UIButton) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let time = dateFormatter.string(from: Date())
        self.startTimeField.text = time
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "HH:mm"
        let time2 = dateFormatter2.string(from: Date())
        self.start_time = time2
                
        let alert = UIAlertController(style: .actionSheet, title: "Select Start Time Slot")
        
        alert.addDatePicker(mode: .time, date: Date(), minimumDate: nil, maximumDate: nil) { date in
            // action with selected date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let abc = dateFormatter.string(from: date)
            self.startTimeField.text = abc
            
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "HH:mm"
            let time2 = dateFormatter2.string(from: date)
            self.start_time = time2
            
            self.minimumStartTime = date
            
            self.end_time = ""
            self.endTimeField.text = ""
        }
        alert.addAction(title: "OK", style: .cancel)
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = view
            presenter.sourceRect = view.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func endTimeSlotBtnAction(_ sender : UIButton) {
//        self.endTimeField.text = "\()"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let time = dateFormatter.string(from: Date())
        self.endTimeField.text = time
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "HH:mm"
        let time2 = dateFormatter2.string(from: Date())
        self.end_time = time2
        
        let alert = UIAlertController(style: .actionSheet, title: "Select End Time Slot")
        
        alert.addDatePicker(mode: .time, date: minimumStartTime, minimumDate: self.minimumStartTime, maximumDate: nil) { date in
            // action with selected date
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let abc = dateFormatter.string(from: date)
            self.endTimeField.text = abc
            
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "HH:mm"
            let time2 = dateFormatter2.string(from: date)
            self.end_time = time2
            
        }
        alert.addAction(title: "OK", style: .cancel)
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = view
            presenter.sourceRect = view.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
}
