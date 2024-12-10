//
//  HomeView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 26/07/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import GoogleMaps
import GooglePlaces
import PlacesPicker

class HomeView: BaseView, Routeable {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var searchField: UITextField!
    var alert: UIAlertController!
    var indexOfCellBeforeDragging = 0
    var selectedServices = [String]()
    var selectedRating: Double?
    var selectedRadius: Double?
    var didInteractWithRating = false
    var didInteractWithRadius = false
    var locManager = CLLocationManager()
    var map:GMSMapView?
    var barbers = [BarberModel]()
    var currentIndex: Int = 0
    var loadedOnce = false
    var address = ""
    var hasTriedOnce = false
    var currentLocation: CLLocationCoordinate2D?
    var updateTimer: Timer?
    var didFilter = false
    var lastPage = 0
    var lastIndex = 0
    var lat: String {
        get {
            return String(currentLocation?.latitude ?? (Double(UserPreferences.userModel?.latitude ?? "0") ?? 0))
        }
    }
    
    var long: String {
        get {
            return String(currentLocation?.longitude ?? (Double(UserPreferences.userModel?.longitude ?? "0") ?? 0))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(checkLocationPermissions), name: UIApplication.didBecomeActiveNotification, object: nil)
        setView()
        checkLocationPermissions()
        
        viewModel = HomeViewModel()
        setupViewModelObserver()
    }
    
