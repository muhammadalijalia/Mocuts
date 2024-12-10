//
//  BarberMyCardsView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 06/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class BarberMyCardsView: BaseView, Routeable {
    
    @IBOutlet weak var tableView : UITableView!
    var iPhoneXorLaterFamily : [String] = ["iPhone10,3","iPhone10,6","iPhone11,2","iPhone11,4","iPhone11,6","iPhone11,8","iPhone12,1","iPhone12,3","iPhone12,5","iPhone12,8","iPhone13,1","iPhone13,2","iPhone13,3","iPhone13,4"]
    var cellHeight : CGFloat = 0
    var xFamily : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        viewModel = GetStartedViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MyCardCell", bundle: nil), forCellReuseIdentifier: "MyCardCell")
        tableView.separatorStyle = .none
        for i in iPhoneXorLaterFamily {
        print(i)
            if UIDevice.current.modelName == i {
                xFamily = true
                break
            } else {
                xFamily = false
            }
        }
        tableView.reloadData()
    }
    
    @objc func addCardBtn() {
        let vc : AddNewCardView = AppRouter.instantiateViewController(storyboard: .wallet)
        self.route(to: vc, navigation: .push)
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true

        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            let rightBarImage = UIBarButtonItem(image: UIImage(named: "CardAddIcon"), style: .plain, target: self, action: #selector(addCardBtn))
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: rightBarImage, title: "My Cards", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
    }
}


extension BarberMyCardsView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCardCell", for: indexPath) as! MyCardCell
        
        for i in iPhoneXorLaterFamily {
            if UIDevice.current.modelName == i {
                cell.imageView?.contentMode = .scaleAspectFit
            } else {
                cell.imageView?.contentMode = .scaleAspectFill
            }
        }
        
        if indexPath.row == 0 {
            cell.cardImage?.image = UIImage(named: "DebitCard")
        } else if indexPath.row == 1 {
            cell.cardImage?.image = UIImage(named: "CreditCard")
        } else if indexPath.row == 2 {
            cell.cardImage?.image = UIImage(named: "PayPalCard")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if xFamily {
            return 240
        } else {
            return tableView.frame.height / 2.5
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
