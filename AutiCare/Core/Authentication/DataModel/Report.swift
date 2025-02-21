//
//  Report.swift
//  Auticare
//
//  Created by sourav_singh on 21/02/25.
//

import Foundation
struct Report:Codable,Identifiable{
    var id:String
    let postId:String
    let reportedBy:String?
    let reson:String
    let timeStamp:TimeInterval
}
