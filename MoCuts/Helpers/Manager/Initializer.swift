//
//  Initializer.swift
//  PatientInfo
//
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import CommonComponents

func settingIQKeyBoard() {
    IQKeyboardManager.shared.enable = true
    IQKeyboardManager.shared.enableAutoToolbar = false
    IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    IQKeyboardManager.shared.keyboardDistanceFromTextField = 100.0
}

func initializeRouterConfiguration() {
    //    Router.configuration = RouterConfiguration.init(baseURL: Enviroment.baseURL,                                                    authorizationToken: )
}

func initializeLoader(){
    Loader.getInstance().loaderType = .ballSpinFadeLoader
    Loader.getInstance().backColor = UIColor.black.withAlphaComponent(0.5)
    Loader.getInstance().loaderColor = Theme.appTextFieldPlaceHolderColor
    Loader.getInstance().textColor = Theme.appOrangeColor
}
