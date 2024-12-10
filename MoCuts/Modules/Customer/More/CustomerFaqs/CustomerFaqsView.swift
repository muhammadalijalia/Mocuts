//
//  CustomerFaqsView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 24/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers

class CustomerFaqsView: BaseView, Routeable {
    
    @IBOutlet weak var tableView : UITableView!
    
    var faqArray : [FAQModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        viewModel = CustomerFaqsViewModel()
        setupViewModelObserver()
        (viewModel as! CustomerFaqsViewModel).getFaqs()
    }
    
    func setupViewModelObserver() {
        
        (viewModel as! CustomerFaqsViewModel).onSuccess = { [weak self] faqModels in
            guard let self = self else {
                return
            }
            for faqModel in faqModels {
                DispatchQueue.main.async {
                    self.faqArray.append(FAQModel(questionText: faqModel.question ?? "", answerText: faqModel.answer ?? "", expandedHeight: (faqModel.answer ?? "").height(withConstrainedWidth: (self.view.frame.width - 93), font: Theme.getAppFont(withSize: 15)) + 50, collapsedHeight: 100, isExpanded: false))
                    if self.tableView != nil {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        (viewModel as! CustomerFaqsViewModel).onFailure = { [weak self] error in
            guard let self = self else {
                return
            }
            self.routeBack(navigation: .pop)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setView()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        toggleWhiteView(toggle: !(self.tabBarController?.tabBar.isHidden ?? false))
        self.tabBarController?.tabBar.isTranslucent = true
        let backButtonImage = UIImage(named: "backButton")
        if let image = backButtonImage {
            let backButton = self.backBarButton(image: image)
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: nil, title: "FAQs", isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
    }
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FAQAnswerCell", bundle: nil), forCellReuseIdentifier: "FAQAnswerCell")
        self.tableView.register(UINib(nibName: "FAQQuestionCell", bundle: nil), forCellReuseIdentifier: "FAQQuestionCell")
        self.tableView.register(UINib(nibName: "FAQHeadingCell", bundle: nil), forCellReuseIdentifier: "FAQHeadingCell")
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 80
    }
}

extension CustomerFaqsView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return faqArray.count * 2
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FAQHeadingCell", for: indexPath) as! FAQHeadingCell
            return cell
        } else {
            if indexPath.row % 2 == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FAQQuestionCell", for: indexPath) as! FAQQuestionCell
                cell.questionText.text = faqArray[indexPath.row/2].questionText
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FAQAnswerCell", for: indexPath) as! FAQAnswerCell
                cell.delegate = self
                cell.index = (indexPath.row - 1) / 2
                if self.faqArray[(indexPath.row - 1) / 2].isExpanded {
                    cell.seeMoreBtn.setTitle("See Less", for: .normal)
                } else {
                    cell.seeMoreBtn.setTitle("See More", for: .normal)
                }
                
                cell.answerText.text = faqArray[(indexPath.row - 1) / 2].answerText
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else {
            if indexPath.row % 2 == 0 {
                return UITableView.automaticDimension
            } else {
                var newHeight: CGFloat = 0
                if faqArray[(indexPath.row - 1) / 2].isExpanded {
                    newHeight = faqArray[(indexPath.row - 1) / 2].expandedHeight
                } else {
                    newHeight = faqArray[(indexPath.row - 1) / 2].collapsedHeight
                }
                return newHeight
            }
        }
    }
}

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: Theme.getAppFont(withSize: 15)], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}

extension CustomerFaqsView : FAQAnswerCellMethod {
    func expandCell(index: Int) {
        guard index != -1 else {
            return
        }
        if self.faqArray[index].isExpanded {
            self.faqArray[index].isExpanded = false
        } else {
            self.faqArray[index].isExpanded = true
        }
        tableView.reloadData()
    }
}

struct FAQModel {
    var questionText : String
    var answerText : String
    var expandedHeight : CGFloat
    var collapsedHeight : CGFloat
    var isExpanded : Bool
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
