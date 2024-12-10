//
//  ChatModel.swift
//  MoCuts
//
//  Created by Ahmed Khan on 26/10/2021.
//

import Foundation
import FirebaseFirestore

class ChatModel
{
    var message: String?
    var sender_id: String?
    var serverTimeStamp: Timestamp?
    var timeStamp: Int?
    
    class func loadChatData(data: [QueryDocumentSnapshot]) -> [ChatModel]
    {
        var dataArr = [ChatModel]()
        for d in data
        {
            let dic = d.data()
            let c = ChatModel()
            print(dic["message"] as? String ?? "")
            c.message = dic["message"] as? String ?? ""
            c.serverTimeStamp = dic["serverTimeStamp"] as? Timestamp
            c.sender_id = dic["sender_id"] as? String ?? ""
            c.timeStamp = Int(dic["timeStamp"] as? String ?? "")
            dataArr.append(c)
        }
        return dataArr
    }
    
}
