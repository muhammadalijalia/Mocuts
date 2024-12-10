//
//  AddCardWebView.swift
//  MoCuts
//
//  Created by Farooq Haroon on 21/08/2024.
//

import UIKit
import WebKit
import Helpers

class AddCardWebView: BaseView , Routeable {
    @IBOutlet weak var webViewMain: UIView!
    var amount: Int?
    var webView: WKWebView!
    var onCompleteTransaction: (() -> Void)? = nil
    let onFailure = "failureHandler"
    let onSuccess = "successHandler"
    
    
    @IBAction func actCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AddCardWebViewModel()
        setupWebView()
    }
    
    func setupWebView() {
        guard let amount, let token = UserPreferences.accessToken?.token else {return }
        var url = URL(string: "https://mocuts-backend.tekstagearea.com/checkout-paypal/\(amount)")!
        var request = URLRequest(url: url)
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
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
        self.webViewMain.addSubview(webView)
        webView.load(request)
    }
    
    func dismissTheWebView() {
        DispatchQueue.main.async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {[weak self] in
                guard let self  else { return }
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                    self.onCompleteTransaction?()
                }
                self.routeBack(navigation: .dismiss)
                
            }
        }
    }
    
}
extension AddCardWebView: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "successHandler", "failureHandler":
            self.dismissTheWebView()
        default:
            break
        }
        webView.navigationDelegate = nil
    }
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("WebView did fail with error: \(error.localizedDescription)")
    }
    // MARK: - WKUIDelegate methods
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("JavaScript alert: \(message)")
        completionHandler()
    }
}
