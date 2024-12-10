//
//  CustomerSelectDateTimeView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 31/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import CVCalendar


protocol CustomerSelectDateTimeViewDelegte {
    func itemSelected(date: String)
}
class CustomerSelectDateTimeView : BaseView, Routeable {
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var daysOutSwitch: UISwitch!
    @IBOutlet weak var doneBtn : MoCutsAppButton!
    private var currentCalendar: Calendar?
    private var shouldShowDaysOut = true
    private var animationFinished = true
    private var selectedDay: DayView!
    var selectedSlot: TimeSlot!
    var selectableTimeSlots = [CustomerWeekDays]()
    var userId = 0
    var duration = ""
    var shouldAutoSelect = true
    let today = DateManager.shared.getString(from: Date(), format: Constants.availibilitesDateFormat)
    var date = DateManager.shared.getString(from: Date(), format: Constants.availibilitesDateFormat)
    var timeSlotSelectionCallback: ((TimeSlot, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        viewModel = CustomerSelectDateTimeViewModel()
        setupViewModelObservers()
        getSlots()
    }
    
    func getSlots() {
        if let vm = viewModel as? CustomerSelectDateTimeViewModel {
            vm.getAllSlots(userID: userId, duration: duration, date: date)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setView()
        setButton()
        let newDate = DateManager.shared.getDate(from: date, format: Constants.availibilitesDateFormat, needsZone: true) ?? Date()
        calendarView.toggleViewWithDate(newDate)
        presentedDateUpdated(CVDate(date: newDate))
        updateCalendar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCalendar()
    }
    
    func updateCalendar() {
        DispatchQueue.main.async {
            self.calendarView.commitCalendarViewUpdate()
            self.menuView.commitMenuViewUpdate()
        }
    }
    
    func setupViewModelObservers() {
        (self.viewModel as! CustomerSelectDateTimeViewModel).setBarberTimeSlotData = { [weak self] slots, date in
            
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.selectableTimeSlots.removeAll()
                for slot in slots {
                    
                    let startTimeDate = DateManager.shared.getDate(from: slot.startTime ?? "", format: "HH:mm:ss")
                    let endTimeDate = DateManager.shared.getDate(from: slot.endTime ?? "", format: "HH:mm:ss")
                    let startTime = DateManager.shared.getString(from: startTimeDate!, format: "hh:mm aa", needsZone:  false)
                    let endTime = DateManager.shared.getString(from: endTimeDate!, format: "hh:mm aa", needsZone: false)
                    
                    if DateManager.shared.getDate(from: date, format: Constants.availibilitesDateFormat, needsZone: false) == DateManager.shared.getDate(from: self.today, format: Constants.availibilitesDateFormat, needsZone: false) {
                        
                        let thisSlotDateTime = DateManager.shared.getDate(from: "\(date) \(startTime)", format: Constants.availabilitiesComparisonFormat, needsZone: false)
                        let now = DateManager.shared.getDate(from: "\(self.today) \(DateManager.shared.getString(from: Date(), format: "hh:mm aa"))", format: Constants.availabilitiesComparisonFormat, needsZone: false)
                        if now < thisSlotDateTime {
                            self.selectableTimeSlots.append(CustomerWeekDays(weekDay: "\(startTime) - \(endTime)", isSelected: false, timeSlot: slot))
                        }
                    } else {
                        self.selectableTimeSlots.append(CustomerWeekDays(weekDay: "\(startTime) - \(endTime)", isSelected: false, timeSlot: slot))
                    }
                }

                self.collectionView.reloadData()
            }
        }
        (self.viewModel as! CustomerSelectDateTimeViewModel).setBarberTimeSlotError = { [weak self] error in
            //MARK: TODO
//            self.routeBack(navigation: .pop)
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
        daysOutSwitch.isOn = true
    }
    
    func setButton() {
        self.doneBtn.buttonColor = .orange
        self.doneBtn.setText(text: "Done")
        self.doneBtn.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            if self.selectedSlot != nil {
                self.timeSlotSelectionCallback?(self.selectedSlot, self.date)
                self.routeBack(navigation: .pop)
            } else {
                self.viewModel.showPopup = "Time slot is required"
            }
        })
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, title: "Select Date & Time", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
    }
    
    func setDelegates() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: "BarberTimeSlotCell", bundle: nil), forCellWithReuseIdentifier: "BarberTimeSlotCell")
        
        self.collectionView.register(UINib(nibName: "NoDataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NoDataCollectionViewCell")
        
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        
        // Appearance delegate [Unnecessary]
        self.calendarView.calendarAppearanceDelegate = self
        
        // Animator delegate [Unnecessary]
        self.calendarView.animatorDelegate = self
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        
        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
    }
}

