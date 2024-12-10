//
//  DeleteAccountViewController.swift
//  PoshOnTheGo
//
//  Created by Ahmed on 20/02/2023.
//

import UIKit
import Helpers
import CommonComponents

class DeleteAccountViewController: BaseView, Routeable {
    @IBOutlet weak var submitBtn: MoCutsAppButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setupTableView()
        setupViewModel()
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: nil, title: "Delete Account", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
        submitBtn.buttonColor = .orange
        submitBtn.setText(text: "Delete Account")
        submitBtn.setAction(actionP: {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard !self.viewModel.isLoading else { return }
                (self.viewModel as! DeleteAccountViewModel).deleteAccount()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupViewModel() {
        viewModel = DeleteAccountViewModel(delegate: self)
    }
}

extension DeleteAccountViewController {
    func setupTableView() {
        self.tableView.register(UINib(nibName: "DeleteAccountReasonCell", bundle: nil), forCellReuseIdentifier: "DeleteAccountReasonCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
}

// MARK: - UITableViewDelegate
extension DeleteAccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

// MARK: - UITableViewDataSource
extension DeleteAccountViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel as! DeleteAccountViewModel).deleteReasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteAccountReasonCell", for: indexPath) as? DeleteAccountReasonCell else { return UITableViewCell() }
        guard (viewModel as! DeleteAccountViewModel).deleteReasons.indices.contains(indexPath.row) else { return cell }
        var isSelected = false
        if let reasonId = (viewModel as! DeleteAccountViewModel).reasonId {
            isSelected = (viewModel as! DeleteAccountViewModel).deleteReasons[indexPath.row].value == reasonId
        }
        cell.configureCell(title: (viewModel as! DeleteAccountViewModel).deleteReasons[indexPath.row].text ?? "", isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard (self.viewModel as! DeleteAccountViewModel).deleteReasons.indices.contains(indexPath.row) else { return }
            var wasSelected = false
            if let reasonId = (self.viewModel as! DeleteAccountViewModel).reasonId {
                wasSelected = (self.viewModel as! DeleteAccountViewModel).deleteReasons[indexPath.row].value == reasonId
            }
            if wasSelected {
                (self.viewModel as! DeleteAccountViewModel).reasonId = nil
            } else {
                (self.viewModel as! DeleteAccountViewModel).reasonId = (self.viewModel as! DeleteAccountViewModel).deleteReasons[indexPath.row].value
            }
            self.tableView.reloadData()
        }
    }
}

extension DeleteAccountViewController: DeleteAccountViewModelProtocol {
    func onSuccess() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UserPreferences.clearPreference()
            let sgVc : GetStartedView
            = AppRouter.instantiateViewController(storyboard: .authentication)
            let nvc = UINavigationController(rootViewController: sgVc)
            Helper.getInstance.makeSpecificViewRoot(vc: nvc)
        }
    }
    
    func onSuccessReasons() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func onFailure(error: String) {
        
    }
}
