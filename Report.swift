//
//  Report.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 21/02/25.
//

import Foundation
struct Report: Codable, Identifiable {
    var id: String
    let postId: String
    let reportedBy: String
    let reason: String?
    let timestamp: TimeInterval
}
