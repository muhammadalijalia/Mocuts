//
//  CustomerBarberMyProfileView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 25/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class CustomerBarberMyProfileView : BaseView, Routeable {
    
    enum CustomerGradientView {
        case navView
        case profileView
    }
    
    enum CustomerContainerViewController {
        case about
        case service
        case gallery
        case reviews
    }
    
    @IBOutlet weak var navView : UIView!
    @IBOutlet weak var profileDetailView : UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var aboutTab : UIView!
    @IBOutlet weak var aboutText : UILabel!
    @IBOutlet weak var serviceTab : UIView!
    @IBOutlet weak var serviceText : UILabel!
    @IBOutlet weak var galleryTab : UIView!
    @IBOutlet weak var galleryText : UILabel!
    @IBOutlet weak var reviewTab : UIView!
    @IBOutlet weak var reviewText : UILabel!

    @IBOutlet var barberName: UILabel!
    @IBOutlet var barberAddress: UILabel!
    @IBOutlet var barberRatingAndReviews: UILabel!
    @IBOutlet var barberProfilePicture: UIImageView!
    
    let gradientLayerProfile = CAGradientLayer()
    let gradientLayerNav = CAGradientLayer()
    var gradientSetNav = [[CGColor]]()
    var gradientSetProfile = [[CGColor]]()
    var currentGradientNav: Int = 0
    var currentGradientProfile: Int = 0
    var gradientView : CustomerGradientView = .navView
    var containerViewController : CustomerContainerViewController = .about
    var reportTypes = [ReportType]()
    var barberProfile: BarberModel!
    var profileUpdateCallback: ((BarberModel) -> Void)?
    
    private lazy var customerBarberAboutView: CustomerBarberAboutView = {
        
        var viewController = storyboard!.instantiateViewController(withIdentifier: "CustomerBarberAboutView") as! CustomerBarberAboutView
        viewController.delegate = self
        viewController.barberAboutDescription = barberProfile.about ?? ""
        let storyboard = UIStoryboard(name: "Customerbarberprofile", bundle: Bundle.main)
        self.addChild(viewController)
        return viewController
    }()
    
    private lazy var customerBarberGalleryView: CustomerBarberGalleryView = {
        
        var viewController = storyboard!.instantiateViewController(withIdentifier: "CustomerBarberGalleryView") as! CustomerBarberGalleryView
        viewController.barberId = barberProfile.id ?? 0
        let storyboard = UIStoryboard(name: "Customerbarberprofile", bundle: Bundle.main)
        self.addChild(viewController)
        return viewController
    }()
    
    private lazy var customerBarberReviewView: CustomerBarberReviewView = {
        
        var viewController = storyboard!.instantiateViewController(withIdentifier: "CustomerBarberReviewView") as! CustomerBarberReviewView
        viewController.barberId = barberProfile.id ?? 0
        let storyboard = UIStoryboard(name: "Customerbarberprofile", bundle: Bundle.main)
        self.addChild(viewController)
        return viewController
    }()
    
    private lazy var customerBarberServiceView: CustomerBarberServiceView = {
        // Load Storyboard
        var viewController = storyboard!.instantiateViewController(withIdentifier: "CustomerBarberServiceView") as! CustomerBarberServiceView
        viewController.barberProfile = self.barberProfile
        var storyboard = UIStoryboard(name: "Customerbarberprofile", bundle: Bundle.main)
        self.addChild(viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAboutHighlighted()
        viewModel = CustomerBarberServiceViewModel()
        (self.viewModel as! CustomerBarberServiceViewModel).getReportTypes()
        setBarberData()
        setOnReportTypes()
    }
    
    func setOnReportTypes() {
        (viewModel as! CustomerBarberServiceViewModel).setReportTypes = { [weak self] response in
            guard let self = self else {
                return
            }
            self.reportTypes = response
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setView()
        barberName.text = barberProfile.name
        barberAddress.text = barberProfile.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ") ?? ""
        barberRatingAndReviews.text = "\(String(format: "%.2f", barberProfile.averageRating ?? 0.0)) (\(barberProfile.totalReviews ?? 0) Reviews)"
        barberProfilePicture.sd_setImage(with: URL(string: (barberProfile.imageUrl ?? "")), completed: nil)
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.addAnimatingGradient(view: .navView)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.addAnimatingGradient(view: .profileView)
        }
        self.aboutTab.layer.cornerRadius = 5
        self.serviceTab.layer.cornerRadius = 5
        self.galleryTab.layer.cornerRadius = 5
        self.reviewTab.layer.cornerRadius = 5
    }
    
    private func addAnimatingGradient(view : CustomerGradientView) {
        if view == .navView {
            self.navView.backgroundColor = UIColor.clear
            let gradientOne = UIColor.black.withAlphaComponent(0.7).cgColor
            let gradientTwo = UIColor.clear.cgColor
            gradientSetNav.append([gradientOne, gradientTwo])
            gradientLayerNav.frame = self.navView.bounds
            gradientLayerNav.colors = gradientSetNav[currentGradientNav]
            gradientLayerNav.locations = [0.0, 1.0]
            gradientLayerNav.drawsAsynchronously = true
            self.navView.layer.insertSublayer(gradientLayerNav, at :0)
        } else if view == .profileView {
            self.profileDetailView.backgroundColor = UIColor.clear
            let gradientOne = UIColor.black.withAlphaComponent(0.7).cgColor
            let gradientTwo = UIColor.clear.cgColor
            gradientSetProfile.append([gradientTwo, gradientOne])
            gradientLayerProfile.frame = self.profileDetailView.bounds
            gradientLayerProfile.colors = gradientSetProfile[currentGradientProfile]
            gradientLayerProfile.locations = [0.0, 1.0]
            gradientLayerProfile.drawsAsynchronously = true
            self.profileDetailView.layer.insertSublayer(gradientLayerProfile, at :0)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func setBarberData() {
        (viewModel as! CustomerBarberServiceViewModel).setBarberData = { [weak self] barber in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                let barberObj = barber.data
                self.customerBarberAboutView.barberAboutDescription = barber.data?.about ?? ""
                
                self.barberProfile.about = barber.data?.about ?? ""
                self.barberProfile.name = barberObj?.name ?? ""
                self.barberProfile.address = barberObj?.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
                self.barberProfile.averageRating = barberObj?.average_rating
                self.barberProfile.totalReviews = barberObj?.total_reviews
                
                self.barberName.text = barberObj?.name ?? ""
                self.barberAddress.text = barberObj?.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
                let avgRating = barberObj?.average_rating ?? 0.0
                let rating = String(format: avgRating == 0 ? "%.1f" : "%.2f", avgRating)
                self.barberRatingAndReviews.text = "\(rating) (\(barberObj?.total_reviews ?? 0) Reviews)"
                
                self.barberProfilePicture.sd_setImage(with: URL(string: barberObj?.image_url ?? ""), placeholderImage: UIImage())
                self.profileUpdateCallback?(self.barberProfile)
            }
        }
        (viewModel as! CustomerBarberServiceViewModel).setBarberFailure = { [weak self] error in
            guard let self = self else {
                return
            }
            self.customerBarberAboutView.barberAboutDescription = ""
        }
    }
    
    @IBAction func reportBtnAction(_ sender : UIButton) {
        let attributedString = NSAttributedString(string: "Report Profile", attributes: [
            NSAttributedString.Key.font : Theme.getAppMediumFont(withSize: 18),
            NSAttributedString.Key.foregroundColor : UIColor.black
        ])
        
        let alert = UIAlertController(title: "Report Profile", message: nil, preferredStyle: .actionSheet)
        let subview = alert.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertContentView.layer.cornerRadius = 15
        
        alert.view.tintColor = Theme.appOrangeColor
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        for reportType in reportTypes {
            alert.addAction(UIAlertAction(title: reportType.name, style: .default, handler: { action in
                
                for reportType in self.reportTypes {
                    if reportType.name == action.title {
                        
                        (self.viewModel as! CustomerBarberServiceViewModel).sendReport(toId: String(self.barberProfile.id ?? 0), reportTypeId: String(reportType.id ?? 0), message: "Reported")
                    }
                }
            }))
        }
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
    // Add Child View Controller
        addChild(viewController)
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
    // Notify Child View Controller
        viewController.willMove(toParent: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParent()
    }

    private func updateView() {
        DispatchQueue.main.async {
            if self.containerViewController == .about {
                self.remove(asChildViewController: self.customerBarberGalleryView)
                self.remove(asChildViewController: self.customerBarberServiceView)
                self.remove(asChildViewController: self.customerBarberReviewView)
                self.add(asChildViewController: self.customerBarberAboutView)
            } else if self.containerViewController == .service {
                self.remove(asChildViewController: self.customerBarberGalleryView)
                self.remove(asChildViewController: self.customerBarberAboutView)
                self.remove(asChildViewController: self.customerBarberReviewView)
                self.add(asChildViewController: self.customerBarberServiceView)
            } else if self.containerViewController == .gallery {
                self.remove(asChildViewController: self.customerBarberAboutView)
                self.remove(asChildViewController: self.customerBarberServiceView)
                self.remove(asChildViewController: self.customerBarberReviewView)
                self.add(asChildViewController: self.customerBarberGalleryView)
            } else if self.containerViewController == .reviews {
                self.remove(asChildViewController: self.customerBarberGalleryView)
                self.remove(asChildViewController: self.customerBarberServiceView)
                self.remove(asChildViewController: self.customerBarberAboutView)
                self.add(asChildViewController: self.customerBarberReviewView)
            }
        }
    }
    
    @IBAction func aboutBtn(_ sender: UIButton) {
        setAboutHighlighted()
    }

    @IBAction func serviceBtn(_ sender: UIButton) {
        setServiceHighlighted()
    }
    
    @IBAction func galleryBtn(_ sender: UIButton) {
        setGalleryHighighted()
    }
    
    @IBAction func reviewBtn(_ sender: UIButton) {
        setReviewHighighted()
    }
    
    func setAboutHighlighted() {
        containerViewController = .about
        aboutTab.backgroundColor = UIColor(hex: "#FFF3F2")
        aboutText.textColor = Theme.appOrangeColor
        serviceTab.backgroundColor = .clear
        serviceText.textColor = UIColor(hex: "#666666")
        galleryTab.backgroundColor = .clear
        galleryText.textColor = UIColor(hex: "#666666")
        reviewTab.backgroundColor = .clear
        reviewText.textColor = UIColor(hex: "#666666")
        updateView()
    }
    
    func setServiceHighlighted() {
        containerViewController = .service
        serviceTab.backgroundColor = UIColor(hex: "#FFF3F2")
        serviceText.textColor = Theme.appOrangeColor
        aboutTab.backgroundColor = .clear
        aboutText.textColor = UIColor(hex: "#666666")
        galleryTab.backgroundColor = .clear
        galleryText.textColor = UIColor(hex: "#666666")
        reviewTab.backgroundColor = .clear
        reviewText.textColor = UIColor(hex: "#666666")
        updateView()
    }
    
    func setGalleryHighighted() {
        containerViewController = .gallery
        galleryTab.backgroundColor = UIColor(hex: "#FFF3F2")
        galleryText.textColor = Theme.appOrangeColor
        serviceTab.backgroundColor = .clear
        serviceText.textColor = UIColor(hex: "#666666")
        aboutTab.backgroundColor = .clear
        aboutText.textColor = UIColor(hex: "#666666")
        reviewTab.backgroundColor = .clear
        reviewText.textColor = UIColor(hex: "#666666")
        updateView()
    }
    
    func setReviewHighighted() {
        containerViewController = .reviews
        reviewTab.backgroundColor = UIColor(hex: "#FFF3F2")
        reviewText.textColor = Theme.appOrangeColor
        serviceTab.backgroundColor = .clear
        serviceText.textColor = UIColor(hex: "#666666")
        galleryTab.backgroundColor = .clear
        galleryText.textColor = UIColor(hex: "#666666")
        aboutTab.backgroundColor = .clear
        aboutText.textColor = UIColor(hex: "#666666")
        updateView()
    }
}

//MARK: CustomerBarberAboutViewDelegate
extension CustomerBarberMyProfileView : CustomerBarberAboutViewDelegate {
    func refreshData() {
        (viewModel as! CustomerBarberServiceViewModel).getBarberByID(barberID: self.barberProfile.id ?? 0)
    }
}
