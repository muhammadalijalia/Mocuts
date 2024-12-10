//
//  ServiceHistoryDetailView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 05/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class ServiceHistoryDetailView: BaseView, Routeable {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var navView : UIView!
    @IBOutlet weak var cosmosView : UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeSpanLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var jobDetails: BarberBaseModel?
    var reportTypes = [ReportType]()
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BarberServiceRequestViewModel()
        (self.viewModel as! BarberServiceRequestViewModel).getReportTypes()
        setOnReportTypes()
        self.setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func setOnReportTypes() {
        (viewModel as! BarberServiceRequestViewModel).setReportTypes = { [weak self] response in
            guard let self = self else {
                return
            }
            self.reportTypes = response
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableViewHeightConstraint.constant = self.tableView.contentSizeHeight
        }
    }
    
    func setView() {
        
        statusLabel.text = getStatus(with: jobDetails?.status ?? 0)
        coverImage.sd_setImage(with: URL(string: jobDetails?.barber?.image_url ?? ""), completed: nil)
        nameLabel.text = jobDetails?.barber?.name
        let rating = jobDetails?.barber?.average_rating ?? 0.0
        ratingLabel.text = String(format: rating == 0 ? "%.1f" : "%.2f", rating)
        addressLabel.text = jobDetails?.barber?.address?.decodeUrl()?.replacingOccurrences(of: "+", with: " ")
        
        timeSpanLabel.text = "\(jobDetails?.date?.changeFormat(fromFormat: "yyyy-MM-dd", toFormat: "MM/dd/yyyy") ?? "") - \(jobDetails?.availability?.start_time?.changeFormat(fromFormat: "HH:mm:ss", toFormat: "hh:mm a") ?? "") - \(jobDetails?.availability?.end_time?.changeFormat(fromFormat: "HH:mm:ss", toFormat: "hh:mm a") ?? "")"
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.addAnimatingGradient()
        }
        self.cosmosView.layer.cornerRadius = 5
        self.tableView.layer.cornerRadius = 5
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TotalServiceCell", bundle: nil), forCellReuseIdentifier: "TotalServiceCell")
        tableView.register(UINib(nibName: "ServiceNameCell", bundle: nil), forCellReuseIdentifier: "ServiceNameCell")
        tableView.register(UINib(nibName: "TotalChargesCell", bundle: nil), forCellReuseIdentifier: "TotalChargesCell")
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func addAnimatingGradient() {
        
        self.navView.backgroundColor = UIColor.clear
        let gradientOne = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.5).cgColor
        let gradientTwo = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.001).cgColor
        gradientSet.append([gradientOne, gradientTwo])
        gradient.frame = self.navView.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.locations = [0.0, 1.0]
        gradient.drawsAsynchronously = true
        self.navView.layer.insertSublayer(gradient, at :0)
    }
    
    @IBAction func backBtnTapped(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
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
                        
                        (self.viewModel as! BarberServiceRequestViewModel).sendReport(toId: String(self.jobDetails?.barber_id ?? 0), reportTypeId: String(reportType.id ?? 0), message: "Reported")
                    }
                }
            }))
        }
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


extension ServiceHistoryDetailView : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (jobDetails?.job_services?.count ?? 0) + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let serviceCount = jobDetails?.job_services?.count ?? 0
        var totalDuration = 0
        for service in jobDetails?.job_services ?? [Job_Services]() {
            totalDuration += service.duration ?? 0
        }
        totalDuration = totalDuration * 60
        let totalRows = serviceCount + 2
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalServiceCell", for: indexPath) as! TotalServiceCell
            cell.serviceCount.text = "\(String(serviceCount)) Services Selected"
            
            cell.totalTime.text = "(\(Utilities.shared.getSecondsInWords(seconds: Double(totalDuration))))"
            return cell
        } else if indexPath.row == totalRows - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalChargesCell", for: indexPath) as! TotalChargesCell
            
            let subTotal = Double(self.jobDetails?.sub_total ?? 0)
            let total = Double(subTotal) + Double(subTotal) * 0.1
            
            cell.salesTaxSV.isHidden = false
            cell.comissionSV.isHidden = true
            cell.subTotalCharges.text = "$ \(String(format: "%.2f", subTotal))"
            cell.salesTaxCharges.text = "10.00 %"
            cell.totalCharges.text = "$ \(String(format: "%.2f", total))"
            return cell
        } else {
            let data = jobDetails?.job_services?[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceNameCell", for: indexPath) as! ServiceNameCell
            cell.serviceName.text = data?.service?.name
            cell.serviceCharges.text = "$ " + String(format: "%.2f", Double(data?.service?.price ?? 0))
            return cell
        }
    }
}
extension ServiceHistoryDetailView {
    func getStatus(with statusCode:Int) -> String {
        switch statusCode {
        case 5:
            return "Requested"
        case 6:
            return "Rejected"
        case 10:
            return "Accepted"
        case 11:
            return "On the Way"
        case 15:
            return "Arrived"
        case 16:
            return "Unserved"
        case 20:
            return "Barber Cancelled"
        case 25:
            return "User Cancelled"
        case 26, 30, 35, 40:
            return "Completed"
        default:
            return "Unknown"
        }
    }
}
