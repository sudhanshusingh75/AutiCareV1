//
//  Comments.swift
//  FireBaseAuthTutorail
//
//  Created by Sudhanshu Singh Rajput on 01/02/25.
//

import Foundation
struct Comments:Codable,Identifiable{
    let id:String
    let postId:String
    let userId:String
    let fullName: String
    let profileImageURL:String?
    let content:String
    let createdAt:TimeInterval
}

