//
//  BaseTableView.swift
//  Event Social
//
//  Created by Mohammad Zawwar on 11/03/2020.
//  Copyright © 2020 Faizan. All rights reserved.
//

import UIKit
import Helpers
import CommonComponents
class BaseTableView: UITableViewController {

     var viewModel: BaseViewModel = BaseViewModel()
        {
            didSet {
                self.commonInit()
            }
        }
        //private var networkAdapter : NetworkChangeNotifiable = NetworkChangeClass()
        func commonInit() {
            
            self.bindWithLoaderStatus()
            self.bindWithToastStatus()
            self.bindWithFailureResponse()
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            
        }
        private func bindWithToastStatus() {
            viewModel.setFailureMessage = {
                (message) in
                DispatchQueue.main.async {
                    // ToastView.getInstance().showToast(inView: self.view, textToShow: message)
                     Helper.getInstance.showAlert(title: "Error", message: message)
                }
               
                
            }
        }
        private func bindWithLoaderStatus() {
            viewModel.setLoading = { (isLoading) in
                if isLoading {
                    DispatchQueue.main.async {
                        Loader.getInstance().showLoader()
                    }
                } else {
                    DispatchQueue.main.async {
                        Loader.getInstance().hideLoader()
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
