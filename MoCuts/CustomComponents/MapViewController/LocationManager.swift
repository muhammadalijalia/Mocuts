////
////  LocationManager.swift
////  MoCuts
////
////  Created by Mohammad Zawwar on 19/08/2020.
////  Copyright © 2020 Appiskey. All rights reserved.
////
//
//import Foundation
////
////  LocationManager.swift
////  ATSocial
////
////  Created by Mohammad Zawwar Mohammad Zawwar on 03/07/2017.
////  Copyright © 2017 APPISKEY. All rights reserved.
////
//
//import UIKit
//import MapKit
//import GoogleMaps
//
//protocol UserLocationDelegate {
//    func userLocationdidChange(_ location: CLLocation)
//}
//class LocationManager: NSObject , CLLocationManagerDelegate{
//    
//    private var currentLocation : CLLocation?
//    private var locationManager = CLLocationManager()
//    
//    private override init() {
//        super.init()
//        
//    }
//    
//    private var userLocation : CLLocation?{
//        get {
//            return currentLocation
//        }
//    }
//    var authroizationStatus : CLAuthorizationStatus = .notDetermined
//    
//    func getUserLocation (completion: @escaping (CLLocation) -> ()) {
//        if let location = userLocation {
//            completion(location)
//        } else {
//            self.startLocationUpdate {
//                if let location = userLocation {
//                    completion(location)
//                } else {
//                    Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timmer) in
//                        if let location = self.userLocation {
//                            completion(location)
//                            timmer.invalidate()
//                        }
//                    })
//                }
//            }
//        }
//    }
//    var delegate: UserLocationDelegate?
//    static let shared = LocationManager()
//    
//    func startLocationUpdate (completion: () -> ()) {
//        
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.distanceFilter = 50
//        locationManager.delegate = self
//        locationManager.startUpdatingLocation()
//        completion()
//        
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        currentLocation = manager.location//locations.last!
//        delegate?.userLocationdidChange(currentLocation!)
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        
//        locationManager.stopUpdatingLocation()
//        print("Error: \(error)")
//        showSettingPrompt()
//    }
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        self.authroizationStatus = status
//        switch status {
//        case .restricted:
//            print("Location access was restricted.")
//        case .denied:
//            print("User denied access to location.")
//        case .notDetermined:
//            print("Location status not determined.")
//        case .authorizedAlways: fallthrough
//        case .authorizedWhenInUse:
//            print("Location status is OK.")
//        }
//    }
//    
//    func showSettingPrompt() {
//        
//        let alertVC = UIAlertController(title: "Allow \"AT Social\" to access your location while you use the app", message: "To show AT Social events near your location", preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
//            self.openSetting()
//        }))
//        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        //         self.present(alertVC, animated: true, completion: nil)
//        
//    }
//    func openSetting () {
//        if let url = URL(string: UIApplication.openSettingsURLString){
//            if UIApplication.shared.canOpenURL(url) {
//                if #available(iOS 10, *) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                } else {
//                    UIApplication.shared.openURL(url)
//                }
//            }
//        }
//    }
//    
//    func gettingAddress(coordinate:CLLocationCoordinate2D, completionHandler : @escaping (_ address: Address) -> () ){
//        let geocoder : CLGeocoder = CLGeocoder()
//        let location : CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        
//        print("-> Finding user address...")
//        
//        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
//            
//            if error == nil && placemarks!.count > 0 {
//                let placemarkLocation = placemarks![0] as CLPlacemark
//                
//                let country =  (placemarkLocation.country) ?? ""
//                let state = (placemarkLocation.administrativeArea) ?? ""
//                let city = placemarkLocation.locality  ?? ""
//                let zip = (placemarkLocation.postalCode) ?? ""
//                let address = placemarkLocation.thoroughfare ?? ""
//                let latitude = (placemarkLocation.location?.coordinate.latitude) ?? 0.0
//                let longitude = (placemarkLocation.location?.coordinate.longitude) ?? 0.0
//                
//                let obj = Address(country: country, state: state, city: city, zip: zip, address: address, latitude: latitude, longitude: longitude)
//                
//                completionHandler(obj)
//            }
//        })
//        
//    }
//}
