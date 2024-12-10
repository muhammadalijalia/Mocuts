//
//  CustomerOnMyWayView.swift
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

class CustomerOnMyWayView: BaseView , Routeable {
    
    @IBOutlet weak var locationView : UIView!
    @IBOutlet weak var serviceDetailView : UIView!
    @IBOutlet weak var currentLocationField : UITextField!
    @IBOutlet weak var destinationField : UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet var completeBtn: UIButton!
    @IBOutlet weak var completeServiceView: UIView!
    @IBOutlet weak var serviceCompletedView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var listnerReg: ListenerRegistration?
    var userLocation: CLLocationCoordinate2D?
    var sourceMarker: GMSMarker?
    var destinationMarker: GMSMarker?
    var polyLines: GMSPolyline?
    var serviceRequestCallBack: ((BarberBaseModel) -> ())?
    var serviceObject: BarberBaseModel!
    var db: Firestore?
    var didSetLocationName = false
    var shouldPopToRoot = true
    var remainingTime = "" {
        didSet {
            timeLeft.text = remainingTime.uppercased()
        }
    }
    
    deinit {
        listnerReg?.remove()
        db = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        db = Firestore.firestore()
        viewModel = CustomerOnMyWayViewModel()
        initViews()
    }
    
    func initViews() {
        userLocation = CLLocationCoordinate2D(latitude: Double(serviceObject.user?.latitude ?? "0") ?? 0, longitude: Double(serviceObject.user?.longitude ?? "0") ?? 0)
        
        if (serviceObject.status ?? 0) <= JobStatus.COMPLETED {
            setupLocationListener()
        } else {
            let barberLoc = CLLocationCoordinate2D(latitude: Double(serviceObject.barber?.latitude ?? "0") ?? 0, longitude: Double(serviceObject.barber?.longitude ?? "0") ?? 0)
            self.loadMapData(origin2D: barberLoc)
        }
        updateUserData()
    }
    
