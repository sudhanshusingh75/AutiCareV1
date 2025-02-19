//
//  Chat.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 18/02/25.
//

import Foundation

struct Chat:Codable,Identifiable{
    let id:String
    let userId:String
    var lastMessage:String
    var lastMessageTime:TimeInterval
    var lastSenderId:String
    var isGroupChat:Bool
}

struct Message:Identifiable,Codable{
    let id:String
    let senderId:String
    let receiverId:String
    let text:String
    let timeStamp:TimeInterval
    let imageURL:String?
    let isRead:Bool
    
    var formattedDate:String{
        let date = Date(timeIntervalSince1970: timeStamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

