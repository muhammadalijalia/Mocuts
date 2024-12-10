//
//  CustomerBarberGalleryView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 25/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import Lightbox

class CustomerBarberGalleryView : BaseView, Routeable {
    
    @IBOutlet weak var collectionView : UICollectionView!
    var refreshControl : UIRefreshControl!

    var galleryImages: [GalleryResponseModel] = []
    var barberId: Int = 0
    var dataLoadedOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        viewModel = CustomerBarberGalleryViewModel()
        setBarberImages()
        self.setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !dataLoadedOnce {
            dataLoadedOnce = true
            (viewModel as! CustomerBarberGalleryViewModel).getBarberImages(userId: barberId)
        }
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(handleRefreshControl),
                                    for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
    }
    
    func getImagesUrl() -> [LightboxImage]{
        var imagesUrlArray : [LightboxImage] = [LightboxImage]()
        
        for image in galleryImages {
            imagesUrlArray.append(LightboxImage.init(imageURL: URL(string: image.media_url ?? "")!))
        }
        return imagesUrlArray
    }
    
    @objc func handleRefreshControl() {
        DispatchQueue.main.async {
            (self.viewModel as! CustomerBarberGalleryViewModel).getBarberImages(userId: self.barberId)
        }
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CustomerBarberGalleryCell", bundle: nil), forCellWithReuseIdentifier: "CustomerBarberGalleryCell")
        collectionView.register(UINib(nibName: "NoDataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NoDataCollectionViewCell")
    }
    
    func setBarberImages() {
        (viewModel as! CustomerBarberGalleryViewModel).getBarberGalleryImage = { [weak self] images in
            guard let self = self else {
                return
            }
            if let images = images {
                DispatchQueue.main.async {
                    self.galleryImages = images
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
        (viewModel as! CustomerBarberGalleryViewModel).failure = { [weak self] error in
            guard let self = self else {
                return
            }
            self.refreshControl.endRefreshing()
        }
    }
}

extension CustomerBarberGalleryView : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryImages.count == 0 ? 1 : galleryImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if galleryImages.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoDataCollectionViewCell", for: indexPath) as! NoDataCollectionViewCell
            cell.noDataImage.image = UIImage(named: "Gallery")
            cell.noDataMessage.text = "Oops! No image(s) added\nin gallery yet!"
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomerBarberGalleryCell", for: indexPath) as! CustomerBarberGalleryCell
        cell.imageView.layer.cornerRadius = 8
        cell.imageView.sd_setImage(with: URL(string: galleryImages[indexPath.row].media_url ?? ""), completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if galleryImages.count == 0 {
            return CGSize(width: 414, height: 262)
        }
        return CGSize(width: collectionView.frame.width / 3 - 20 , height: collectionView.frame.width / 3 - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if galleryImages.count != 0 {
            let vc: GalleryFullView = AppRouter.instantiateViewController(storyboard: .home)
            vc.galleryArray = getImagesUrl()
            vc.selectedIndex = indexPath.row
            self.route(to: vc, navigation: .push)
        }
    }
}