    func setData() {
        setView()
        
        if serviceObject.status == JobStatus.BARBER_MARKED_COMPLETED || serviceObject.status == JobStatus.BARBER_REVIEWED {
            completeServiceView.isHidden = false
        } else if (serviceObject.status ?? 0) >= JobStatus.COMPLETED {
            serviceCompletedView.isHidden = false
            completeServiceView.isHidden = true
            serviceDetailView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    func setupLocationListener() {
        listnerReg = db?.collection("User").document(serviceObject.barber?.id?.description ?? "").collection("Job").document(serviceObject.id?.description ?? "").addSnapshotListener { (data, error) in
            if error == nil {
                if let dictData = data?.data() {
                    let newLat = dictData["latitude"] as? Double ?? 0.0
                    let newLong = dictData["longitude"] as? Double ?? 0.0
                    let newCoordinates = CLLocationCoordinate2D(latitude: newLat, longitude: newLong)
                    self.loadMapData(origin2D: newCoordinates)
                    if !self.didSetLocationName {
                        self.updateLocationName(coordinates: newCoordinates)
                    }
                }
            }
        }
    }
    func updateLocationName(coordinates: CLLocationCoordinate2D) {
        let gmsGeocoder = GMSGeocoder()
        gmsGeocoder.reverseGeocodeCoordinate(coordinates, completionHandler: {
            response, error in
            if error == nil {
                if let places = response?.results() {
                    if let place = places.first, place.lines?.count > 0 {
                        self.currentLocationField.text = place.lines?[0] ?? ""
                        self.didSetLocationName = true
                    }
                }
            }
        })
    }
    
    func updateUserData() {
        name.text = serviceObject.barber?.name
        let barberAddress = serviceObject.barber?.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
        address.text = barberAddress
        let avgRating = serviceObject.barber?.average_rating ?? 0.0
        rating.text = String(format: avgRating == 0 ? "%.1f" : "%.2f", avgRating)
        picture.sd_setImage(with: URL(string: serviceObject.barber?.image_url ?? ""), completed: nil)
        destinationField.text = serviceObject.user?.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
        currentLocationField.text = barberAddress
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
    
    @objc func onBack() {
        if self.shouldPopToRoot {
            self.routeBack(navigation: .popToRootVC)
        } else {
            self.routeBack(navigation: .pop)
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
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, title: "Barber On Way", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
            backButton.action = #selector(onBack)
        }
        
        locationView.layer.cornerRadius = 5
        locationView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        locationView.layer.shadowOpacity = 1
        locationView.layer.shadowOffset = .zero
        locationView.layer.shadowRadius = 5
        
        completeBtn.layer.cornerRadius = 5
        
        serviceDetailView.layer.cornerRadius = 5
        serviceDetailView.layer.shadowOpacity = 1
        serviceDetailView.layer.shadowOffset = .zero
        serviceDetailView.layer.shadowRadius = 5
        serviceDetailView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        
        completeServiceView.layer.cornerRadius = 5
        completeServiceView.layer.shadowOpacity = 1
        completeServiceView.layer.shadowOffset = .zero
        completeServiceView.layer.shadowRadius = 5
        completeServiceView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        
        serviceCompletedView.layer.cornerRadius = 5
        serviceCompletedView.layer.shadowOpacity = 1
        serviceCompletedView.layer.shadowOffset = .zero
        serviceCompletedView.layer.shadowRadius = 5
        serviceCompletedView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        
    }
}

//MARK: IBActions
extension CustomerOnMyWayView {
    @IBAction func callButtonAction(_ sender : UIButton) {
        if let url = URL(string: "tel://\(serviceObject.barber?.phone ?? "0")") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func arrivedBtnAction(_ sender : UIButton) {

    }
    
    @IBAction func chatButtonAction(_ sender : UIButton) {
        let vc : BarberChatView = AppRouter.instantiateViewController(storyboard: .Barbermore)
        vc.serviceObject = serviceObject
        vc.isCustomer = true
        self.route(to: vc, navigation: .push)
    }
    
    @IBAction func completeTapped() {
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to complete this service?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default)
        { [weak self] action -> Void in
            guard let self = self else {
                return
            }
            (self.viewModel as! CustomerOnMyWayViewModel).setAcceptRoute = {
                DispatchQueue.main.async {
                    self.serviceObject.status = 30
                    self.serviceRequestCallBack?(self.serviceObject)
                    let vc : BarberRateView = AppRouter.instantiateViewController(storyboard: .Barberprofile)
                    vc.delegate = self
                    vc.jobId = self.serviceObject.id
                    vc.toId = self.serviceObject.barber_id
                    vc.screenCase = .customer
                    self.route(to: vc, navigation: .modal)
                }
            }
            (self.viewModel as! CustomerOnMyWayViewModel).updateJob(serviceId: self.serviceObject.id ?? 0, params: ["status":"30"])
        })
        alertController.addAction(UIAlertAction(title: "No", style: .cancel)
        { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: UITableViewDelegate

extension CustomerOnMyWayView: UITableViewDelegate , UITableViewDataSource {
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
            cell.backgroundColor = .clear
            cell.topLineView.isHidden = true
            cell.underLineView.isHidden = true
            cell.salesTaxSV.isHidden = false
            cell.comissionSV.isHidden = true
            
            let subTotal = Double(self.serviceObject?.sub_total ?? 0)
            let total = Double(subTotal) + Double(subTotal) * 0.1
            
            cell.subTotalCharges.text = "$ \(String(format: "%.2f", subTotal))"
            cell.salesTaxCharges.text = "10.00 %"
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

//Map Update
extension CustomerOnMyWayView {
    func loadMapData(origin2D: CLLocationCoordinate2D) {
        let origin = "\(origin2D.latitude),\(origin2D.longitude)"
        
        let destination = "\(serviceObject.user?.latitude ?? ""),\(serviceObject.user?.longitude ?? "")"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=AIzaSyA8gLDDWQk2qfHnjJ8m6v_Dj_XmSaqpaE0"
        
        Alamofire.request(url).responseJSON { response in
            do {
                self.mapView.animate(toLocation: origin2D)
                self.mapView.animate(toZoom: 16.0)
                
                if self.sourceMarker == nil {
                    self.sourceMarker = GMSMarker(position: origin2D)
                    self.sourceMarker?.icon = UIImage(named: "Source")
                    self.sourceMarker?.map = self.mapView
                }
                if self.destinationMarker == nil {
                    let destinationPosition = CLLocationCoordinate2D(latitude: Double(self.serviceObject.user?.latitude ?? "") ?? 0.0, longitude: Double(self.serviceObject.user?.longitude ?? "") ?? 0.0)
                    self.destinationMarker = GMSMarker(position: destinationPosition)
                    self.destinationMarker?.icon = UIImage(named: "Destination")
                    self.destinationMarker?.map = self.mapView
                }
                self.sourceMarker?.position = origin2D
                
                if let data = response.data
                {
                    let json = try JSON(data: data)
                    let routes = json["routes"].arrayValue
                    
                    let rout = (routes.first)
                    let legs = (rout?["legs"].arrayValue)
                    let duration = (legs?.first?["duration"])
                    self.remainingTime = duration?["text"].rawString() ?? ""
                    
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
    }
}

//MARK:- BarberRateViewDelegate
extension CustomerOnMyWayView: BarberRateViewDelegate {
    func reviewDone(view: BarberRateView) {
        DispatchQueue.main.async {
            self.serviceObject.status = 35
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                view.dismiss(animated: true, completion: {
                    if self.shouldPopToRoot {
                        self.routeBack(navigation: .popToRootVC)
                    } else {
                        self.routeBack(navigation: .pop)
                    }
                })
            })
        }
    }
}
