//
//  BarberChatView.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 17/08/2021.
//

import Foundation
import UIKit
import CommonComponents
import Helpers
import FirebaseFirestore
import IQKeyboardManagerSwift

class BarberChatView: BaseView, Routeable {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet var tableViewBottomConstraint: NSLayoutConstraint!
    
    var db: Firestore?
    var isCustomer = false
    var listnerReg: ListenerRegistration?
    var serviceObject: BarberBaseModel!
    var msg : [[String:Any]] = []
    var chatData : [ChatModel]?
    var messageStr = ""
    
    var customInputView: UIView!
    var sendButton: UIButton!
    
    var textField: FlexibleTextView!

    deinit {
        print("pop")
        listnerReg?.remove()
        db = nil
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ChatViewModel()
        self.setView()
        setupTableView()
        db = Firestore.firestore()
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        resetChat()
    }
    
    func resetChat() {
        loadChatMessages()
        tableView.reloadData()
        scrollToBottomAfterDelay()
        updateStatus(status: "Visible")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        updateStatus(status: "Gone")
    }

    func updateStatus(status: String) {
        var parameters = [String:Any]()
        parameters["status"] = status
        
        let friend = isCustomer ? serviceObject.barber?.id?.description ?? "" : serviceObject.user?.id?.description ?? ""
        let id = UserPreferences.userModel?.id?.description ?? ""
        if id != "" && friend != "" {
            Firestore.firestore().collection("User").document(friend).collection("Job").document(serviceObject.id?.description ?? "").collection("Friend").document(id).setData(parameters, merge: true, completion: { error in
                if error != nil {
                    print("Firestore Status Update Error for FriendId: \(friend)\nMessage: \(error?.localizedDescription ?? "")")
                }
            })
        }
    }
    