    @objc func checkLocationPermissions() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .notDetermined {
            if alert != nil {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
        if (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            if CLLocationManager.locationServicesEnabled() {
                locManager.delegate = self
                locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locManager.startUpdatingLocation()
            } else {
                settingsPopup()
            }
        } else if CLLocationManager.authorizationStatus() == .notDetermined {
            setuplocationManager()
        } else {
            settingsPopup()
        }
    }
    
    func settingsPopup() {
        if CLLocationManager.authorizationStatus() == .denied {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if self.alert == nil || (self.alert != nil && !self.alert.isBeingPresented) {
                    self.locationAlert()
                }
            }
        } else {
            if alert != nil {
                alert.dismiss(animated: true, completion: nil)
            }
            self.locManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func locationAlert() {
        if self.tabBarController?.selectedIndex == 0 {
            alert = UIAlertController(title: "Alert", message: "Location required to fetch barbers near you.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { action in
                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setuplocationManager() {
        self.locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        } else {
            getData()
        }
    }
    
    func mapSetup(forLocation: CLLocationCoordinate2D) {
        mapView.clear()
        let camera = GMSCameraPosition.camera(withLatitude: forLocation.latitude, longitude: forLocation.longitude, zoom: 17)
        mapView.camera = camera
        
        let initialLocation = CLLocationCoordinate2DMake(forLocation.latitude, forLocation.longitude)
        let marker = GMSMarker(position: initialLocation)
        
        marker.icon = UIImage(named: "DestinationCustomer")
        marker.map = mapView
    }
    
    func setupViewModelObserver() {
        (viewModel as! HomeViewModel).successClosure = { [weak self] response in
            guard let self = self else {
                return
            }
            self.lastPage = response.lastPage ?? 0
            self.barbers = response.barbers ?? [BarberModel]()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                if self.collectionView.numberOfItems(inSection: 0) > 0 {
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
                    self.moveToNext(index: 0)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.moveToNext(index: self.currentIndex, animated: false)
            if self.collectionView.numberOfItems(inSection: 0) > 0 {
                self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .left, animated: false)
                self.moveToNext(index: 0)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func setupNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    func setView() {
        let rightBarImage = UIBarButtonItem(image: UIImage(named: "NotificationIcon"), style: .plain, target: self, action: #selector(notificationButton))
        Helper.getInstance.setNavigationBar(leftBarItem: nil, rightBarItem: rightBarImage, title: "Home", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        
        collectionView.layer.cornerRadius = 5
        searchView.layer.cornerRadius = 5
        searchView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        searchView.layer.shadowOpacity = 1
        searchView.layer.shadowOffset = .zero
        searchView.layer.shadowRadius = 5
        filterView.layer.cornerRadius = 5
        searchField.delegate = self
        searchField.setLeftPaddingPoints(10)
        searchField.setRightPaddingPoints(10)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.collectionView.register(UINib.init(nibName: "BarberShopCell",
                                                bundle: nil),
                                     forCellWithReuseIdentifier: "BarberShopCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
        self.collectionView.isPagingEnabled = false
        self.collectionView.bounces = false
        reloadData()
    }
    
    @objc func notificationButton() {
        let vc : CustomerNotificationView = AppRouter.instantiateViewController(storyboard: .Customernotification)
        self.route(to: vc, navigation: .push)
    }
    
    func moveToNext(index: Int, animated: Bool = true){
        if barbers.count != 0 && index < barbers.count {
            let thisBarbersLocation = CLLocationCoordinate2D(latitude: Double(barbers[index].latitude ?? "0") ?? 0, longitude: Double(barbers[index].longitude ?? "0") ?? 0)
            currentIndex = index
            mapSetup(forLocation: thisBarbersLocation)
        }
    }
    
    func clearBarbersList() {
        self.barbers.removeAll()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            
        }
    }
    
    func getData() {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined || authStatus == .denied {
            if let long = UserPreferences.userModel?.longitude, let lat = UserPreferences.userModel?.latitude {
                clearBarbersList()
                (viewModel as! HomeViewModel).getBarbers(offset: 1, longitude: long, latitude: lat, radius: nil, rating: nil, services: nil)
            }
        } else {
            clearBarbersList()
            (viewModel as! HomeViewModel).getBarbers(offset: 1, longitude: self.long, latitude: self.lat, radius: nil, rating: nil, services: nil)
        }
        hasTriedOnce = true
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.moveToNext(index: self.currentIndex, animated: false)
            self.collectionView.reloadData()
        }
    }
    
    func updateLocationName(coordinates: CLLocationCoordinate2D) {
        let gmsGeocoder = GMSGeocoder()
        viewModel.isLoading = true
        gmsGeocoder.reverseGeocodeCoordinate(coordinates, completionHandler: {
            response, error in
            if error == nil {
                if let places = response?.results() {
                    if let place = places.first, place.lines?.count > 0 {
                        self.searchField.text = place.lines?[0] ?? ""
                    }
                }
            }
            self.viewModel.isLoading = false
        })
    }
    
    @IBAction func filterBtnAction(_ sender : UIButton) {
        let vc : HomeFilterView = AppRouter.instantiateViewController(storyboard: .home)
        vc.selectedServices = self.selectedServices
        vc.selectedRating = self.selectedRating
        vc.selectedRadius = self.selectedRadius
        vc.didInteractWithRadius = self.didInteractWithRadius
        vc.didInteractWithRating = self.didInteractWithRating
        vc.applyFilterCallback = { [weak self] params in
            guard let self = self else {
                return
            }
            self.didFilter = true
            self.selectedServices = params["services"] as? [String] ?? [String]()
            self.selectedRating = params["rating"] as? Double
            self.selectedRadius = params["radius"] as? Double
            self.didInteractWithRadius = params["didInteractWithRadius"] as? Bool ?? false
            self.didInteractWithRating = params["didInteractWithRating"] as? Bool ?? false
            if self.selectedRadius == 0 && self.selectedRating == 0 && self.selectedServices.count == 0 {
                self.didFilter = false
                (self.viewModel as! HomeViewModel).getBarbers(offset: 1, longitude: self.long, latitude: self.lat, radius: nil, rating: nil, services: nil)
            } else {
                (self.viewModel as! HomeViewModel).getBarbers(offset: 1, longitude: self.long, latitude: self.lat, radius: self.selectedRadius, rating: self.selectedRating, services: self.selectedServices)
            }
        }
        
        self.route(to: vc, navigation: .push)
    }
}

extension HomeView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return barbers.count == 0 ? (viewModel.isLoading || !hasTriedOnce ? 0 : 1) : barbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarberShopCell", for: indexPath) as! BarberShopCell
        if barbers.count != 0 {
            let data = barbers[indexPath.row]
            cell.shopName.text = data.name
            cell.bgView.backgroundColor = .white
            cell.shopAddress.text = data.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
            cell.shopImage.sd_setImage(with: URL(string: data.imageUrl ?? ""), completed: nil)
            let rating = data.averageRating ?? 0.0
            cell.ratingLbl.text = String(format: rating == 0 ? "%.1f" : "%.2f", rating)
            cell.noBarberView.isHidden = true
            if indexPath.row == barbers.count - 1 && barbers.count > 8 {
                cell.viewAll.isHidden = false
                cell.viewAllText.isHidden = false
            } else {
                cell.viewAll.isHidden = true
                cell.viewAllText.isHidden = true
            }
        } else {
            cell.viewAll.isHidden = true
            cell.viewAllText.isHidden = true
            cell.bgView.backgroundColor = .clear
            cell.noBarberView.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard barbers.count > 0 else {
            return
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? BarberShopCell {
            if cell.viewAll.isHidden && cell.noBarberView.isHidden {
                let vc : CustomerBarberMyProfileView = AppRouter.instantiateViewController(storyboard: .Customerbarberprofile)
                vc.profileUpdateCallback = { [weak self] barberProfile in
                    guard let self = self else {
                        return
                    }
                    self.barbers[indexPath.row] = barberProfile
                    self.collectionView.reloadData()
                }
                vc.barberProfile = barbers[indexPath.row]
                self.route(to: vc, navigation: .push)
            } else {
                let vc : HomeBarberListingView = AppRouter.instantiateViewController(storyboard: .home)
                vc.address = searchField.text ?? ""
                vc.barbers = self.barbers
                vc.lastPage = self.lastPage
                vc.loadedOnce = true
                vc.delegate = self
                vc.selectedRadius = selectedRadius
                vc.selectedRating = selectedRating
                vc.selectedServices = selectedServices
                vc.currentLocation = currentLocation
                vc.didFilter = didFilter
                vc.changeFilterCallback = { [weak self] params in
                    guard let self = self else {
                        return
                    }
                    self.selectedServices = params["services"] as? [String] ?? [String]()
                    self.selectedRating = params["rating"] as? Double ?? 0
                    self.selectedRadius = params["radius"] as? Double ?? 0
                    if self.selectedRadius == 0 && self.selectedRating == 0 && self.selectedServices.count == 0 {
                        self.didFilter = false
                    } else {
                        self.didFilter = true
                    }
                }
                self.route(to: vc, navigation: .push)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize!
        if barbers.count == 0 {
            size = CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height - 20)
        } else {
            size = CGSize.init(width: collectionView.frame.width - 40, height: collectionView.frame.height)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension HomeView: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellSize = CGSize(width: collectionView.frame.width - 40, height: collectionView.frame.height)
        let spacing = CGFloat(20.0)
        let itemWidth = cellSize.width + spacing
        let inertialTargetX = targetContentOffset.pointee.x
        let offsetFromPreviousPage = (inertialTargetX + collectionView.contentInset.left).truncatingRemainder(dividingBy: itemWidth)
        
        // snap to the nearest page
        let pagedX: CGFloat
        if offsetFromPreviousPage > itemWidth / 2 {
            pagedX = inertialTargetX + (itemWidth - offsetFromPreviousPage)
        } else {
            pagedX = inertialTargetX - offsetFromPreviousPage
        }
        let newIndex = Int(pagedX / itemWidth)
        if newIndex < barbers.count {
            self.moveToNext(index: newIndex)
        }
        let point = CGPoint(x: pagedX, y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
}

extension HomeView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.canBeConverted(to: String.Encoding.ascii){
            return false
        }
        
        let maxLength = 30
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

//MARK: LocationPickerTapped

extension HomeView {
    
    @IBAction func currentLocationTapped() {
        
        guard locManager.location != nil else {
            return
        }
        let location = locManager.location
        currentLocation = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        self.clearBarbersList()
        (viewModel as! HomeViewModel).getBarbers(offset: 1, longitude: String(currentLocation?.longitude ?? 0), latitude: String(currentLocation?.latitude ?? 0), radius: self.selectedRadius, rating: self.selectedRating, services: self.selectedServices)
        let gmsGeocoder = GMSGeocoder()
        
        gmsGeocoder.reverseGeocodeCoordinate(currentLocation!, completionHandler: {
            response, error in
            if error == nil {
                if let places = response?.results() {
                    if let place = places.first, place.lines?.count > 0 {
                        self.searchField.text = place.lines?[0] ?? ""
                    }
                }
            }
        })
    }
    
    @IBAction func locationPickerTapped() {
        let controller = PlacePicker.placePickerController()
        controller.delegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        self.show(navigationController, sender: nil)
    }
}

//MARK: PlacesPickerDelegate
extension HomeView: PlacesPickerDelegate {
    func placePickerControllerDidCancel(controller: PlacePickerController) {
        controller.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func placePickerController(controller: PlacePickerController, didSelectPlace place: GMSPlace) {
        let newLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        updateLocationName(coordinates: place.coordinate)
        currentLocation = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        clearBarbersList()
        (viewModel as! HomeViewModel).getBarbers(offset: 1, longitude: long, latitude: lat, radius: selectedRadius, rating: selectedRating, services: selectedServices)
        controller.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension HomeView: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !loadedOnce {
            loadedOnce = true
            guard let locValue: CLLocationCoordinate2D = locManager.location?.coordinate else {
                searchField.text = UserPreferences.userModel?.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
                currentLocation = CLLocationCoordinate2D(latitude: (Double(lat) ?? 0.0), longitude: (Double(long) ?? 0.0))
                updateLocationName(coordinates: currentLocation!)
                getData()
                return
            }
            currentLocation = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
            updateLocationName(coordinates: locValue)
            getData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if CLLocationManager.authorizationStatus() == .denied {
            if alert == nil || (alert != nil && alert.isBeingPresented) {
                locationAlert()
            }
        } else if CLLocationManager.authorizationStatus() == .notDetermined {
            setuplocationManager()
        }
    }
}

extension HomeView: HomeBarberListingViewDelegate {
    func setParams(barbers: [BarberModel], selectedServices: [String], selectedRating: Double?, selectedRadius: Double?, currentLocation: CLLocationCoordinate2D?, lastPage: Int, searchFieldText: String, didInteractWithRating: Bool, didInteractWithRadius: Bool) {
        if barbers.count < 11 {
            self.barbers = barbers
        } else {
            self.barbers = Array(barbers.prefix(10))
        }
        self.didInteractWithRating = didInteractWithRating
        self.didInteractWithRadius = didInteractWithRadius
        self.selectedServices = selectedServices
        self.selectedRating = selectedRating
        self.selectedRadius = selectedRadius
        self.currentLocation = currentLocation
        self.lastPage = lastPage
        self.searchField.text = searchFieldText
    }
}
