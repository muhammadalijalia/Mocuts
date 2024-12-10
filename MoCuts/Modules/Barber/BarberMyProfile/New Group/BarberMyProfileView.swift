//
//  BarberMyProfileView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 11/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import SDWebImage
import Lightbox

class BarberMyProfileView : BaseView, Routeable {
    
    enum GradientView {
        case navView
        case profileView
    }
    
    enum ContainerViewController {
        case about
        case service
        case timeSlot
        case reviews
    }
    
    @IBOutlet weak var navView : UIView!
    @IBOutlet weak var profileDetailView : UIView!
    @IBOutlet weak var editProfileBtn : UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var aboutTab : UIView!
    @IBOutlet weak var aboutText : UILabel!
    @IBOutlet weak var serviceTab : UIView!
    @IBOutlet weak var serviceText : UILabel!
    @IBOutlet weak var timeSlotTab : UIView!
    @IBOutlet weak var timeSlotText : UILabel!
    @IBOutlet weak var reviewTab : UIView!
    @IBOutlet weak var reviewText : UILabel!
    @IBOutlet weak var barberName : UILabel!
    @IBOutlet weak var barberAddress : UILabel!
    @IBOutlet weak var barberRating : UILabel!
    @IBOutlet weak var barberProfileImage : UIImageView!
    
    let gradientLayerProfile = CAGradientLayer()
    let gradientLayerNav = CAGradientLayer()
    var gradientSetNav = [[CGColor]]()
    var gradientSetProfile = [[CGColor]]()
    var currentGradientNav: Int = 0
    var currentGradientProfile: Int = 0
    var gradientView : GradientView = .navView
    var containerViewController : ContainerViewController = .about
    var barberProfile : GenericResponse<User_Model>?
    
    private lazy var barberAboutView: BarberAboutView = {
        
        var viewController = storyboard!.instantiateViewController(withIdentifier: "BarberAboutView") as! BarberAboutView
        viewController.delegate = self
        let storyboard = UIStoryboard(name: "Barberprofile", bundle: Bundle.main)
        self.addChild(viewController)
//        self.containerView.addSubview(viewController.view)
        return viewController
    }()
    
    private lazy var barberTimeSlotView: BarberTimeSlotView = {
        
        let viewController = storyboard!.instantiateViewController(withIdentifier: "BarberTimeSlotView") as! BarberTimeSlotView
        self.addChild(viewController)
        return viewController
    }()
    
    private lazy var barberReviewView: BarberReviewView = {
        
        var viewController = storyboard!.instantiateViewController(withIdentifier: "BarberReviewView") as! BarberReviewView
        viewController.delegate = self
        let storyboard = UIStoryboard(name: "Barberprofile", bundle: Bundle.main)
        self.addChild(viewController)
        return viewController
    }()
    
