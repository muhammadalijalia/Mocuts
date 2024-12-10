//
//  StringExtension.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 7/26/19.
//  Copyright © 2019 Appiskey. All rights reserved.
//

import Foundation

extension String {
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    public var charactersArray: [Character] {
         return Array(self)
     }
    
    public var isNumeric: Bool {
        
        
        print("Numeric")
        print(self)
        
        if self.charactersArray.count > 0{
            
            let characterSet = CharacterSet(charactersIn: "0123456789")
            let range = (self.lastCharacterAsString! as NSString).rangeOfCharacter(from: characterSet)
            return range.location != NSNotFound
        }
        return true

    }
    
    public var lastCharacterAsString: String? {
          guard let last = self.last else {
              return nil
          }
          return String(last)
      }
    
    func isNumber() -> Bool {
          if let number = Int(self){
              return true
          }else{
              return false
          }
      }
    
    
    func formatMobileNumberCustom() -> String{

        
        var mainString : String = ""
        var numberTemp : String = self
        numberTemp = numberTemp.replacingOccurrences(of: " ", with: "")
        if numberTemp.isNumber() == false{
            mainString = ""
            return mainString
        }
        
       
        
        var count : Int = 0
        
        let strTemp : String = numberTemp
        mainString = ""
        for str in (strTemp.charactersArray){
            mainString = mainString + "\(str)"
            if count == 2{
                mainString = mainString + " "
            }else if count == 5{
                mainString = mainString + " "
            }
            count = count + 1
            
        }
        return mainString
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
    
    var URLEncoded:String {

        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let unreservedCharsSet: CharacterSet = CharacterSet(charactersIn: unreservedChars)
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: unreservedCharsSet)!
        return encodedString
    }
    
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlHostAllowed)
    }
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
}


//extension JoinMeetingView: UITextFieldDelegate {
//    
//    // Use this if you have a UITextField
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // get the current text, or use an empty string if that failed
//        let currentText = textField.text ?? ""
//
//        // attempt to read the range they are trying to change, or exit if we can't
//        guard let stringRange = Range(range, in: currentText) else { return false }
//
//        // add their new text to the existing text
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//
//        // make sure the result is under 16 characters
//        return updatedText.count <= 10
//    }
//}

extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        127000...127600, // Various asian characters
        65024...65039, // Variation selector
        9100...9300, // Misc items
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        
        return value == 8205
    }
}

extension String {
    var containsEmoji: Bool {
            return unicodeScalars.contains { $0.isEmoji }
        }
}
