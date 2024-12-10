//
//  HomeFilterView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 23/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import GoogleMaps
import Cosmos
import RangeSeekSlider

class HomeFilterView: BaseView, Routeable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var applyFilter : MoCutsAppButton!
    @IBOutlet weak var collectionViewHeight : NSLayoutConstraint!
    @IBOutlet weak var cosmosView : CosmosView!
    @IBOutlet weak var ratingText : UILabel!
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    @IBOutlet weak var distanceText: UILabel!
    var didInteractWithRating = false
    var didInteractWithRadius = false
    var selectedRating: Double?
    var selectedRadius: Double?
    var selectedServices = [String]()
    var applyFilterCallback: (([String:Any]) -> Void)?
    var filterServices: [FilterServices] = []
    var iPhoneXorLaterFamily : [String] = ["iPhone10,3","iPhone10,6","iPhone11,2","iPhone11,4","iPhone11,6","iPhone11,8","iPhone12,1","iPhone12,3","iPhone12,5","iPhone12,8","iPhone13,1","iPhone13,2","iPhone13,3","iPhone13,4"]
    var cellHeight : CGFloat = 0
    var xFamily : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        setupViewModel()
        setupRatingListener()
        setupSlider()
        
        for i in iPhoneXorLaterFamily {
            print(i)
            if UIDevice.current.modelName == i {
                xFamily = true
                break
            } else {
                xFamily = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setView()
        self.setButton()
        self.setupCollectionView()
        rangeSlider.selectedMaxValue = CGFloat(selectedRadius ?? 0.0)
        self.distanceText.text = "\(rangeSlider.selectedMaxValue) Miles"
        cosmosView.rating = selectedRating ?? 0.0
        self.ratingText.text = "\(cosmosView.rating) Rating"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadCollectionViewMethod()
    }
    
    func initialSetup() {
        cosmosView.rating = 4.0
        self.ratingText.text = "4.0 Rating"
        cosmosView.settings.fillMode = .half
        setMinimumStarsForRatingView(stars: 0)
    }
    
    func setupViewModel() {
        viewModel = HomeFilterViewModel()
        setServices()
        
        (viewModel as! HomeFilterViewModel).getServices()
    }
    
    func setupRatingListener() {
        cosmosView.didFinishTouchingCosmos = { [weak self] rating in
            guard let self = self else {
                return
            }
            self.didInteractWithRating = true
            self.ratingText.text = "\(rating) Rating"
        }
    }
    
    func setServices() {
        (viewModel as! HomeFilterViewModel).onServicesRetrieval = { [weak self] services in
            guard let self = self else {
                return
            }
            self.filterServices.removeAll()
            for service in services {
                var newService = FilterServices(serviceName: service.name ?? "", isSelected: false)
                if self.selectedServices.contains(newService.serviceName) {
                    newService.isSelected = true
                }
                self.filterServices.append(newService)
            }
            self.reloadCollectionViewMethod()
        }
    }
    
    func setMinimumStarsForRatingView(stars: Double) {
        var newSettings = cosmosView.settings
        newSettings.minTouchRating = stars
        cosmosView.settings = newSettings
    }
    
    func setupSlider() {
        rangeSlider.delegate = self
        rangeSlider.disableRange = true
        rangeSlider.selectedMaxValue = 0.0
        rangeSlider.minValue = 0.0
        rangeSlider.maxValue = 100.0
        rangeSlider.setNeedsLayout()
    }
    
    func setButton() {
        self.applyFilter.buttonColor = .orange
        self.applyFilter.setText(text: "Apply Filter")
        self.applyFilter.setAction(actionP: {[weak self] in
            guard let self = self else {
                return
            }
            var params = [String:Any]()
            
            params["radius"] = self.didInteractWithRadius ? Double(self.rangeSlider.selectedMaxValue) : nil
            params["rating"] = self.didInteractWithRating ? self.cosmosView.rating : nil
            var selectedServices = [String]()
            
            for i in 0..<self.filterServices.count {
                if self.filterServices[i].isSelected {
                    selectedServices.append(self.filterServices[i].serviceName)
                }
            }
            params["didInteractWithRadius"] = self.didInteractWithRadius
            params["didInteractWithRating"] = self.didInteractWithRating
            params["services"] = selectedServices
            self.applyFilterCallback?(params)
            
            self.routeBack(navigation: .pop)
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
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
            let rightBarImage = UIBarButtonItem(image: UIImage(named: "ResetTextIcon"), style: .plain, target: self, action: #selector(resetFilterAction))
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: rightBarImage, title: "Filter", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
            searchView.layer.cornerRadius = 5
            searchView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
            searchView.layer.shadowOpacity = 1
            searchView.layer.shadowOffset = .zero
            searchView.layer.shadowRadius = 5
            searchField.delegate = self
            searchField.setLeftPaddingPoints(10)
            searchField.setRightPaddingPoints(10)
            searchField.text = ""
            searchField.isUserInteractionEnabled = true
        }
    }
    
    func reloadCollectionViewMethod() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.collectionViewHeight.constant = height
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupCollectionView(){
        self.collectionView.register(UINib.init(nibName: "FilterServiceCell",
                                                bundle: nil),
                                     forCellWithReuseIdentifier: "FilterServiceCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isScrollEnabled = false
        
        let alignedFlowLayout = collectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .top
        alignedFlowLayout?.minimumInteritemSpacing = 10
    }
    
    @objc func resetFilterAction() {
        cosmosView.rating = 0.0
        rangeSlider.selectedMaxValue = 0.0
        rangeSlider.setNeedsLayout()
        didInteractWithRadius = false
        didInteractWithRating = false
        ratingText.text = "0.0 Rating"
        distanceText.text = "0.0 Miles"
        searchField.text = ""
        for i in 0..<filterServices.count {
            filterServices[i].isSelected = false
        }
    
//        setupSlider()
        reloadCollectionViewMethod()
    }
}

extension HomeFilterView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterServiceCell", for: indexPath) as! FilterServiceCell
        cell.serviceName.text = filterServices[indexPath.row].serviceName
        if filterServices[indexPath.row].isSelected {
            cell.mainView.backgroundColor = Theme.appOrangeColor
            cell.serviceName.textColor = .white
        } else {
            cell.mainView.backgroundColor = .clear
            cell.serviceName.textColor = Theme.appNavigationBlueColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if filterServices[indexPath.row].isSelected {
            filterServices[indexPath.row].isSelected = false
        } else {
            filterServices[indexPath.row].isSelected = true
        }
        reloadCollectionViewMethod()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let item = filterServices[indexPath.row].serviceName
//        return CGSize(width: item.size(withAttributes: [NSAttributedString.Key.font : Theme.getAppFont(withSize: 15)]).width + 50, height: 40)
        if xFamily {
            return CGSize(width: 110, height: 40)
        } else {
            return CGSize(width: CGFloat((collectionView.frame.width - 20)/3), height: 40)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        // splace between two cell horizonatally
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        // splace between two cell vertically
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        // give space top left bottom and right for cells
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension HomeFilterView : UITextFieldDelegate {
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

extension HomeFilterView : RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSlider {
//            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
//            var difference = maxValue - minValue
            self.didInteractWithRadius = true
            self.distanceText.text = "\(maxValue) Miles"
        }
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}

struct FilterServices {
    var serviceName : String
    var isSelected : Bool
}

