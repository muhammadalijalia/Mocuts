//
//  BarberOnMyWayView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 27/08/2021.
//

import UIKit
import Helpers
import CommonComponents
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON
import FirebaseFirestore

class BarberOnMyWayView: BaseView , Routeable {
    
    @IBOutlet weak var locationView : UIView!
    @IBOutlet weak var serviceDetailView : UIView!
    @IBOutlet weak var currentLocationField : UITextField!
    @IBOutlet weak var destinationField : UITextField!
    @IBOutlet weak var arrivedBtn : UIButton!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var completeServiceView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLbl: UILabel!
    var shouldPopToRoot = true
    var serviceRequestCallBack: ((BarberBaseModel) -> ())?
    var db: Firestore?
    var serviceObject: BarberBaseModel!
    var updateTimer: Timer?
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var sourceMarker: GMSMarker?
    var destinationMarker: GMSMarker?
    var polyLines: GMSPolyline?
    var sourceInfoWindow: ChatHeader!
    var remainingTime = "" {
        didSet {
            if sourceInfoWindow != nil {
                sourceInfoWindow.time = remainingTime
            }
        }
    }
    
    deinit {
        db = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        self.mapView.delegate = self
        sourceInfoWindow = ((ChatHeader.loadWithNib("\(ChatHeader.self)", viewIndex: 0, owner: ChatHeader.self) as! UIView) as! ChatHeader)
        sourceInfoWindow.delegate = self
        sourceInfoWindow.layer.cornerRadius = 4
        sourceInfoWindow.alpha = 0
        self.view.addSubview(sourceInfoWindow)
        viewModel = BarberServiceRequestViewModel()
        
        self.locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
        setTableView()
        updateUserData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadMapData()
    }
    
    func updateFirestoreLocation(latitude: Double, longitude: Double) {
        var parameters = [String:Any]()
        parameters["latitude"] = latitude
        parameters["longitude"] = longitude
        db?.collection("User").document(serviceObject.barber_id?.description ?? "").collection("Job").document(serviceObject.id?.description ?? "").setData(parameters, merge: true, completion: { error in
            if error != nil {
                self.viewModel.showPopup = error?.localizedDescription ?? ""
            }
        })
    }
    
    func setupTimer() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            self.getCurrentLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if updateTimer != nil {
            updateTimer?.invalidate()
            updateTimer = nil
        }
        locManager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CLLocationManager.locationServicesEnabled() {
            locManager.startUpdatingLocation()
        }
        