    private lazy var barberServiceView: BarberServiceView = {
        // Load Storyboard
        var viewController = storyboard!.instantiateViewController(withIdentifier: "BarberServiceView") as! BarberServiceView
        viewController.delegate = self
        var storyboard = UIStoryboard(name: "Barberprofile", bundle: Bundle.main)
        self.addChild(viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
        viewModel = BarberMyProfileViewModel()
        self.initialSetupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        if navigationController?.presentedViewController as? LightboxController == nil {
            (viewModel as! BarberMyProfileViewModel).getBarberByID()
            self.setBarberData()
        }
    }
    
    func refreshData() {
        (viewModel as! BarberMyProfileViewModel).getBarberByID()
    }
    
    func initialSetupView(){
        aboutTab.backgroundColor = UIColor(hex: "#FFF3F2")
        aboutText.textColor = Theme.appOrangeColor
        serviceTab.backgroundColor = .clear
        serviceText.textColor = UIColor(hex: "#666666")
        timeSlotTab.backgroundColor = .clear
        timeSlotText.textColor = UIColor(hex: "#666666")
        reviewTab.backgroundColor = .clear
        reviewText.textColor = UIColor(hex: "#666666")
    }
    
    func setView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.addAnimatingGradient(view: .navView)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.addAnimatingGradient(view: .profileView)
        }
        self.editProfileBtn.layer.cornerRadius = 5
        self.aboutTab.layer.cornerRadius = 5
        self.serviceTab.layer.cornerRadius = 5
        self.timeSlotTab.layer.cornerRadius = 5
        self.reviewTab.layer.cornerRadius = 5
    }
    
    func setBarberData() {
        (viewModel as! BarberMyProfileViewModel).setBarberData = { [weak self] barber in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                let barberObj = barber.data
                self.barberProfile = barber
                self.updateView()
                self.barberName.text = barberObj?.name ?? ""
                self.barberAddress.text = barberObj?.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
                let rating = barberObj?.average_rating ?? 0.0
                let ratingTxt = String(format: rating == 0 ? "%.1f" : "%.2f", rating)
                self.barberRating.text = "\(ratingTxt) (\(barberObj?.total_reviews ?? 0) Reviews)"
                self.barberProfileImage.sd_setImage(with: URL(string: barberObj?.image_url ?? ""), placeholderImage: UIImage())
            }
        }
    }
    
    private func addAnimatingGradient(view : GradientView) {
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
    
    @IBAction func notificationBtnAction(_ sender : UIButton) {
        let vc : BarberNotificationView = AppRouter.instantiateViewController(storyboard: .Barbernotification)
        self.route(to: vc, navigation: .push)
    }
    
    @IBAction func editProfileBtn(_ sender : UIButton) {
        let vc : BarberEditProfileView = AppRouter.instantiateViewController(storyboard: .Barberprofile)
        self.route(to: vc, navigation: .push)
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
                self.remove(asChildViewController: self.barberTimeSlotView ?? UIViewController())
                self.remove(asChildViewController: self.barberServiceView)
                self.remove(asChildViewController: self.barberReviewView)
                self.add(asChildViewController: self.barberAboutView)
                self.barberAboutView.barberModel = self.barberProfile
                self.barberAboutView.tableView.reloadData()
                self.barberAboutView.barberDescription = self.barberProfile?.data?.about ?? ""
            } else if self.containerViewController == .service {
                self.remove(asChildViewController: self.barberTimeSlotView ?? UIViewController())
                self.remove(asChildViewController: self.barberAboutView)
                self.remove(asChildViewController: self.barberReviewView)
                self.barberServiceView.barberObj = self.barberProfile?.data
                if self.barberServiceView.tableView != nil {
                    self.barberServiceView.tableView.reloadData()
                }
                self.add(asChildViewController: self.barberServiceView)
            } else if self.containerViewController == .timeSlot {
                self.remove(asChildViewController: self.barberAboutView)
                self.remove(asChildViewController: self.barberServiceView)
                self.remove(asChildViewController: self.barberReviewView)
                self.add(asChildViewController: self.barberTimeSlotView ?? UIViewController())

            } else if self.containerViewController == .reviews {
                self.remove(asChildViewController: self.barberTimeSlotView ?? UIViewController())
                self.remove(asChildViewController: self.barberServiceView)
                self.remove(asChildViewController: self.barberAboutView)
                self.add(asChildViewController: self.barberReviewView)
                self.barberReviewView.reviewsArray = self.barberProfile?.data?.reviews ?? []
                self.barberReviewView.reviewsArray.reverse()
                self.barberReviewView.reloadData()
                self.barberReviewView.reviewCountLabel.text = "Rating & Reviews (\(self.barberProfile?.data?.reviews?.count ?? 0))"
            }
        }
    }
    
    @IBAction func aboutBtn(_ sender: UIButton) {
        setAboutHighlighted()
    }
    
    @IBAction func serviceBtn(_ sender: UIButton) {
        setServiceHighlighted()
//        self.barberServiceView.barberServiceArray = self.barberProfile?.data?.services ?? []

    }
    
    @IBAction func timeSlotBtn(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Barberprofile", bundle: Bundle.main)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "BarberTimeSlotView") as! BarberTimeSlotView
//        self.barberTimeSlotView = viewController
//        self.addChild(self.barberTimeSlotView ?? UIViewController())
        
        setTimeSlotHighighted()
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
        timeSlotTab.backgroundColor = .clear
        timeSlotText.textColor = UIColor(hex: "#666666")
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
        timeSlotTab.backgroundColor = .clear
        timeSlotText.textColor = UIColor(hex: "#666666")
        reviewTab.backgroundColor = .clear
        reviewText.textColor = UIColor(hex: "#666666")
        updateView()
    }
    
    func setTimeSlotHighighted() {
        containerViewController = .timeSlot
        timeSlotTab.backgroundColor = UIColor(hex: "#FFF3F2")
        timeSlotText.textColor = Theme.appOrangeColor
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
        timeSlotTab.backgroundColor = .clear
        timeSlotText.textColor = UIColor(hex: "#666666")
        aboutTab.backgroundColor = .clear
        aboutText.textColor = UIColor(hex: "#666666")
        updateView()
    }
}

extension BarberMyProfileView: BarberAboutViewDelegate {
    func refreshAbout() {
        self.refreshData()
    }
}

extension BarberMyProfileView: BarberServiceViewDelegate {
    func refreshService() {
        self.refreshData()
    }
}

extension BarberMyProfileView : BarberReviewViewDelegate {
    func refreshReviews() {
        self.refreshData()
    }
}