    func scrollToBottomAfterDelay() {
        if self.msg.count < 1 {
            return
        }

        let indexPath = IndexPath(row: self.msg.count - 1, section: 0)
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        })
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "BarberReceiveChatCell", bundle: nil), forCellReuseIdentifier: "BarberReceiveChatCell")
        self.tableView.register(UINib(nibName: "BarberSendChatCell", bundle: nil), forCellReuseIdentifier: "BarberSendChatCell")
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 110
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    override var inputAccessoryView: UIView? {
        if customInputView == nil {
            customInputView = CustomView()
            customInputView.accessibilityIdentifier = "customInputView"
            customInputView.backgroundColor = UIColor(hexString: "#F1F2F6")
            textField = FlexibleTextView()
            textField.backgroundColor = UIColor(hexString: "#F1F2F6")
            textField.placeholder = "Write Something"
            textField.delegate = self
            textField.font = Theme.getAppFont(withSize: 15)

            customInputView.autoresizingMask = .flexibleHeight
            customInputView.addSubview(textField)

            sendButton = UIButton(type: .system)
            sendButton.isEnabled = true
            sendButton.setImage(UIImage(named: "ChatSendButton"), for: .normal)
            sendButton.backgroundColor = .clear
            sendButton.setTitle(" ", for: .normal)
            sendButton.tintColor = Theme.appNavigationBlueColor

            sendButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
            customInputView?.addSubview(sendButton)

            textField.translatesAutoresizingMaskIntoConstraints = false
            sendButton.translatesAutoresizingMaskIntoConstraints = false
            sendButton.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            sendButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)

            textField.maxHeight = 80

            textField.trailingAnchor.constraint(
                equalTo: sendButton.leadingAnchor,
                constant: -8
            ).isActive = true

            textField.topAnchor.constraint(
                equalTo: customInputView.topAnchor,
                constant: 8
            ).isActive = true

            textField.bottomAnchor.constraint(
                equalTo: customInputView.layoutMarginsGuide.bottomAnchor,
                constant: -8
            ).isActive = true

            textField.leadingAnchor.constraint(
                equalTo: customInputView.layoutMarginsGuide.leadingAnchor,
                constant: 8
            ).isActive = true

            sendButton.leadingAnchor.constraint(
                equalTo: textField.trailingAnchor,
                constant: 0
            ).isActive = true

            sendButton.trailingAnchor.constraint(
                equalTo: customInputView.trailingAnchor,
                constant: -8
            ).isActive = true

            sendButton.bottomAnchor.constraint(
                equalTo: customInputView.layoutMarginsGuide.bottomAnchor,
                constant: -8
            ).isActive = true
        }
        return customInputView
    }

    
    @objc func notificationButton() {
        let vc : CustomerNotificationView = AppRouter.instantiateViewController(storyboard: .Customernotification)
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
            Helper.getInstance.setNavigationBar(leftBarItem: backButton, rightBarItem: nil, title: isCustomer ? (serviceObject.barber?.name ?? "") : (serviceObject.user?.name ?? ""), isTransparent: false, isBottomLine: false, titleView: nil, backgroundColor: Theme.appNavigationBlueColor, itemsColor: .white, titleFontStyle: UIFont(name: Constants.mediumFont, size: 20), vc: self)
        }
    }
    
    func loadChatMessages() {
        let friend = isCustomer ? serviceObject.barber?.id?.description ?? "" : serviceObject.user?.id?.description ?? ""
        listnerReg = db?.collection("User").document(UserPreferences.userModel?.id?.description ?? "").collection("Job").document(serviceObject.id?.description ?? "").collection("Friend").document(friend).collection("Chat").addSnapshotListener { (data, error) in
            
            self.chatData = ChatModel.loadChatData(data: data?.documents ?? [])
            
            self.chatData = self.chatData?.sorted(by: { $0.timeStamp ?? 0 > $1.timeStamp ?? 0})
            
            self.msg.removeAll()
            
            for c in self.chatData ?? []
            {
                if Int(c.sender_id ?? "") == UserPreferences.userModel?.id
                {
                    if c.message != ""
                    {
                        self.msg.append(["type": "send", "message": c.message ?? "","time": c.serverTimeStamp?.dateValue()])
                    }
                }
                else
                {
                    if c.message != ""
                    {
                        self.msg.append(["type": "receive", "message": c.message ?? "","time": c.serverTimeStamp?.dateValue()])
                    }
                }
            }
            self.msg.reverse()
            self.tableView.reloadData()
            self.scrollToBottomAfterDelay()
        }
    }
    
    func updateTableViewBottomConstraint() {
        DispatchQueue.main.async {
            if self.textField.isFirstResponder {
                if let view = self.findView(with: "customInputView")?.superview {
                    var height = view.frame.height
                    if UIDevice.current.hasNotch {
                        height -= self.view.safeAreaInsets.bottom
                    }
                    if height != 0 {
                        self.tableViewBottomConstraint.constant = height
                        self.tableView.scrollToBottom(false)
                    }
                    //            let height = UIApplication.shared.windows[2].subviews[0].subviews[0].frame.height
                }
            } else {
                self.tableViewBottomConstraint.constant = self.textField.frame.height + 16
            }
        }
    }
    
    @objc func sendButtonAction() {
        messageStr = textField.text ?? ""
        if messageStr.isEmpty {
            return
        }
        
        var temp = messageStr.replacingOccurrences(of: " ", with: "")
        if temp.isEmpty {
            return
        }
        temp = messageStr.replacingOccurrences(of: "\n", with: "")
        if temp.isEmpty {
            return
        }
        
        let friend = isCustomer ? serviceObject.barber?.id?.description ?? "" : serviceObject.user?.id?.description ?? ""
        let senderName = isCustomer ? serviceObject.user?.name ?? "" : serviceObject.user?.name ?? ""
        let message = "\(isCustomer ? serviceObject.user?.name ?? "" : serviceObject.barber?.name ?? "") sent you a message"
        db?.collection("User").document(friend).getDocument(completion: { (data, error) in
            if data?.get("status") as? String == "Offline" {
                (self.viewModel as! ChatViewModel).sendPushNotification(recipientId: friend, jobId: self.serviceObject.id?.description ?? "", message: message, title: senderName)
            } else {
                self.db?.collection("User").document(UserPreferences.userModel?.id?.description ?? "").collection("Job").document(self.serviceObject.id?.description ?? "").collection("Friend").document(friend).getDocument(completion: { (data, error) in
                    if data?.get("status") as? String == "Gone"
                    {
                        (self.viewModel as! ChatViewModel).sendPushNotification(recipientId: friend, jobId: self.serviceObject.id?.description ?? "", message: message, title: senderName)
                    }
                })
            }
        })
        
        var ref: DocumentReference? = nil
        
        ref = db?.collection("User").document(UserPreferences.userModel?.id?.description ?? "")
        let jobRef = ref?.collection("Job").document(self.serviceObject.id?.description ?? "")
        let nurseRef = jobRef?.collection("Friend").document(friend)
        nurseRef?.collection("Chat").addDocument(data: ["message": textField.text ?? "","sender_id":UserPreferences.userModel?.id?.description ?? "","serverTimeStamp": FieldValue.serverTimestamp(), "timeStamp": Date().currentTimeStamp()])
        
        ref = db?.collection("User").document(friend)
        let jobRefO = ref?.collection("Job").document(self.serviceObject.id?.description ?? "")
        let nurseRefO = jobRefO?.collection("Friend").document(UserPreferences.userModel?.id?.description ?? "")
        nurseRefO?.collection("Chat").addDocument(data: ["message":textField.text ?? "","sender_id":UserPreferences.userModel?.id?.description ?? "","serverTimeStamp": FieldValue.serverTimestamp(), "timeStamp": Date().currentTimeStamp()])
        
        textField.text = ""
    }
}

