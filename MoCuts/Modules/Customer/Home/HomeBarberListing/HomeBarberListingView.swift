//
//  HomeBarberListingView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 03/08/2021.
//

import UIKit
import Foundation
import Helpers
import CommonComponents
import GoogleMaps
import GooglePlaces
import PlacesPicker
    
protocol HomeBarberListingViewDelegate: AnyObject {
    func setParams(barbers: [BarberModel], selectedServices: [String], selectedRating: Double?, selectedRadius: Double?, currentLocation: CLLocationCoordinate2D?, lastPage: Int, searchFieldText: String, didInteractWithRating: Bool, didInteractWithRadius: Bool)
}


class HomeBarberListingView: BaseView, Routeable {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchView : UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var searchField: UITextField!
    var refreshControl: UIRefreshControl!
    var page = 1
    var lastPage = 0
    var didInteractWithRating = false
    var didInteractWithRadius = false
    var barbers = [BarberModel]()
    var currentLocation: CLLocationCoordinate2D?
    var loadedOnce = false
    var address = ""
    var delegate: HomeBarberListingViewDelegate?
    var selectedServices = [String]()
    var selectedRating: Double?
    var selectedRadius: Double?
    var locManager = CLLocationManager()
    var changeFilterCallback: (([String:Any]) -> Void)?
    var didFilter = false
    var pageChanged = false
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
        
