//
//  BarberWithdrawalHistoryView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 17/08/2021.
//

import Foundation
import UIKit
import Helpers
import MonthYearPicker
import CommonComponents
import IQKeyboardManagerSwift

class BarberWithdrawalHistoryView : BaseView, Routeable {
    
    @IBOutlet weak var creditLimitView : UIView!
    @IBOutlet weak var profileDetailView : UIView!
    @IBOutlet weak var filterTextfield: UITextField!
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var barberNameLabel: UILabel!
    @IBOutlet weak var barberAddressLabel: UILabel!
    @IBOutlet weak var availableCreditLabel: UILabel!
    @IBOutlet weak var monthlyEarningLabel: UILabel!
    @IBOutlet weak var allTimeEarningLabel: UILabel!
    @IBOutlet weak var monthlyEarningHeaderLabel: UILabel!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var tableViewHeightLayout : NSLayoutConstraint!
    
    var monthYearPickerView: MonthYearPickerView?
    var withdrawals = [WithdrawalModel]()
    var filteredMonth = Date()
    var hasLoaded = false
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BarberWithdrawalHistoryViewModel()
        
        setProfileData()
        setView()
        setupViewModel()
        configureMonthYearPicker()
        DispatchQueue.main.async {
            (self.viewModel as! BarberWithdrawalHistoryViewModel).getBarberProfile()
            (self.viewModel as! BarberWithdrawalHistoryViewModel).getWithdrawals()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateTableViewHeight()
    }
    
    deinit {
        print("withdrawal history deinited")
    }
    
    @objc func viewAll() {
        let vc : BarberWithdrawalCompleteHistoryView = AppRouter.instantiateViewController(storyboard: .Barberwallet)
        let month = monthYearPickerView?.date.month ?? Date().month
        let year = monthYearPickerView?.date.year ?? Date().year
        vc.month = String(month)
        vc.year = String(year)
        vc.titleText = "Withdrawal History (\(Utilities.shared.getMonthInLetters(month: month)), \(String(year))) (\(String(total)))"
        self.route(to: vc, navigation: .push)
    }
    
    func setProfileData() {
        profileImageView.sd_setImage(with: URL(string: UserPreferences.userModel?.image_url ?? ""), completed: nil)
        barberNameLabel.text = UserPreferences.userModel?.name
        barberAddressLabel.text = UserPreferences.userModel?.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
        setMonthlyWithdrawal()
    }
    
    func setMonthlyWithdrawal() {
        DispatchQueue.main.async {
            let dateString = DateManager.shared.getString(from: self.monthYearPickerView?.date ?? Date(), format: Constants.withdrawalDateFormat)
            self.monthlyEarningHeaderLabel.text = "\(dateString) Withdrawal"
        }
        
    }
    
