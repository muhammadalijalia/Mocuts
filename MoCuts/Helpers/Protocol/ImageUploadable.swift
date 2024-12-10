
//
//  ImageUploadable.swift
//  MoCuts
//
//  Created by Appiskey's iOS Dev on 10/9/19.
//  Copyright © 2019 Appiskey. All rights reserved.
//

//import Foundation
//import UIKit
//import FirebaseStorage
//
//protocol ImageUploadable {
//    func uploadImage(_ data: Data, completion: @escaping (String) -> (), error: @escaping (String) -> () )
//}
//
//extension ImageUploadable {
//    func uploadImage(_ data: Data, completion: @escaping (String) -> () , error: @escaping (String) -> () ) {
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        let imagesRef = storageRef.child("profile_images/\(Date().timeIntervalSince1970).jpg")
//        
//        let _ = imagesRef.putData(data, metadata: nil) { (metadata, error) in
//            guard let metadata = metadata else {
//                // Uh-oh, an error occurred!
//                completion("Something went wrong while uploading profile")
//                return
//            }
//            // Metadata contains file metadata such as size, content-type.
//            let _ = metadata.size
//            // You can also access to download URL after upload.
//            imagesRef.downloadURL { (url, error) in
//                guard let downloadURL = url else {
//                    // Uh-oh, an error occurred!
//                    completion("Something went wrong while uploading profile")
//                    return
//                }
//                
//                completion(downloadURL.absoluteString)
//            }
//        }
//    }
//}