        // Do any additional setup after loading the view.
        setView()
        setuplocationManager()
        setTableView()
        setupViewModelObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.setParams(barbers: self.barbers, selectedServices: self.selectedServices, selectedRating: self.selectedRating, selectedRadius: self.selectedRadius, currentLocation: currentLocation, lastPage: self.lastPage, searchFieldText: searchField.text ?? "", didInteractWithRating: self.didInteractWithRating, didInteractWithRadius: self.didInteractWithRating)
    }
    
    func setupViewModelObserver() {
        viewModel = HomeViewModel()
        (viewModel as! HomeViewModel).successClosure = { [weak self] response in
            guard let self = self else {
                return
            }
            self.lastPage = response.lastPage ?? 0
            let newData = response.barbers ?? [BarberModel]()
            
            if self.lastPage != 0 {
                if response.barbers?.count > 0 && self.page < self.lastPage && self.pageChanged {
                    self.page += 1
                    self.pageChanged = false
                }
                
                if self.page == 1 {
                    self.barbers = newData
                } else {
                    self.barbers.append(contentsOf: newData)
                }
            } else {
                self.page = response.page ?? 1
                if self.page == 1 {
                    self.barbers = newData
                } else {
                    self.barbers.append(contentsOf: newData)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
        searchField.text = address
        if !loadedOnce {
            loadedOnce = true
            removeNoDataLabelOnTableView(tableView: tableView)
            if didFilter {
                (viewModel as! HomeViewModel).getBarbers(offset: self.page, longitude: self.long, latitude: self.lat, radius: selectedRadius, rating: selectedRating, services: selectedServices)
            } else {
                (viewModel as! HomeViewModel).getBarbers(offset: self.page, longitude: self.long, latitude: self.lat, radius: nil, rating: nil, services: nil)
            }
        }
    }
    
    func setuplocationManager() {
        self.locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
    }
    
    func setupNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    func setView() {
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            let rightBarImage = UIBarButtonItem(image: UIImage(named: "NotificationIcon"), style: .plain, target: self, action: #selector(notificationButton))
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: rightBarImage, title: "Barber's List", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
        
        searchView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        searchView.layer.shadowOpacity = 1
        searchView.layer.shadowOffset = .zero
        searchView.layer.shadowRadius = 5
        
        searchView.layer.cornerRadius = 5
        filterView.layer.cornerRadius = 5
        searchField.delegate = self
        searchField.setLeftPaddingPoints(10)
        searchField.setRightPaddingPoints(10)
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 123
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(handleRefreshControl),
                                    for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        tableView.register(UINib(nibName: "BarberListingTableViewCell", bundle: nil), forCellReuseIdentifier: "BarberListingTableViewCell")
    }
    
    @objc func handleRefreshControl() {
        barbers.removeAll()
        page = 1
        lastPage = 0

        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.removeNoDataLabelOnTableView(tableView: self.tableView)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if self.didFilter {
                (self.viewModel as! HomeViewModel).getBarbers(offset: self.page, longitude: self.long, latitude: self.lat, radius: self.selectedRadius, rating: self.selectedRating, services: self.selectedServices)
            } else {
                (self.viewModel as! HomeViewModel).getBarbers(offset: self.page, longitude: self.long, latitude: self.lat, radius: nil, rating: nil, services: nil)
            }
        })
    }
    
    @objc func notificationButton() {
        let vc : CustomerNotificationView = AppRouter.instantiateViewController(storyboard: .Customernotification)
                self.route(to: vc, navigation: .push)
    }
    
    func clearBarbersList() {
        self.barbers.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
    }
    
    @IBAction func filterBtnAction(_ sender : UIButton) {
        let vc : HomeFilterView = AppRouter.instantiateViewController(storyboard: .home)
        vc.selectedServices = self.selectedServices
        vc.selectedRating = self.selectedRating
        vc.selectedRadius = self.selectedRadius
        vc.didInteractWithRating = self.didInteractWithRating
        vc.didInteractWithRadius = self.didInteractWithRadius
        vc.applyFilterCallback = { [weak self] params in
            guard let self = self else {
                return
            }
            self.didFilter = true
            let newFilterSvcs = params["services"] as? [String] ?? [String]()
            let newFilterRating = params["rating"] as? Double ?? 0
            let newFilterRadius = params["radius"] as? Double ?? 0
            
            var newParams = params
            self.removeNoDataLabelOnTableView(tableView: self.tableView)
            if newFilterSvcs != self.selectedServices || newFilterRating != self.selectedRating || newFilterRadius != self.selectedRadius {
                self.changeFilterCallback?(newParams)
            }
            self.selectedServices = params["services"] as? [String] ?? [String]()
            self.didInteractWithRadius = params["didInteractWithRadius"] as? Bool ?? false
            self.didInteractWithRating = params["didInteractWithRating"] as? Bool ?? false
            self.selectedRating = params["rating"] as? Double
            self.selectedRadius = params["radius"] as? Double
            if self.selectedRadius == 0 && self.selectedRating == 0 && self.selectedServices.count == 0 {
                self.didFilter = false
                (self.viewModel as! HomeViewModel).getBarbers(offset: 1, longitude: self.long, latitude: self.lat, radius: nil, rating: nil, services: nil)
            } else {
                self.changeFilterCallback?(newParams)
                (self.viewModel as! HomeViewModel).getBarbers(offset: 1, longitude: self.long, latitude: self.lat, radius: self.selectedRadius, rating: self.selectedRating, services: self.selectedServices)
            }
        }
        
        self.route(to: vc, navigation: .push)
    }
    
    @IBAction func currentLocationTapped() {
        if let location = locManager.location {
            currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.clearBarbersList()
            removeNoDataLabelOnTableView(tableView: tableView)
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
    }
    
    @IBAction func locationPickerTapped() {
        let controller = PlacePicker.placePickerController()
        controller.delegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        self.show(navigationController, sender: nil)
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
    func getData() {
        removeNoDataLabelOnTableView(tableView: tableView)
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
    }
}

extension HomeBarberListingView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = barbers.count
        if count == 0 && !viewModel.isLoading {
            showNoDataLabelOnTableView(tableView: tableView, customText: "No barber(s) found near you!", image: "BarberShop")
        } else {
            removeNoDataLabelOnTableView(tableView: tableView)
        }
        return barbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarberListingTableViewCell", for: indexPath) as! BarberListingTableViewCell

        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            let data = self.barbers[indexPath.row]
            let rating = data.averageRating ?? 0.0
            let imgUrl = data.imageUrl ?? ""
            cell.shopName.text = data.name
            cell.shopAddress.text = data.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
            cell.shopImage.sd_setImage(with: URL(string: imgUrl), completed: nil)
            
            cell.ratingLbl.text = String(format: rating == 0 ? "%.1f" : "%.2f", rating)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == barbers.count - 1 {
            
            if page < lastPage {
                var newPage = page
                if lastPage != 0 {
                    newPage = page + 1
                    if newPage > lastPage {
                        return
                    }
                }
                removeNoDataLabelOnTableView(tableView: tableView)
                pageChanged = true
                if didFilter {
                    (viewModel as! HomeViewModel).getBarbers(offset: newPage, longitude: long, latitude: lat, radius: selectedRadius, rating: selectedRating, services: selectedServices)
                } else {
                    (viewModel as! HomeViewModel).getBarbers(offset: newPage, longitude: long, latitude: lat, radius: nil, rating: nil, services: nil)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : CustomerBarberMyProfileView = AppRouter.instantiateViewController(storyboard: .Customerbarberprofile)
        vc.barberProfile = barbers[indexPath.row]
        vc.profileUpdateCallback = { [weak self] barberProfile in
            guard let self = self else {
                return
            }
            self.barbers[indexPath.row] = barberProfile
            self.tableView.reloadData()
        }
        self.route(to: vc, navigation: .push)
    }
}


extension HomeBarberListingView : UITextFieldDelegate {
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

//MARK: PlacesPickerDelegate
extension HomeBarberListingView: PlacesPickerDelegate {
    func placePickerControllerDidCancel(controller: PlacePickerController) {
        controller.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func placePickerController(controller: PlacePickerController, didSelectPlace place: GMSPlace) {
        let newLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)

        updateLocationName(coordinates: place.coordinate)
        currentLocation = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        clearBarbersList()
        removeNoDataLabelOnTableView(tableView: tableView)
        (viewModel as! HomeViewModel).getBarbers(offset: 1, longitude: long, latitude: lat, radius: nil, rating: nil, services: nil)
        controller.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension HomeBarberListingView: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !loadedOnce {
            loadedOnce = true
            guard let locValue: CLLocationCoordinate2D = locManager.location?.coordinate else {
                searchField.text = UserPreferences.userModel?.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
                currentLocation = CLLocationCoordinate2D(latitude: (Double(lat) ?? 0.0), longitude: (Double(long) ?? 0.0))
                
                updateLocationName(coordinates: currentLocation!)
                getData()
                return }
            currentLocation = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
            updateLocationName(coordinates: locValue)
            getData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if CLLocationManager.authorizationStatus() == .denied {
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
        } else {
            
        }
    }
}
