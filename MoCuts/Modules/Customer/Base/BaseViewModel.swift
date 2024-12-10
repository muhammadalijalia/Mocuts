//
//  BaseViewModel.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 12/07/2019.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import Foundation
import Reachability

class BaseViewModel: NSObject {
    
    var setFailureMessage : ((String) -> Void)?
    var setLoading : ((Bool) -> Void)?
    var setErrorPopup : ((String) -> Void)?
    var setSuccessPopup : ((String) -> Void)?
    var setToastView : ((String) -> Void)?
    var reachability = Reachability()
    
    var isLoading : Bool = false {
        didSet {
            setLoading?(isLoading)
        }
    }
    var errorMessage : String = "" {
        didSet {
            setFailureMessage?(errorMessage)
        }
    }
    var setToastMessage : String = "" {
        didSet {
            setToastView?(setToastMessage)
        }
    }
    
    var showPopup : String = "" {
        didSet {
            setErrorPopup?(showPopup)
        }
    }
    
    var showSuccessPopup : String = "" {
        didSet {
            setSuccessPopup?(showSuccessPopup)
        }
    }

    //    var isInternetAvailable: Bool  {
    //        guard reachability?.connection != Reachability.Connection.unavailable else {
    //            self.setFailureMessage?(Messages.internetError)
    //            return false
    //        }
    //        return true
    //    }
    
    var networkAdapter : NetworkChangeNotifiable = NetworkChangeClass()
}
