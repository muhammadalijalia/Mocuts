//
////
////  MapViewController.swift
////  ATSocial
////
////  Created by Mohammad Zawwar on 12/11/17.
////  Copyright © 2017 APPISKEY. All rights reserved.
////
//
//import UIKit
//import MapKit
//import GooglePlaces
//import GoogleMaps
//
//
//protocol MapViewDelegate {
//    func getAddress(_ address : Address)
//}
//class MapViewController: UIViewController  {
//
//    //MARK: IBOutlets
//    @IBOutlet weak var cancelBtn: UIButton!
//    @IBOutlet weak var topBar: UIView!
//    @IBOutlet weak var searchtxtField: UITextField!
//    @IBOutlet weak var mapView: GMSMapView!
//    @IBOutlet weak var doneBtn: UIButton!
//
//    //MARK: Private Variables
//    private var location : CLLocation = CLLocation()
//
//    //MARK: Public Variables
//    var topBarBackgroundColor : UIColor = .white
//    var topBarTextColor: UIColor = .black
//
//    var doneButtonBackgroundColor: UIColor = Theme.appOrangeColor
//
//
//    var doneButtonTextColor : UIColor = .white
//
//    //MARK: Preset Variables
//    var address: Address?
//    var delegate : MapViewDelegate?
//
//    //MARK: Map Keys
//    static var mapKey : String = ""
//    static var placeKey : String = ""
//
//    //MARK: Xib Overriders
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        searchtxtField.delegate = self
//
//        if address != nil {
//            self.setCamera(to: CLLocationCoordinate2D(latitude: address!.latitude, longitude: address!.longitude))
//        }  else {
//
//            self.setCamera(to: CLLocationCoordinate2D(latitude: 28.5383, longitude: -81.3792))
//
//            LocationManager.shared.getUserLocation { (location) in
//                self.setCamera(to: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
//            }
//        }
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//
//        self.mapView.delegate = self
//        self.setScreen()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//
//        self.mapView.delegate = nil
//    }
//
//    //MARK: Custom Functions
//    func setScreen() {
//
//        self.addShadow(self.topBar)
//        self.addShadow(self.doneBtn)
//        self.searchtxtField.textColor = topBarTextColor
//        self.cancelBtn.setTitleColor(topBarTextColor, for: .normal)
//        self.topBar.backgroundColor = topBarBackgroundColor
//        self.doneBtn.setTitleColor(doneButtonTextColor, for: .normal)
//        self.doneBtn.backgroundColor = doneButtonBackgroundColor
//        self.view.layoutIfNeeded()
//    }
//
//    func addShadow(_ view : UIView) {
//
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOffset = CGSize(width: 1, height: 0)
//        view.layer.shadowOpacity = 0.5
//        view.layer.shadowRadius = 3.0
//
//    }
//    //MARK: Map Adress Setters
//    static func startMapLibrary(mapKey: String, placeKey: String) {
//        MapViewController.mapKey = mapKey
//        MapViewController.placeKey = placeKey
//        GMSServices.provideAPIKey(mapKey)
//        GMSPlacesClient.provideAPIKey(placeKey)
//    }
//    //MARK: Map Adress Helpers
//    fileprivate func setCamera(to coordinate: CLLocationCoordinate2D, zoom:Float = 15.0) {
//
//        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
//            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoom)
//            self.mapView.animate(to: camera)
//        }) { (completed) in
//
//        }
//        self.setLocation(to: coordinate)
//    }
//
//    fileprivate func setLocation(to coordinate: CLLocationCoordinate2D) {
//
//        print("-> Finding user address...")
//        AddressAPI().getAddressByGeoPoints(latitude: "\(coordinate.latitude)", longitude: "\(coordinate.longitude)") { (address, error, isSuccess) in
//
//            DispatchQueue.main.async {
//
//                if let add = address {
//
//                    self.address = address
//                    AddressAPI().getAddress(add, completion: { (formmatedAddress) in
//                        self.searchtxtField.text = formmatedAddress
//                    })
//
//                } else {
//                    self.address = nil
//                    self.searchtxtField.text = "Unable to determine City, State."
//                }
//            }
//        }
//    }
//
//    //MARK: Screen Actions
//    @IBAction func btnActionUserLocation() {
//
//        LocationManager.shared.getUserLocation { (location) in
//
//            self.setCamera(to: location.coordinate)
//        }
//
//    }
//
//    @IBAction func doneBtnAction(_ sender: Any) {
//
//        if address == nil || address!.city == "" || address!.state == "" {
//
//            let alertController = UIAlertController(title: "Error", message: "Please select city and state", preferredStyle: .alert)
//            let action = UIAlertAction(title: "Done", style: .default, handler: nil)
//            alertController.addAction(action)
//            self.present(alertController, animated: true, completion: nil)
//
//            return
//        }
//        self.delegate?.getAddress(address!)
//
//        DispatchQueue.main.async {
//            self.dismiss(animated: true, completion: nil)
//        }
//
//    }
//
//    @IBAction func cancelBtnTapped(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//    }
//}
//extension MapViewController: GMSAutocompleteViewControllerDelegate {
//
//    //MARK: Google Place Delegates
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//
//        let coordinate1:CLLocationCoordinate2D = place.coordinate
//
//        self.dismiss(animated: true) {
//            self.setCamera(to: coordinate1)
//        }
//    }
//
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//
//        // TODO: handle the error.
//        // print("Error: ", error.description)
//    }
//
//}
//extension MapViewController : UITextFieldDelegate {
//
//    //MARK: TextField Delegates
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == searchtxtField {
//            let controller : GMSAutocompleteViewController =  GMSAutocompleteViewController()
//            controller.delegate =  self
//            let navigationControl : UINavigationController = UINavigationController(rootViewController: controller)
//            present(navigationControl, animated: true, completion: nil)
//            return false
//        }
//        else {
//            return true
//        }
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//}
//extension MapViewController: GMSMapViewDelegate {
//
//    //MARK: MapView Delegates
//    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//
//        self.setLocation(to: position.target)
//    }
//
//}
//
