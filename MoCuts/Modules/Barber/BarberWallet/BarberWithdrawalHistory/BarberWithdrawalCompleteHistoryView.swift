//
//  BarberWithdrawalCompleteHistoryView.swift
//  MoCuts
//
//  Created by Ahmed Khan on 28/10/2021.
//

import Foundation
import UIKit
import Helpers
import CommonComponents

class BarberWithdrawalCompleteHistoryView : BaseView, Routeable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyTitleLabel: UILabel!
    var refreshControl: UIRefreshControl!
    var page = 1
    var total = 0
    var withdrawals = [WithdrawalModel]()
    var date = Date()
    var titleText = ""
    var year = ""
    var month = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(handleRefreshControl),
                                    for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        setView()
        viewModel = BarberWithdrawalHistoryViewModel()
        setupViewModelObserver()
    }
    
    @objc func handleRefreshControl() {
        withdrawals.removeAll()
        tableView.reloadData()
        getDataFor(pageNo: 1)
    }
    
    func getDataFor(pageNo: Int) {
        DispatchQueue.main.async {
            (self.viewModel as! BarberWithdrawalHistoryViewModel).getWithdrawals(offset: pageNo, year: self.year, month: self.month)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyTitleLabel.text = titleText
        getDataFor(pageNo: page)
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backButtonImage = UIImage(named: "backButton")
        
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: nil, title: "Withdrawal History", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
        tableView.estimatedRowHeight = 80.0
        tableView.register(UINib(nibName: "BarberWithdrawalHistoryCell", bundle: nil), forCellReuseIdentifier: "BarberWithdrawalHistoryCell")
    }
    
    func setupViewModelObserver() {
        (self.viewModel as! BarberWithdrawalHistoryViewModel).setWithdrawalsData = { [weak self] withdrawalsResponse in
            guard let self = self else {
                return
            }
            self.page = withdrawalsResponse.page ?? 1
            self.total = withdrawalsResponse.total ?? 0
            
            if self.page == 1 {
                self.withdrawals = withdrawalsResponse.data ?? [WithdrawalModel]()
            } else {
                self.withdrawals.append(contentsOf: withdrawalsResponse.data ?? [WithdrawalModel]())
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        (self.viewModel as! BarberWithdrawalHistoryViewModel).setFailureRoute = { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension BarberWithdrawalCompleteHistoryView : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return withdrawals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarberWithdrawalHistoryCell", for: indexPath) as! BarberWithdrawalHistoryCell
        let data = withdrawals[indexPath.row]
        
        let createdDate = data.createdAt ?? ""
        let date = DateManager.shared.getDate(from: createdDate, format: Constants.dateFormat)
        
        cell.withdrawalDate.text = DateManager.shared.getString(from: date!, format: Constants.withdrawalUIDateFormat, needsZone: true)
        
        cell.withdrawalTime.text = DateManager.shared.getString(from: date!, format: Constants.withdrawalUITimeFormat, needsZone: true)
        cell.withdrawalAmount.text = String(format: "%.1f", Double(data.amount ?? 0)) + " $"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == withdrawals.count - 1 {
            if withdrawals.count < total {
                getDataFor(pageNo: page + 1)
            }
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
