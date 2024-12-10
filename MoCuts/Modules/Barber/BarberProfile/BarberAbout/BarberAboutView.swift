//
//  BarberAboutView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 11/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import Lightbox

protocol BarberAboutViewDelegate: AnyObject {
    func refreshAbout()
}

class BarberAboutView : BaseView, Routeable {
    
    @IBOutlet weak var tableView: UITableView!
    
    var barberModel : GenericResponse<User_Model>?
    var barberDescription: String?
    var cvHeight: CGSize = CGSize.zero
    var refreshControl : UIRefreshControl!
    var delegate: BarberAboutViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GetStartedViewModel()
        self.setView()
        setupRefreshControl()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(handleRefreshControl),
                                    for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    @objc func handleRefreshControl() {
        delegate?.refreshAbout()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.refreshControl.endRefreshing()
        })
    }
    
    func getImagesUrl() -> [LightboxImage]{
        var imagesUrlArray : [LightboxImage] = [LightboxImage]()
        for image in self.barberModel?.data?.attachments ?? [] {
            imagesUrlArray.append(LightboxImage.init(imageURL: URL(string: image.media_url ?? "")!))
        }
        return imagesUrlArray
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension BarberAboutView : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.barberModel?.data?.attachments?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarberGalleryCell", for: indexPath) as! BarberGalleryCell
        
        let imageUrl = self.barberModel?.data?.attachments?[indexPath.row].media_url ?? ""
        
        cell.imageView.layer.cornerRadius = 5
        cell.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "photo"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 10 , height: collectionView.frame.width / 3 - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: GalleryFullView = AppRouter.instantiateViewController(storyboard: .home)
        vc.galleryArray = getImagesUrl()
        vc.selectedIndex = indexPath.row
        self.route(to: vc, navigation: .push)
    }
}

extension BarberAboutView: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return UITableView.automaticDimension
        }
        else
        {
            if self.barberModel?.data?.attachments?.count == 0
            {
                return 350
            }
            return cvHeight.height + 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BarberAboutCell_aboutDesc") as! BarberAboutCell
            if barberDescription == ""
            {
                cell.barberDescriptionLbl.isHidden = true
                cell.noDataView.isHidden = false
            }
            else
            {
                cell.barberDescriptionLbl.isHidden = false
                cell.noDataView.isHidden = true
                cell.barberDescriptionLbl.text = barberDescription
                self.tableView.layoutIfNeeded()
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BarberAboutCell_gallery") as! BarberAboutCell
//            cell.galleryCV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController?.tabBar.frame.height ?? 0 + 50, right: 0)
            
            if self.barberModel?.data?.attachments?.count == 0
            {
                cell.noDataView.isHidden = false
                cell.galleryCV.isHidden = true
            }
            else
            {
                cell.galleryCV.isHidden = false
                cell.noDataView.isHidden = true
            }
            
            cell.galleryCV.delegate = self
            cell.galleryCV.dataSource = self
            cell.galleryCV.register(UINib(nibName: "BarberGalleryCell", bundle: nil), forCellWithReuseIdentifier: "BarberGalleryCell")
            cell.galleryCV.reloadData()
            cvHeight = cell.galleryCV.collectionViewLayout.collectionViewContentSize
            return cell
        }
    }
}
