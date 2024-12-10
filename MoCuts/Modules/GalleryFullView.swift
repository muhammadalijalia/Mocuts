//
//  GalleryFullView.swift
//  MoCuts
//
//  Created by Ahmed Khan on 12/11/2021.
//

import Foundation
import UIKit
import Helpers
import CommonComponents
import Lightbox

class GalleryFullView : BaseView, Routeable {
    
    @IBOutlet var containerView: UIView!
    var titleName = "My Gallery"
    var galleryArray = [LightboxImage]()
    var selectedIndex = 0
    var galleryFullView = LightboxController(images: [LightboxImage](), startIndex: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGalleryView()
        LightboxConfig.preload = 1
    }
    
    func setupGalleryView() {
        galleryFullView.pageDelegate = self
        galleryFullView.dismissalDelegate = self
        galleryFullView.dynamicBackground = false
        galleryFullView.headerView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        add(asChildViewController: galleryFullView)
        
        if galleryFullView.images.count == 0 {
            galleryFullView.images = galleryArray
        }
        galleryFullView.goTo(selectedIndex)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // Add Child View Controller
            self.addChild(viewController)
            // Add Child View as Subview
            self.containerView.addSubview(viewController.view)
            // Configure Child View
            viewController.view.frame = self.containerView.bounds
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // Notify Child View Controller
            viewController.didMove(toParent: self)
        }
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        if let image = UIImage(named: "backButton") {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: nil, title: titleName, isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
    }
}

extension GalleryFullView: LightboxControllerPageDelegate {

  func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
    print(page)
  }
}

extension GalleryFullView : LightboxControllerDismissalDelegate {
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        self.navigationController?.popViewController(animated: true)
    }
}
