//
//  BarberTimeSlotView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 11/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class BarberTimeSlotView: BaseView, Routeable {
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var tableView : UITableView!
    
    var weekArray = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var weekDaysArray : [WeekDays] = []
    
    var barberObj : User_Model?
    var availibilitiesArray = [Availabilities]()
    var slotsArray = [Availability]()
    var collectionIndex: Int = 0
    var tableIndex: Int = 0
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BarberTimeSlotViewModel()
        self.setTimeSlots()
        setupTableView()
        setupRefreshControl()
        for day in weekArray {
            if day == "Mon" {
                self.weekDaysArray.append(WeekDays(weekDay: day, isSelected: true))
            } else {
                self.weekDaysArray.append(WeekDays(weekDay: day, isSelected: false))
            }
        }
        
        DispatchQueue.main.async {
            (self.viewModel as! BarberTimeSlotViewModel).getAllSlots()
        }
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
        (self.viewModel as! BarberTimeSlotViewModel).getAllSlots()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setView()
    }
    
    func setTimeSlots(){
        (self.viewModel as! BarberTimeSlotViewModel).setBarberTimeSlotData = { [weak self] slots in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.availibilitiesArray = slots
                self.slotsArray = self.availibilitiesArray[0].availabilities ?? []
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }
        }
        (self.viewModel as! BarberTimeSlotViewModel).setFailureRoute = { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupTableView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "BarberTimeSlotCell", bundle: nil), forCellWithReuseIdentifier: "BarberTimeSlotCell")
        
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "BarberTimeSwitchCell", bundle: nil), forCellReuseIdentifier: "BarberTimeSwitchCell")
        tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
        self.tableView.separatorStyle = .none
    }
    
    @IBAction func backBtnTapped(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addTimeSlotButton(_ sender : UIButton) {
        let vc : BarberAddNewTimeSlotView = AppRouter.instantiateViewController(storyboard: .Barberprofile)
        vc.addBarberTimeSlot = { [weak self] slot in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                (self.viewModel as! BarberTimeSlotViewModel).getAllSlots()
            }
        }
        self.route(to: vc, navigation: .push)
    }
}

extension BarberTimeSlotView : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarberTimeSlotCell", for: indexPath) as! BarberTimeSlotCell
        cell.timeSlotLabel.text = weekDaysArray[indexPath.row].weekDay
        if weekDaysArray[indexPath.row].isSelected {
            cell.bgView.backgroundColor = Theme.appOrangeColor
            cell.timeSlotLabel.textColor = .white
            cell.bgView.layer.borderColor = Theme.appOrangeColor.cgColor
        } else {
            cell.bgView.backgroundColor = .white
            cell.bgView.layer.borderColor = Theme.appNavigationBlueColor.cgColor
            cell.timeSlotLabel.textColor = Theme.appNavigationBlueColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        weekDaysArray.removeAll()
        for day in weekArray {
            self.weekDaysArray.append(WeekDays(weekDay: day, isSelected: false))
        }
        weekDaysArray[indexPath.row].isSelected = true
        self.slotsArray = self.availibilitiesArray[indexPath.row].availabilities ?? []
        self.collectionIndex = indexPath.row
        
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 55)
    }
}

extension BarberTimeSlotView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = (self.availibilitiesArray.isEmpty) ?  0 : self.availibilitiesArray[self.collectionIndex].availabilities?.count ?? 0
        
        return count == 0 ? 1 : count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = (self.availibilitiesArray.isEmpty) ?  0 : self.availibilitiesArray[self.collectionIndex].availabilities?.count ?? 0
        if count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
            cell.noDataImage.image = UIImage(named: "clock")
            cell.noDataMessage.text = "Oops!\nNo time slots added by barber yet!"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BarberTimeSwitchCell", for: indexPath) as! BarberTimeSwitchCell
            let slotObj = self.availibilitiesArray[self.collectionIndex].availabilities?[indexPath.row] //slotsArray[indexPath.row]
            
            let is_active = slotObj?.is_active ?? 0
            let start_time = slotObj?.start_time ?? ""
            let end_time = slotObj?.end_time ?? ""
            
            let startTime = DateFormatterHelper.get12HrsTime(from: DateFormatterHelper.convertStringToDate(format: .onlyTimeWithSecond, stringToConvert: start_time) ?? Date())
            let endTime = DateFormatterHelper.get12HrsTime(from: DateFormatterHelper.convertStringToDate(format: .onlyTimeWithSecond, stringToConvert: end_time) ?? Date())
            
            let time = "\(startTime) - \(endTime)"
            
            cell.timeText.text = time
            cell.switchOutlet.isOn = (is_active == 1) ? true : false
            cell.changeSwitchState(switchs: cell.switchOutlet)
            cell.delegate = self
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let count = (self.availibilitiesArray.isEmpty) ?  0 : self.availibilitiesArray[self.collectionIndex].availabilities?.count ?? 0
        if count != 0 {
            let slot_id = self.availibilitiesArray[self.collectionIndex].availabilities?[indexPath.row].id ?? 0
            
            let attributedString = NSAttributedString(string: "Menu", attributes: [
                NSAttributedString.Key.font : Theme.getAppMediumFont(withSize: 18),
                NSAttributedString.Key.foregroundColor : UIColor.black
            ])
            let alert = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
            let subview = alert.view.subviews.first! as UIView
            let alertContentView = subview.subviews.first! as UIView
            alertContentView.backgroundColor = UIColor.white
            alertContentView.layer.cornerRadius = 15
            alert.view.tintColor = Theme.appOrangeColor
            alert.setValue(attributedString, forKey: "attributedTitle")
            
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak self] _ in
                guard let self = self else {
                    return
                }
                (self.viewModel as! BarberTimeSlotViewModel).deleteSlot(slotID: slot_id)
                (self.viewModel as! BarberTimeSlotViewModel).setBarberTimeSlotDelete = { [weak self] slot in
                    guard let self = self else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.availibilitiesArray[self.collectionIndex].availabilities?.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    }
                }
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = (self.availibilitiesArray.isEmpty) ?  0 : self.availibilitiesArray[self.collectionIndex].availabilities?.count ?? 0
        
        return count == 0 ? 262 : 85
    }
}

struct WeekDays {
    var weekDay : String
    var isSelected : Bool
}

extension BarberTimeSlotView: BarberTimeSwitchCellDelegate {
    func switchValueChangedHandler(cell: BarberTimeSwitchCell, switchState: Bool) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let slot_id = self.availibilitiesArray[self.collectionIndex].availabilities?[indexPath.row].id ?? 0
        (self.viewModel as! BarberTimeSlotViewModel).changeSlotStatus(slotID: slot_id, isEnable: switchState)
        
        (self.viewModel as! BarberTimeSlotViewModel).setBarberTimeSlotStatus = { [ weak self] slot in
            guard let self = self else {
                return
            }
            guard let sloty = slot.data else { return }
            DispatchQueue.main.async {
                self.availibilitiesArray[self.collectionIndex].availabilities?.remove(at: indexPath.row)
                self.availibilitiesArray[self.collectionIndex].availabilities?.insert(sloty, at: indexPath.row)
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
        (self.viewModel as! BarberTimeSlotViewModel).setFailureRoute = { [weak self] message in
            if message == "Time Slot is reserved with some job" {
                DispatchQueue.main.async {
                    guard let self = self else {
                        return
                    }
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
}
