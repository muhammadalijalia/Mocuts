//
//  FirebaseUtility.swift
//  MoCuts
//
//  Created by Mohammad Zawwar on 16/06/2020.
//  Copyright © 2020 Appiskey. All rights reserved.
//


import Foundation
import Firebase
import UIKit
import FirebaseStorage

class FirebaseUtility {
    
    private init() {}
    static let shared = FirebaseUtility()
    
    private let storageRef = Storage.storage().reference()

    
    func uploadImage (image: UIImage, path: String, completion: @escaping (String?, String?) -> ())  {
        
        let randomString = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        if let imageData = image.jpegData(compressionQuality: 0.4){
            self.uploadToFirebase(data: imageData, metaData: ["contentType": "image/jpeg"], path: path.appending("/\(randomString).jpeg"), completion: completion)
        } else if let imageData = image.pngData() {
            self.uploadToFirebase(data: imageData, metaData: ["contentType": "image/png"], path: path.appending("/\(randomString).png"), completion: completion)
        } else {
            
            completion("Please select another picture.", nil)
        }
    }
    
    func uploadToFirebase(data : Data,metaData:[String:AnyHashable]?, path: String, completion: @escaping (String?, String?) -> ()) {
        
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child(path)
        
        var storageMeta : StorageMetadata?
        if let data = metaData {
            storageMeta = StorageMetadata(dictionary: data)
        }
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: storageMeta) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                
                completion(error!.localizedDescription, nil)
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let fullPath = riversRef.fullPath
            self.downloadURL(path: fullPath) { (newUrl) in
                completion(nil, newUrl?.absoluteString)
            }
        }
    }
    
    func downloadURL(path:String, completion : @escaping (URL?)->()) {
        let starsRef = Storage.storage().reference().child(path)
        
        starsRef.downloadURL { url, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                completion(url)
            }
        }
    }
}
