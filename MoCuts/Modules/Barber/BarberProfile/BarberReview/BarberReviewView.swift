//
//  BarberReviewView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 11/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

protocol BarberReviewViewDelegate: AnyObject {
    func refreshReviews()
}

class BarberReviewView : BaseView, Routeable {
        
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    var refreshControl: UIRefreshControl!
    
    var delegate: BarberReviewViewDelegate?
    
    var reviewsArray: [Reviews] = [Reviews]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        viewModel = GetStartedViewModel()
        setupRefreshControl()
        self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 70.0, right: 0)
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
        delegate?.refreshReviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.refreshControl.endRefreshing()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setView()
        reloadData()
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BarberReviewListCell", bundle: nil), forCellReuseIdentifier: "BarberReviewListCell")
        tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.backgroundColor = self.reviewsArray.count == 0 ? .clear : .white
        }
    }
    
    @IBAction func addServiceBtn(_ sender : UIButton) {

    }

}

extension BarberReviewView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsArray.count == 0 ? 1 : reviewsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if reviewsArray.count == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
            cell.noDataImage.image = UIImage(named: "feedback")
            cell.noDataMessage.text = "Oops!\nNo reviews found!"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarberReviewListCell", for: indexPath) as! BarberReviewListCell
        let reviewObj = self.reviewsArray[indexPath.row]
        
        cell.nameLabel.text = reviewObj.from?.name ?? ""
        cell.reviewLabel.text = reviewObj.review ?? ""
        let rating = reviewObj.rating ?? 0.0
        cell.ratingLabel.text = String(format: rating == 0 ? "%.1f" : "%.2f", rating)
        cell.profileImageView.sd_setImage(with: URL(string: reviewObj.from?.image_url ?? ""), placeholderImage: UIImage())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