extension CustomerSelectDateTimeView : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionViewHeight.constant = 262
        if selectableTimeSlots.count == 0 {
            return 1
        } else {
            collectionViewHeight.constant = 150
            return selectableTimeSlots.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectableTimeSlots.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoDataCollectionViewCell", for: indexPath) as! NoDataCollectionViewCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarberTimeSlotCell", for: indexPath) as! BarberTimeSlotCell
        let data = selectableTimeSlots[indexPath.row]
        
        cell.timeSlotLabel.text = data.weekDay
        cell.topConstraint.constant = 0
        cell.bottomConstraint.constant = 0
        cell.timeSlotLabel.font = cell.timeSlotLabel.font.withSize(CGFloat(14))
        if data.isSelected {
            cell.bgView.backgroundColor = Theme.appOrangeColor
            cell.timeSlotLabel.textColor = .white
            cell.bgView.layer.borderColor = Theme.appOrangeColor.cgColor
        } else {
            cell.bgView.backgroundColor = .white
            cell.bgView.layer.borderColor = Theme.appNavigationBlueColor.cgColor
            cell.timeSlotLabel.textColor = Theme.appNavigationBlueColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.selectableTimeSlots.count != 0 {
            for i in 0..<selectableTimeSlots.count {
                selectableTimeSlots[i].isSelected = false
            }
            selectableTimeSlots[indexPath.row].isSelected = true
            selectedSlot = selectableTimeSlots[indexPath.row].timeSlot
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if selectableTimeSlots.count == 0 {
            return CGSize(width: 414, height: 262)
        }
        return CGSize(width: (collectionView.frame.width - 10) / 2, height: 35)
    }
}


extension CustomerSelectDateTimeView: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    // MARK: Required methods
    
    func presentationMode() -> CalendarMode { return .monthView }
    
    func firstWeekday() -> Weekday { return .sunday }
    
    // MARK: Optional methods
    
    func calendar() -> Calendar? { return currentCalendar }
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return .black
    }
    