extension BarberChatView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messages = msg[indexPath.row]
        let type = messages["type"] as! String
        
        if type == "send" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BarberSendChatCell", for: indexPath) as! BarberSendChatCell
            cell.chatTextView.text = messages["message"] as? String
            cell.chatTextView.sizeToFit()
            let date = messages["time"] as? Date ?? Date()
            cell.sendTime.text = date.toString(format: "h:mm a")
            cell.chatImage.layer.cornerRadius = 6
            cell.chatImage.sd_setImage(with: URL(string: isCustomer ? (serviceObject.user?.image_url ?? "") : (serviceObject.barber?.image_url ?? "")), placeholderImage: UIImage(named: "avatar_default"))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BarberReceiveChatCell", for: indexPath) as! BarberReceiveChatCell
            cell.chatText.text = messages["message"] as? String
            cell.chatText.sizeToFit()
            let date = messages["time"] as? Date ?? Date()
            cell.receiveTime.text = date.toString(format: "h:mm a")
            cell.chatImage.sd_setImage(with: URL(string: isCustomer ? (serviceObject.barber?.image_url ?? "") : (serviceObject.user?.image_url ?? "")), placeholderImage: UIImage(named: "avatar_default"))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension BarberChatView: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        updateTableViewBottomConstraint()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        updateTableViewBottomConstraint()
    }

    func textViewDidChange(_ textView: UITextView) {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.updateTableViewBottomConstraint()
            self.tableView.scrollToBottom(false)
        })
    }
}

extension BarberChatView {
    func findView(with identifier: String) -> UIView? {
        for window in UIApplication.shared.windows {
            for view in window.subviews {
                let foundViews = getSubviewsOfView(view: view)
                if let desiredView = foundViews.first(where: {$0.accessibilityIdentifier == identifier}) {
                    return desiredView
                }
            }
        }
        return nil
    }

    func getSubviewsOfView(view: UIView) -> [UIView] {
        var subviewArray = [UIView]()
        if view.subviews.count == 0 {
            return subviewArray
        }
        for subview in view.subviews {
            subviewArray += self.getSubviewsOfView(view: subview)
            subviewArray.append(subview)
        }
        return subviewArray
    }
}
