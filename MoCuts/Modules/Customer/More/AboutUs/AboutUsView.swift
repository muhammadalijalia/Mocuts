//
//  AboutUsView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 27/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import WebKit

class AboutUsView: BaseView, Routeable {
    
    @IBOutlet weak var webView : WKWebView!
    var htmlPage = ""
    var screenType: Constants.PageType = .about
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        viewModel = PagesViewModel()
        
        setupViewModelObserver()
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            WebCacheCleaner.clean()
        }
    }
    
    func setupViewModelObserver() {
        (viewModel as! PagesViewModel).onSuccess = { [weak self] response in
            guard let self = self else {
                return
            }
            self.htmlPage = response.content ?? ""
            if self.htmlPage == "" {
                self.viewModel.isLoading = false
            } else {
                self.loadPage()
            }
        }
        
        (viewModel as! PagesViewModel).onFailure = { [weak self] error in
            guard let self = self else {
                return
            }
            self.viewModel.isLoading = false
            self.routeBack(navigation: .pop)
        }
    }
    
    func loadData() {
        switch screenType {
        case .about:
            (viewModel as! PagesViewModel).getPageData(endPoint: .aboutUs)
        case .pp:
            (viewModel as! PagesViewModel).getPageData(endPoint: .privacyPolicy)
        case .tc:
            (viewModel as! PagesViewModel).getPageData(endPoint: .termsAndConditions)
        }
    }
    
    func loadPage() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.viewModel.isLoading = true
            self.webView.loadHTMLString(self.htmlPage, baseURL: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setView()
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        let backButtonImage = UIImage(named: "backButton")
        
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            var screenTitle = "About Us"
            switch screenType {
            case .about:
                screenTitle = "About Us"
            case .pp:
                screenTitle = "Privacy Policy"
            case .tc:
                screenTitle = "Terms & Conditions"
            }
            
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, title: screenTitle, isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
    }
}

extension AboutUsView : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.isLoading = false
        webView.navigationDelegate = nil
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        viewModel.isLoading = false
        webView.navigationDelegate = nil
    }
}

final class WebCacheCleaner {
    
    class func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("[WebCacheCleaner] All cookies deleted")
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: {
            // All done!
          })
        }
    }
}
