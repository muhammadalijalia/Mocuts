//
//  ServiceHistoryView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 05/08/2021.
//

import UIKit
import Helpers
import CommonComponents
import MonthYearPicker
import IQKeyboardManagerSwift

class ServiceHistoryView: BaseView, Routeable {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchView : UIView!
    @IBOutlet weak var searchField : UITextField!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var filterTextfield: UITextField!
    @IBOutlet weak var allTimeHistory: UILabel!
    @IBOutlet weak var historyHeading: UILabel!
    @IBOutlet weak var clearFilterBtn: UIButton!
    private var page = 1
    private var total = 0
    var monthYearPickerView: MonthYearPickerView?
    var filteredMonth : Date?
    var refreshControl: UIRefreshControl!
    private var jobsArray: [BarberBaseModel] = [BarberBaseModel]()
    private var userId: Int?
    var params = ServiceHistoryParams()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = ServiceHistoryViewModel()
        userId = UserPreferences.userModel?.id ?? 0
        setupRefreshLayout()
        setJobsLists()
        setTableView()
    }
    
    @IBAction func clearFilter(btn: UIButton) {
        clearFilterBtn.isHidden = true
        monthYearPickerView?.date = Date()
        filteredMonth = nil
        searchTextfield.text = ""
        filterTextfield.text = ""
        params.month = ""
        params.year = ""
        params.status = "30"
        params.query = ""
        params.isFiltered = 0
        
        clearData()
        self.historyHeading.text = "All Time History"
        self.getDataFromVM()
    }
    
    func clearData() {
        jobsArray.removeAll()
        tableView.reloadData()
        page = 1
        total = 0
        self.allTimeHistory.text = "(0)"
    }
    
    func setupRefreshLayout() {
        refreshControl = UIRefreshControl()

        refreshControl.addTarget(self, action:
                                    #selector(handleRefreshControl),
                                    for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    @objc func handleRefreshControl() {
        clearData()
        getDataFromVM()
    }
    
    func getDataFromVM(offset: Int = 1) {
        DispatchQueue.main.async {
            self.removeNoDataLabelOnTableView(tableView: self.tableView)
        }
        params.query = searchTextfield.text ?? ""
        if let selectedDate = self.filteredMonth {
            let components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
            if let month = components.month, let year = components.year {
                params.month = String(month)
                params.year = String(year)
                params.page = offset
            }
        } else {
            params.month = ""
            params.year = ""
            params.page = offset
        }
        (viewModel as! ServiceHistoryViewModel).getServiceCompletedJobs(userId: "\(self.userId ?? 0)", month: params.month, year: params.year, query: params.query, status: params.status, offset: params.page, isFiltered: params.isFiltered)
    }
    
    func setJobsLists() {
        (viewModel as! ServiceHistoryViewModel).setJobsRoute = { [weak self] jobModel in
            
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.page = jobModel.page ?? 1
                self.total = jobModel.total ?? 0
                if self.page == 1 {
                    self.jobsArray = jobModel.data ?? []
                } else {
                    self.jobsArray.append(contentsOf: jobModel.data ?? [])
                }
                self.allTimeHistory.text = "(\(String(jobModel.total ?? 0)))"
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        (viewModel as! ServiceHistoryViewModel).setFailureRoute = { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setView()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.removeNoDataLabelOnTableView(tableView: self.tableView)
            self.getDataFromVM()
        }
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: false)
        self.tabBarController?.tabBar.isTranslucent = true
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            let rightBarImage = UIBarButtonItem(image: UIImage(named: "filterWhite"), style: .plain, target: self, action: #selector(filterBtn))
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: rightBarImage, title: "Services History", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
        
        searchView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        searchView.layer.shadowOpacity = 1
        searchView.layer.shadowOffset = .zero
        searchView.layer.shadowRadius = 5
        
        searchField.delegate = self
        
        searchView.layer.cornerRadius = 5
        calendarView.layer.cornerRadius = 5
        filterTextfield.delegate = self
        configureMonthYearPicker()
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ServiceHistoryCell", bundle: nil), forCellReuseIdentifier: "ServiceHistoryCell")
        tableView.separatorStyle = .none
    }
    
    func configureMonthYearPicker(){
            let size = CGSize(width: view.bounds.width, height: 216)
            let y = (view.bounds.height - 216) / 2
            let origin = CGPoint(x: 0, y: y)
            let frame = CGRect(origin: origin, size: size)
            monthYearPickerView = MonthYearPickerView(frame: frame)
            monthYearPickerView?.minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
            monthYearPickerView?.maximumDate = Date()
            if #available(iOS 13.4, *) {
    //            monthYearPickerView?.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            filterTextfield.inputView = monthYearPickerView
            monthYearPickerView?.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        }
    
    @objc func dateChanged(_ picker: MonthYearPickerView) {
        filteredMonth = picker.date
        historyHeading.text = "\(Utilities.shared.getMonthInLetters(month: picker.date.month)), \(picker.date.year)"
    }
    
    func applyStatusFilter(status: String) {
        params.status = status
        params.isFiltered = 1
        clearFilterBtn.isHidden = false
        getDataFromVM()
    }
    
    @objc func filterBtn() {
    
        let attributedString = NSAttributedString(string: "Apply Filter", attributes: [
            NSAttributedString.Key.font : Theme.getAppMediumFont(withSize: 18),
            NSAttributedString.Key.foregroundColor : UIColor.black
        ])
        
        let alert = UIAlertController(title: "Filter", message: nil, preferredStyle: .actionSheet)
        
        let subview = alert.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertContentView.layer.cornerRadius = 15
        alert.view.tintColor = Theme.appOrangeColor
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Completed", style: .default, handler: { _ in
            self.applyStatusFilter(status: "30")
        }))
        alert.addAction(UIAlertAction(title: "Barber Cancelled", style: .default, handler: { _ in
            self.applyStatusFilter(status: "20")
        }))
        alert.addAction(UIAlertAction(title: "You Cancelled", style: .default, handler: { _ in
            self.applyStatusFilter(status: "25")
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ServiceHistoryView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if jobsArray.count == 0 && !viewModel.isLoading {
            showNoDataLabelOnTableView(tableView: tableView, customText: "Oops!\nNo service history found!", image: "service")
        } else {
            removeNoDataLabelOnTableView(tableView: tableView)
        }
        return self.jobsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceHistoryCell", for: indexPath) as! ServiceHistoryCell
        cell.bgView.backgroundColor = UIColor(hex: "#EDF8FF")
        cell.shopName.text = jobsArray[indexPath.row].barber?.name
        cell.statusBtn.setImage(nil, for: .normal)
        let statusTitle = getStatus(with: jobsArray[indexPath.row].status ?? 30)
        cell.statusBtn.setTitle("   \(statusTitle)   ", for: .normal)
        cell.serviceName.text = "Services: \(jobsArray[indexPath.row].job_services?.first?.service?.name ?? "")"
        
        cell.dateTime.text = "\(jobsArray[indexPath.row].date?.changeFormat(fromFormat: "yyyy-MM-dd", toFormat: "MM/dd/yyyy") ?? "") - \(jobsArray[indexPath.row].availability?.start_time?.changeFormat(fromFormat: "HH:mm:ss", toFormat: "hh:mm a") ?? "") - \(jobsArray[indexPath.row].availability?.end_time?.changeFormat(fromFormat: "HH:mm:ss", toFormat: "hh:mm a") ?? "")"
         
        cell.shopImage?.sd_setImage(with: URL(string: jobsArray[indexPath.row].barber?.image_url ?? ""), completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : ServiceHistoryDetailView = AppRouter.instantiateViewController(storyboard: .more)
        vc.jobDetails = jobsArray[indexPath.row]

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.route(to: vc, navigation: .push)
        })
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == jobsArray.count - 1 {
            if jobsArray.count < total {
                getDataFromVM(offset: page + 1)
            }
        }
    }
}

extension ServiceHistoryView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextfield {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.canBeConverted(to: String.Encoding.ascii){
             return false
        }
        let maxLength = 50
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.accessibilityIdentifier == "datePicker" {
            if let picker = monthYearPickerView {
                historyHeading.text = "\(Utilities.shared.getMonthInLetters(month: picker.date.month)), \(picker.date.year)"
            }
            clearFilterBtn.isHidden = false
            getDataFromVM()
        } else {
            clearFilterBtn.isHidden = false
            getDataFromVM()
        }
    }
}

extension ServiceHistoryView {
    func getStatus(with statusCode:Int) -> String {
        switch statusCode {
        case 5:
            return "Requested"
        case 6:
            return "Rejected"
        case 10:
            return "Accepted"
        case 11:
            return "On the Way"
        case 15:
            return "Arrived"
        case 16:
            return "Unserved"
        case 20, 25:
            return "Cancelled"
        case 26, 30, 35, 40:
            return "Completed"
        default:
            return "Unknown"
        }
    }
}
