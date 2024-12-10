//
//  BaseView.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 12/07/2019.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import UIKit
import Helpers
import CommonComponents

class BaseView: UIViewController {
    
    var viewModel: BaseViewModel = BaseViewModel()
    {
        didSet {
            self.commonInit()
        }
    }
    
    private var networkAdapter : NetworkChangeNotifiable = NetworkChangeClass()
    
    func commonInit() {
        self.bindWithLoaderStatus()
        self.bindWithToastStatus()
        self.bindWithFailureResponse()
        self.bindWithShowPopupStatus()
        self.bindWithShowSuccessPopupStatus()
    }
    
    weak var noDataViewTV: NoDataTableViewBackground?
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    func toggleWhiteView(toggle: Bool) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleWhiteView"), object: nil, userInfo: ["toggle": toggle])
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    private func bindWithToastStatus() {
        viewModel.setFailureMessage = { [weak self]
            (message) in
            
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                ToastView.getInstance().showToast(inView: self.view, textToShow: message,backgroundColor: Theme.appOrangeColor)
            }
        }
    }
    
    private func bindWithLoaderStatus() {
        viewModel.setLoading = { (isLoading) in
            if isLoading {
                DispatchQueue.main.async {
                    ProgressHUD.animationType = .circleStrokeSpin
                    ProgressHUD.show(nil, interaction: false)
                }
            } else {
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                }
            }
        }
    }
    
    func showNoDataLabelOnTableView(tableView: UITableView, customText: String = "No data available", image: String = "BarberShop") {

        if noDataViewTV == nil {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.noDataViewTV = ((NoDataTableViewBackground.loadWithNib("\(NoDataTableViewBackground.self)", viewIndex: 0, owner: NoDataTableViewBackground.self) as! UIView) as! NoDataTableViewBackground)
                
                self.noDataViewTV?.noDataText = customText
                self.noDataViewTV?.noDataImage = image
                let bgView = UIView(frame: tableView.frame)
                bgView.addSubview(self.noDataViewTV!)
                tableView.backgroundView = bgView
                var center = tableView.center
                center.y = center.y - tableView.frame.minY
                bgView.center = center
                self.noDataViewTV?.center = center
                tableView.backgroundView?.setNeedsLayout()
                tableView.backgroundView?.layoutIfNeeded()
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.noDataViewTV?.noDataText = customText
                self.noDataViewTV?.noDataImage = image
                self.noDataViewTV?.alpha = 1
            }
        }
        tableView.separatorStyle  = .none
    }
    
    func removeNoDataLabelOnTableView(tableView: UITableView)
    {
        if noDataViewTV != nil {
            noDataViewTV?.alpha = 0
        }
    }
    
    
    private func bindWithShowPopupStatus() {
        viewModel.setErrorPopup = { [weak self] (showPopup) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                let vc : StatusPopupView = AppRouter.instantiateViewController(storyboard: .authentication)
                vc.status = false
                vc.errorMessage = showPopup
                vc.providesPresentationContextTransitionStyle = true
                vc.definesPresentationContext = true
                vc.modalPresentationStyle = .overCurrentContext;
                vc.view.backgroundColor = UIColor( red: 0, green: 0, blue: 0, alpha: 0.0)
                self.present(vc, animated: true) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func bindWithShowSuccessPopupStatus() {
        viewModel.setSuccessPopup = { [weak self] (showPopup) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                let vc : StatusPopupView = AppRouter.instantiateViewController(storyboard: .authentication)
                vc.status = true
                vc.errorMessage = showPopup
                vc.providesPresentationContextTransitionStyle = true
                vc.definesPresentationContext = true
                vc.modalPresentationStyle = .overCurrentContext;
                vc.view.backgroundColor = UIColor( red: 0, green: 0, blue: 0, alpha: 0.0)
                self.present(vc, animated: true) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func bindWithFailureResponse() {
        viewModel.setToastView = { (message) in
            Helper.getInstance.showAlert(title: "Error", message: message)
        }
    }
}
