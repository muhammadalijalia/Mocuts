////
////  UIViewController.swift
////  ImageViewer
////
////  Created by Kristian Angyal on 18/03/2016.
////  Copyright © 2016 MailOnline. All rights reserved.
////
//
//import UIKit
//
//public extension UIViewController {
//
//    func loadData(){
//        
//    }
//    public func presentImageGallery(_ gallery: GalleryViewController, completion: (() -> Void)? = {}) {
//
//        present(gallery, animated: false, completion: completion)
//    }
//    
//    func createYLeft(text: String, parentView: UIView){
//        let label = UILabel(frame: CGRect.zero)
//        label.text = text
//        label.textAlignment = .center
//        label.backgroundColor = .clear  // Set background color to see if label is centered
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 13.0)
//        label.textColor = .darkGray
//
//        parentView.addSubview(label)
//
//        let xConstraint = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1, constant: -((label.intrinsicContentSize.width/2)-(label.intrinsicContentSize.height)))//-(CGFloat(text.count)*4.3)/2)
//
//        let yConstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: parentView, attribute: .centerY, multiplier: 1, constant: 0)
//
//        NSLayoutConstraint.activate([xConstraint,yConstraint])
//        label.transform=CGAffineTransform(rotationAngle: -.pi / 2)
//    }
//    
//    func createYRight(text: String, parentView: UIView){
//        let label = UILabel(frame: CGRect.zero)
//        label.text = text
//        label.textAlignment = .center
//        label.backgroundColor = .clear  // Set background color to see if label is centered
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 13.0)
//        label.textColor = .darkGray
//
//        parentView.addSubview(label)
//        label.transform = CGAffineTransform.identity
//        label.transform=CGAffineTransform(rotationAngle: .pi / 2)
//        let xConstraint = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1, constant: ((label.intrinsicContentSize.width/2)-(label.intrinsicContentSize.height)))//(CGFloat(text.count)*4.3)/2)
//
//        let yConstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: parentView, attribute: .centerY, multiplier: 1, constant: 0)
//
//        NSLayoutConstraint.activate([xConstraint,yConstraint])
//        
//    }
//}