//    func shouldShowWeekdaysOut() -> Bool { return shouldShowDaysOut }
    
    // Defaults to true
    func shouldAnimateResizing() -> Bool { return true }
    
    private func shouldSelectDayView(dayView: DayView) -> Bool {
        return false
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool { return shouldAutoSelect }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        shouldAutoSelect = false
        selectedSlot = nil
        date = DateManager.shared.getString(from: dayView.date.convertedDate() ?? Date(), format: Constants.availibilitesDateFormat)
        getSlots()
        selectedDay = dayView
    }
    
    func didShowNextMonthView(_ date: Date) {
        let dateA = DateManager.shared.getDate(from: self.date, format: Constants.dateFormat) ?? Date()
        if dateA.month == date.month && dateA.year == date.year {
            shouldAutoSelect = true
            self.calendarView.didSelectDayView(selectedDay)
            self.calendarView.contentController.presentedMonthView.calendarView.didSelectDayView(selectedDay)
        } else {
            shouldAutoSelect = false
        }
    }
    
    func didShowPreviousMonthView(_ date: Date) {
        let dateA = DateManager.shared.getDate(from: self.date, format: Constants.dateFormat) ?? Date()
        if dateA.month == date.month && dateA.year == date.year {
            shouldAutoSelect = true
            self.calendarView.didSelectDayView(selectedDay)
            self.calendarView.contentController.presentedMonthView.calendarView.didSelectDayView(selectedDay)
        } else {
            shouldAutoSelect = false
        }
    }
    
    func setCurrentDay() {
        updateCalendar()
        let newDate = DateManager.shared.getDate(from: date, format: Constants.availibilitesDateFormat, needsZone: true) ?? Date()
        calendarView.toggleViewWithDate(newDate)
        presentedDateUpdated(CVDate(date: newDate))
        updateCalendar()
    }
    
    
    func shouldSelectRange() -> Bool { return false }
    
    func didSelectRange(from startDayView: DayView, to endDayView: DayView) {
        print("RANGE SELECTED: \(startDayView.date.commonDescription) to \(endDayView.date.commonDescription)")
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            updatedMonthLabel.alpha = 0
            self.monthLabel.frame = updatedMonthLabel.frame
            self.monthLabel.text = updatedMonthLabel.text
            self.monthLabel.alpha = 1
            updatedMonthLabel.removeFromSuperview()
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool { return false }
    
    func shouldHideTopMarkerOnPresentedView() -> Bool {
        return true
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType { return .short }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool { return false }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        //        circleView.fillColor = .colorFromCode(0xCCCCCC)
        circleView.fillColor = .red

        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
//        if (dayView.isCurrentDay) {
//            return true
//        }
        return false
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        
        dayView.setNeedsLayout()
        dayView.layoutIfNeeded()
        
        let π = Double.pi
        
        let ringLayer = CAShapeLayer()
        let ringLineWidth: CGFloat = 4.0
        let ringLineColour = UIColor.blue
        
        let newView = UIView(frame: dayView.frame)
        
        let diameter = (min(newView.bounds.width, newView.bounds.height))
        let radius = diameter / 2.0 - ringLineWidth
        
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.cgColor
        
        let centrePoint = CGPoint(x: newView.bounds.width/2.0, y: newView.bounds.height/2.0)
        let startAngle = CGFloat(-π/2.0)
        let endAngle = CGFloat(π * 2.0) + startAngle
        let ringPath = UIBezierPath(arcCenter: centrePoint,
                                    radius: radius,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: true)
        
        ringLayer.path = ringPath.cgPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        guard let currentCalendar = currentCalendar else { return false }
        
        let components = Manager.componentsForDate(Foundation.Date(), calendar: currentCalendar)
        
        /* For consistency, always show supplementaryView on the 3rd, 13th and 23rd of the current month/year.  This is to check that these expected calendar days are "circled". There was a bug that was circling the wrong dates. A fix was put in for #408 #411.
         
         Other month and years show random days being circled as was done previously in the Demo code.
         */
        var shouldDisplay = false
        if dayView.date.year == components.year &&
            dayView.date.month == components.month {
            
            if (dayView.date.day == 3 || dayView.date.day == 13 || dayView.date.day == 23)  {
                print("Circle should appear on " + dayView.date.commonDescription)
                shouldDisplay = true
            }
        } else if (Int(arc4random_uniform(3)) == 1) {
            shouldDisplay = true
        }
        
        return shouldDisplay
    }
    
    func dayOfWeekTextColor() -> UIColor { return .black }
    
    func dayOfWeekBackGroundColor() -> UIColor { return UIColor(hex: "#F1F7FE") }
    
    func disableScrollingBeforeDate() -> Date { return Date() }
    
    func disableScrollingBeyondDate() -> Date {
        var dayComponents = DateComponents()
        dayComponents.year = 1
        let calendar = Calendar(identifier: .gregorian)
        if let lastDate = calendar.date(byAdding: dayComponents, to: Date()) {
            return lastDate
        }
        return Date()
    }
    func maxSelectableRange() -> Int { return 14 }
    
    func earliestSelectableDate() -> Date {
        return DateManager.shared.getDate(from: today, format: Constants.availibilitesDateFormat, needsZone: true) ?? Date()
    }
    
    func latestSelectableDate() -> Date {
        var dayComponents = DateComponents()
        dayComponents.year = 1
        let calendar = Calendar(identifier: .gregorian)
        if let lastDate = calendar.date(byAdding: dayComponents, to: Date()) {
            return lastDate
        }
        return Date()
    }
}


// MARK: - CVCalendarViewAppearanceDelegate

extension CustomerSelectDateTimeView: CVCalendarViewAppearanceDelegate {
    
    func dayLabelWeekdayDisabledColor() -> UIColor { return .lightGray }
    
    func dayLabelPresentWeekdayInitallyBold() -> Bool { return true }
    
    func spaceBetweenDayViews() -> CGFloat { return 0 }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return Theme.getAppFont(withSize: 14) }
    
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .selected, _), (_, .highlighted, _):
            return ColorsConfig.selectedText
        case (.sunday, .in, _):
            return ColorsConfig.sundayText
        case (.sunday, _, _):
            return ColorsConfig.sundayTextDisabled
        case (_, .in, _):
            return ColorsConfig.text
        default:
            return ColorsConfig.textDisabled
        }
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        //        switch (weekDay, status, present) {
        //        case (.sunday, .selected, _), (.sunday, .highlighted, _): return ColorsConfig.sundaySelectionBackground
        //        case (_, .selected, _), (_, .highlighted, _): return ColorsConfig.selectionBackground
        //        default: return
        return Theme.appNavigationBlueColor
    }
    
}

struct ColorsConfig {
    static let selectedText = UIColor.white
    static let text = UIColor.black
    static let textDisabled = UIColor.gray
    static let selectionBackground = UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0)
    static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
    static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
    static let sundaySelectionBackground = sundayText
}
struct CustomerWeekDays {
    var weekDay : String
    var isSelected : Bool
    var timeSlot: TimeSlot
}