        setupTimer()
        tableView.reloadData()
        if serviceObject.status == 15 {
            completeServiceView.isHidden = false
        }
        setView()
    }
    
    @objc func popToRoot() {
        if shouldPopToRoot {
            routeBack(navigation: .popToRootVC)
        } else {
            routeBack(navigation: .pop)
        }
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            backButton.action = #selector(popToRoot)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, title: "On Going Service", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
            backButton.action = #selector(popToRoot)
        }
        
        locationView.layer.cornerRadius = 5
        locationView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        locationView.layer.shadowOpacity = 1
        locationView.layer.shadowOffset = .zero
        locationView.layer.shadowRadius = 5
        
        serviceDetailView.layer.cornerRadius = 5
        serviceDetailView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        serviceDetailView.layer.shadowOpacity = 1
        serviceDetailView.layer.shadowOffset = .zero
        serviceDetailView.layer.shadowRadius = 5
        completeBtn.layer.cornerRadius = 5
        arrivedBtn.layer.cornerRadius = 5
    }
    
    func updateUserData() {
        name.text = serviceObject.user?.name
        let clientAddress = serviceObject.user?.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
        address.text = clientAddress
        let avgRating = serviceObject.user?.average_rating ?? 0.0        
        rating.text = String(format: avgRating == 0 ? "%.1f" : "%.2f", avgRating)
        
        picture.sd_setImage(with: URL(string: serviceObject.user?.image_url ?? ""), completed: nil)
        destinationField.text = clientAddress
    }
    
    func updateLocationName() {
        let gmsGeocoder = GMSGeocoder()
        let coordinates = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        gmsGeocoder.reverseGeocodeCoordinate(coordinates, completionHandler: {
            response, error in
            if error == nil {
                if let places = response?.results() {
                    if let place = places.first, place.lines?.count > 0 {
                        self.currentLocationField.text = place.lines?[0] ?? ""
                    }
                }
            }
        })
    }
    
    @objc func getCurrentLocation() {
        if
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            guard locManager.location != nil else {
                return
            }
            currentLocation = locManager.location
                updateFirestoreLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            updateLocationName()
            loadMapData()
        } else {
            if CLLocationManager.authorizationStatus() != .notDetermined {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Message", message: "Allow location from settings", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        @unknown default:
                            print("sdfsdf")
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func loadMapData() {
        if
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            currentLocation = locManager.location
            
            let origin = "\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)"
            let destination = "\(serviceObject.user?.latitude ?? ""),\(serviceObject.user?.longitude ?? "")"
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=AIzaSyA8gLDDWQk2qfHnjJ8m6v_Dj_XmSaqpaE0"
            
            Alamofire.request(url).responseJSON { response in
                do {
                    self.mapView.animate(toLocation: self.currentLocation.coordinate)
                    self.mapView.animate(toZoom: 16.0)
                    let sourcePosition = CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude)
                    
                    if self.sourceMarker == nil {
                        self.sourceMarker = GMSMarker(position: sourcePosition)
                        self.sourceMarker?.icon = UIImage(named: "Source")
                        self.sourceMarker?.map = self.mapView
                    }
                    if self.destinationMarker == nil {
                        let destinationPosition = CLLocationCoordinate2D(latitude: Double(self.serviceObject.user?.latitude ?? "") ?? 0.0, longitude: Double(self.serviceObject.user?.longitude ?? "") ?? 0.0)
                        self.destinationMarker = GMSMarker(position: destinationPosition)
                        self.destinationMarker?.icon = UIImage(named: "Destination")
                        self.destinationMarker?.map = self.mapView
                    }
                    self.sourceMarker?.position = sourcePosition
                    
                    if let data = response.data
                    {
                        let json = try JSON(data: data)
                        let routes = json["routes"].arrayValue
                        
                        let rout = (routes.first)
                        let legs = (rout?["legs"].arrayValue)
                        let duration = (legs?.first?["duration"])
                        self.remainingTime = duration?["text"].rawString() ?? ""
                        //                        self.sourceMarker?.snippet = duration?["text"].rawString() ?? ""
                        
                        for route in routes
                        {
                            
                            let routeOverviewPolyline = route["overview_polyline"].dictionary
                            let points = routeOverviewPolyline?["points"]?.stringValue
                            let path = GMSPath.init(fromEncodedPath: points!)
                            
                            if self.polyLines != nil {
                                self.polyLines?.map = nil
                            }
                            self.polyLines = GMSPolyline(path: path)
                            self.polyLines?.strokeColor = .black
                            self.polyLines?.strokeWidth = 2.0
                            self.polyLines?.map = self.mapView
                        }
                    }
                    self.sourceMarker?.map = self.mapView
                }
                catch {
                    print("Error")
                }
            }
        } else {
            if CLLocationManager.authorizationStatus() != .notDetermined {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Message", message: "Allow location from settings", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        @unknown default:
                            print("sdfsdf")
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TotalServiceCell", bundle: nil), forCellReuseIdentifier: "TotalServiceCell")
        tableView.register(UINib(nibName: "ServiceNameCell", bundle: nil), forCellReuseIdentifier: "ServiceNameCell")
        tableView.register(UINib(nibName: "TotalChargesCell", bundle: nil), forCellReuseIdentifier: "TotalChargesCell")
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.bounces = false
    }
    
    @IBAction func callButtonAction(_ sender : UIButton) {
        if let url = URL(string: "tel://\(serviceObject.user?.phone ?? "0")") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func arrivedBtnAction(_ sender : UIButton) {
        let alertController = UIAlertController(title: "Confirmation", message: "Have you arrived at \(serviceObject.user?.name ?? "")'s location?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default)
        { [weak self] action -> Void in
            guard let self = self else {
                return
            }
            (self.viewModel as! BarberServiceRequestViewModel).setAcceptRoute = {
                DispatchQueue.main.async {
                    self.serviceObject.status = 15
                    self.serviceRequestCallBack?(self.serviceObject)
                    self.completeServiceView.isHidden = false
                }
            }
            (self.viewModel as! BarberServiceRequestViewModel).acceptService(serviceID: self.serviceObject.id ?? 0, params: ["status":"15"])
        })
        alertController.addAction(UIAlertAction(title: "No", style: .cancel)
        { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func chatButtonAction(_ sender : UIButton) {
        let vc : BarberChatView = AppRouter.instantiateViewController(storyboard: .Barbermore)
        vc.serviceObject = serviceObject
        self.route(to: vc, navigation: .push)
    }
    
    @IBAction func completeBtnAction(_ sender : UIButton) {
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to complete this service?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default)
                                  { [weak self] action -> Void in
            guard let self = self else {
                return
            }
            (self.viewModel as! BarberServiceRequestViewModel).setAcceptRoute = {
                self.serviceObject.status = 26
                self.serviceRequestCallBack?(self.serviceObject)
                DispatchQueue.main.async {
                    let vc : BarberRateView = AppRouter.instantiateViewController(storyboard: .Barberprofile)
                    vc.delegate = self
                    vc.jobId = self.serviceObject.id
                    vc.toId = self.serviceObject.user_id
                    vc.screenCase = .barber
                    self.route(to: vc, navigation: .modal)
                }
            }
            (self.viewModel as! BarberServiceRequestViewModel).acceptService(serviceID: self.serviceObject.id ?? 0, params: ["status":"26"])
        })
        alertController.addAction(UIAlertAction(title: "No", style: .cancel)
                                  { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
}

extension BarberOnMyWayView: CLLocationManagerDelegate
{
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error::: \(error)")
        locManager.stopUpdatingLocation()
        if CLLocationManager.authorizationStatus() != .notDetermined {
            let alert = UIAlertController(title: "Message", message: "Allow location from settings", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
                switch action.style{
                case .default:
                    UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                @unknown default:
                    print("sdfsdf")
                }
            }))
        }
    }
}

extension BarberOnMyWayView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (serviceObject.job_services?.count ?? 0) + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let serviceCount = serviceObject?.job_services?.count ?? 0
        var totalDuration = 0
        for service in serviceObject?.job_services ?? [Job_Services]() {
            totalDuration += service.duration ?? 0
        }
        totalDuration = totalDuration * 60
        let totalRows = serviceCount + 2
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalServiceCell", for: indexPath) as! TotalServiceCell
            cell.serviceCount.text = "\(String(serviceCount)) Services Selected"
            
            cell.totalTime.text = "(\(Utilities.shared.getSecondsInWords(seconds: Double(totalDuration))))"
            cell.backgroundColor = .clear
            return cell
        } else if indexPath.row == totalRows - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalChargesCell", for: indexPath) as! TotalChargesCell
            cell.salesTaxSV.isHidden = true
            cell.topLineView.isHidden = true
            cell.underLineView.isHidden = true
            cell.backgroundColor = .clear
            
            let subTotal = Double(self.serviceObject?.sub_total ?? 0)
            let commision = Double(self.serviceObject?.commission ?? 0)
            let total = subTotal - ((commision/100.0) * subTotal)
            
            cell.subTotalCharges.text = "$ \(String(format: "%.2f", subTotal))"
            cell.commisionCharges.text = "\(String(format: "%.2f", commision))%"
            cell.totalCharges.text = "$ \(String(format: "%.2f", total))"
            totalLbl.text = "Total: $ \(String(format: "%.2f", total))"
            
            return cell
        } else {
            let data = serviceObject?.job_services?[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceNameCell", for: indexPath) as! ServiceNameCell
            cell.serviceName.text = data?.service?.name
            cell.serviceCharges.text = "$ " + String(format: "%.2f", Double(data?.service?.price ?? 0))
            cell.backgroundColor = .clear
            return cell
        }
    }
}

//MARK:- BarberRateViewDelegate
extension BarberOnMyWayView: BarberRateViewDelegate {
    func reviewDone(view: BarberRateView) {
        
        DispatchQueue.main.async {
            self.serviceObject.status = 40
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                view.dismiss(animated: true, completion: {
                    self.popToRoot()
                })
            })
        }
    }
}

//MARK: GMSMapViewDelegate

extension BarberOnMyWayView : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if marker == sourceMarker {
            sourceInfoWindow.center = mapView.projection.point(for: marker.position)
            sourceInfoWindow.center.y = sourceInfoWindow.center.y - 92
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if sourceMarker != nil {
            sourceInfoWindow.center = mapView.projection.point(for: sourceMarker!.position)
            sourceInfoWindow.center.y = sourceInfoWindow.center.y - 92
            sourceInfoWindow.alpha = 1
        }
    }
}

//MARK: ChatHeaderDelegate
extension BarberOnMyWayView: ChatHeaderDelegate {
    func itemTapped() {
    }
}
