//
//  ConnectStripeWebView.swift
//  MoCuts
//
//  Created by Ahmed Khan on 04/11/2021.
//

import WebKit
import UIKit
import CommonComponents
import Helpers

protocol ConnectStripeWebViewDelegate {
    func paypalConnect(token: String)
}

class ConnectStripeWebView: BaseView, WKScriptMessageHandler {

    var webView: WKWebView!
    var stripeOnboardingUrl = ""
    var successCallback: (() -> Void)?
    let onFailure = "failureHandler"
    let onSuccess = "successHandler"
    
    var delegate: ConnectStripeWebViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewModel = BaseViewModel()
        viewModel.isLoading = true
        setupWebView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigation()
    }
    
    func setupWebView() {
        let config: WKWebViewConfiguration = WKWebViewConfiguration()
        // Adding a script message handler
        config.userContentController.add(self, name: onSuccess)
        config.userContentController.add(self, name: onFailure)
        
        webView = WKWebView(frame: self.view.frame, configuration: config)
        
        webView.configuration.preferences.javaScriptEnabled = true
        let customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
        webView.customUserAgent = customUserAgent
        webView.allowsLinkPreview = false
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        self.view.addSubview(webView)
        webView.load(URLRequest(url: URL(string: stripeOnboardingUrl)!))
    }
    
    func setupNavigation() {
        let backButtonImage = UIImage(named: "backButton")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: nil, title: "PayPal Connect", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
    }
}

extension ConnectStripeWebView : WKNavigationDelegate, WKUIDelegate{
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("button name: \(message.name)")
        print("Message Body: \(message.body)")
        if let dictionary = message.body as? [String: Any],
           let idToken = dictionary["id_token"] as? String {
            // Now, 'idToken' contains the value of the 'id_token' key
            print("idToken: \(idToken)")
            self.delegate?.paypalConnect(token: idToken)
        }
        
        if message.name == onSuccess {
            self.successCallback?()
        }
        webView.navigationDelegate = nil
        BackButtonTapped()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.isLoading = false
        let contentSize = webView.scrollView.contentSize
        let viewSize = webView.bounds.size
        let rw = viewSize.width / contentSize.width

        webView.scrollView.minimumZoomScale = rw
        webView.scrollView.maximumZoomScale = rw
        webView.scrollView.zoomScale = rw
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("WebView did fail with error: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            print("Navigating to: \(url)")
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let url = navigationAction.request.url {
            // Open new windows or tabs as needed
            let newWebView = WKWebView(frame: webView.frame, configuration: configuration)
            newWebView.navigationDelegate = self
            view.addSubview(newWebView)
            newWebView.load(URLRequest(url: url))
            return newWebView
        }
        return nil
    }
}

