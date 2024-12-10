//
//  Alert.swift
//  MoCuts
//
//  Created by Abdul Basit on 18/10/2021.
//

import Foundation
import UIKit

class Alert
{
    
    class func showAlert(title:String, message:String, vc:UIViewController, completionHandler: @escaping (Bool?) -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            completionHandler(true)
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertWithYesNo(title:String, message:String, vc:UIViewController, completionHandler: @escaping (Bool?) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { action in
            completionHandler(false)
        }))
        vc.present(alert, animated: true, completion: nil)
    }
}
