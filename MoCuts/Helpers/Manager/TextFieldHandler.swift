//
//  TextFieldHandler.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 16/04/2020.
//  Copyright © 2020 Appiskey. All rights reserved.
//


import Foundation
import UIKit

/// Sigleton class to manage text fields interaction with the keyboard.
class TextFieldHandler {
    
    static var shared = TextFieldHandler()
    
    private var _dataArray = [UITextField]()
    
    /// Method: This function register to this class
    ///
    /// - Parameter textFields: Array of textfield that need to get register to this classs
    func register(textFields: [UITextField]) {
        
        _dataArray = textFields
        for field in _dataArray {
            field.addTarget(self, action: #selector(shouldReturnPressed(_:)), for: .editingDidEndOnExit)
            if field === _dataArray.last{
                field.returnKeyType = .done
            }else{
                field.returnKeyType = .next
            }
        }
    }
    
    /// Method that return textfields
    ///
    /// - Returns: return array of textfields
    func getData() -> [UITextField] {
        return _dataArray
    }
    
    @objc private func shouldReturnPressed(_ sender: UITextField) {
        
        self.handleTextField(textField: sender)
        
    }
    
    /// Method to manage keybord opening and closing on pressing done or return.
    ///
    /// - Parameter textField: current textfield of the View Controller.
    private func handleTextField(textField: UITextField) {
        
        let texFields = TextFieldHandler.shared.getData()
        if let index = texFields.firstIndex(where: {$0 == textField}) {
            if index == (texFields.count - 1) {
                textField.resignFirstResponder()
            } else {
                texFields[index+1].becomeFirstResponder()
            }
        }
    }
    
}