    //MARK: Withdrawals Response
    func setupViewModel() {
        (self.viewModel as! BarberWithdrawalHistoryViewModel).setWithdrawalsData = { [weak self] withdrawalsResponse in
            guard let self = self else {
                return
            }
            self.total = withdrawalsResponse.total ?? 0
            self.withdrawals = withdrawalsResponse.data ?? [WithdrawalModel]()
            self.setMonthlyWithdrawal()
            DispatchQueue.main.async {
                self.monthlyEarningLabel.text = String(format: "%.1f", Double(withdrawalsResponse.currentMonthWithdraw ?? 0)) + " $"
                
                self.allTimeEarningLabel.text = String(format: "%.1f", Double(withdrawalsResponse.allTimeWithdraw ?? 0)) + " $"
                self.tableView.reloadData()
                self.calculateTableViewHeight()
            }
        }
        
        (self.viewModel as! BarberWithdrawalHistoryViewModel).setBarberProfileData = {
            [weak self] barberData in
            
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.availableCreditLabel.text = String(format: "%.2f", (barberData?.wallet_amount ?? 0)) + " $"
            }
        }
    }
    
    func configureMonthYearPicker() {
        let size = CGSize(width: view.bounds.width, height: 216)
        let y = (view.bounds.height - 216) / 2
        let origin = CGPoint(x: 0, y: y)
        let frame = CGRect(origin: origin, size: size)
        monthYearPickerView = MonthYearPickerView(frame: frame)
        monthYearPickerView?.minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        monthYearPickerView?.maximumDate = Date()
        monthYearPickerView?.date = Date()

        monthYearPickerView?.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()
        let flexibleBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))

        toolBar.setItems([flexibleBtn, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        filterTextfield.inputAccessoryView = toolBar
        filterTextfield.inputView = monthYearPickerView
        }
    
    @objc func donePicker() {
        filteredMonth = monthYearPickerView?.date ?? Date()
        filterTextfield.resignFirstResponder()
        
        let components = Calendar.current.dateComponents([.year, .month], from: self.filteredMonth)
        if let month = components.month, let year = components.year {
            clearData()
            (self.viewModel as! BarberWithdrawalHistoryViewModel).getWithdrawals(offset: 1, year: String(year), month: String(month))
        }
    }
    func clearData() {
        withdrawals.removeAll()
        tableView.reloadData()
    }
    
    @objc func dateChanged(_ picker: MonthYearPickerView) {
        filteredMonth = picker.date
    }
    
    func calculateTableViewHeight() {
        var totalCellHeight = withdrawals.count * 80
        if totalCellHeight == 0 {
            totalCellHeight = 262
        }
        let totalSectionHeaderHeight = 50
        let tableViewHeight = totalCellHeight + totalSectionHeaderHeight
        tableViewHeightLayout.constant = CGFloat(tableViewHeight)
    }
    
    func setView() {
        scrollView.bounces = false
        tableView.bounces = false
        scrollView.delegate = self
        IQKeyboardManager.shared.enable = true
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backButtonImage = UIImage(named: "backButton")
        let calendarIcon = UIImage(named: "calendarIcon")
        let rightBarBtn = UIBarButtonItem(image: calendarIcon, style: .plain, target: self, action: #selector(calendarTapped))
        
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: rightBarBtn, title: "Withdrawal History", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
        
        creditLimitView.layer.cornerRadius = 8
        profileImageView.layer.cornerRadius = 5
        profileDetailView.backgroundColor = Theme.appNavigationBlueColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        tableView.register(UINib(nibName: "BarberWithdrawalHistoryCell", bundle: nil), forCellReuseIdentifier: "BarberWithdrawalHistoryCell")
    }
    
    @objc func calendarTapped() {
        if !filterTextfield.isFirstResponder {
            _ = filterTextfield.becomeFirstResponder()
        }
    }
}

extension BarberWithdrawalHistoryView : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return withdrawals.count == 0 ? 1 : withdrawals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if withdrawals.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
            cell.noDataImage.image = UIImage(named: "PaymentCard")
//            cell.noDataMessage = "Oops!\nNo Withdrawal history found!"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarberWithdrawalHistoryCell", for: indexPath) as! BarberWithdrawalHistoryCell
        let data = withdrawals[indexPath.row]
        let createdDate = data.createdAt ?? ""
        let date = DateManager.shared.getDate(from: createdDate, format: Constants.dateFormat)
        
        cell.withdrawalDate.text = DateManager.shared.getString(from: date!, format: Constants.withdrawalUIDateFormat, needsZone: true)
        cell.withdrawalTime.text = DateManager.shared.getString(from: date!, format: Constants.withdrawalUITimeFormat, needsZone: true)

        cell.withdrawalAmount.text = String(format: "%.1f", Double(data.amount ?? 0)) + " $"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return withdrawals.count == 0 ? 262 : 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
        
        let lblHeader = UILabel.init(frame: CGRect(x: 5, y: 15, width: tableView.bounds.size.width - 10, height: 24))
        lblHeader.font = Theme.getAppMediumFont(withSize: 14)
        lblHeader.textColor = Theme.appOrangeColor
        lblHeader.text = "Withdrawal History (\(Utilities.shared.getMonthInLetters(month: monthYearPickerView?.date.month ?? Date().month)), \(String(monthYearPickerView?.date.year ?? Date().year))) (\(String(total)))"
        lblHeader.sizeToFit()
        
        let viewAllBtn = UIButton(frame: CGRect(x: (tableView.bounds.size.width - 61), y: 13, width: 56, height: 24))
        viewAllBtn.isHidden = self.total < 11
        viewAllBtn.setTitle("View All", for: .normal)
        viewAllBtn.titleLabel?.font = Theme.getAppMediumFont(withSize: 14)
        viewAllBtn.setTitleColor(Theme.appButtonBlueColor, for: .normal)
        viewAllBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewAll)))
        
        headerView.addSubview(lblHeader)
        headerView.addSubview(viewAllBtn)
        
        headerView.backgroundColor = .white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
