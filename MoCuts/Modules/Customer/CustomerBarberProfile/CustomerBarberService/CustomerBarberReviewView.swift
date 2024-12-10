//
//  CustomerBarberReviewView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 25/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class CustomerBarberReviewView : BaseView, Routeable {
        
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet var ratingCountLabel: UILabel!
    var page = 1
    var total = 0
    var reviews = [ReviewItem]()
    var barberId = 0
    var dataLoadedOnce = false
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CustomerBarberReviewViewModel()
        setReviewsData()
        self.setView()
        setupRefreshControl()
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
        refreshControl.beginRefreshing()
        (viewModel as! CustomerBarberReviewViewModel).getReviews(userId: String(barberId), offset: 1)
    }
    
    func setReviewsData() {
        (viewModel as! CustomerBarberReviewViewModel).reviewsFetched = { [weak self] response in
            guard let self = self else {
                return
            }
            self.dataLoadedOnce = true
            self.page = response.page ?? 1
            self.total = response.total ?? self.reviews.count
            if response.page == 1 {
                self.reviews = response.data ?? []
            } else {
                self.reviews.append(contentsOf: response.data ?? [])
            }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                self.ratingCountLabel.text = "Ratings and Reviews (\(response.total ?? 0))"
            }
        }
        (viewModel as! CustomerBarberReviewViewModel).onFailure = { [weak self] error in
            
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !dataLoadedOnce && !viewModel.isLoading {
            (viewModel as! CustomerBarberReviewViewModel).getReviews(userId: String(barberId), offset: 1)
        }
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomerBarberReviewListCell", bundle: nil), forCellReuseIdentifier: "CustomerBarberReviewListCell")
        tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }
}

extension CustomerBarberReviewView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count == 0 ? (dataLoadedOnce ? 1 : 0) : reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if reviews.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
            cell.noDataImage.image = UIImage(named: "feedback")
            cell.noDataMessage.text = "Oops!\nNo reviews found!"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerBarberReviewListCell", for: indexPath) as! CustomerBarberReviewListCell
            let data = reviews[indexPath.row]
            cell.profileImageView.sd_setImage(with: URL(string: data.from?.imageUrl ?? ""), completed: nil)
            cell.title.text = data.from?.name ?? ""
            cell.rating.text = String(format: "%.2f", data.rating ?? 0.0)
            cell.review.text = data.review ?? ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if reviews.count != 0 && indexPath.row == reviews.count - 1 {
            if reviews.count < total {
                DispatchQueue.main.async {
                    self.removeNoDataLabelOnTableView(tableView: self.tableView)
                    (self.viewModel as! CustomerBarberReviewViewModel).getReviews(userId: String(self.barberId), offset: self.page + 1)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
