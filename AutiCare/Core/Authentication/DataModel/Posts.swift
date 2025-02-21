//
//  Post.swift
//  FireBaseAuthTutorail
//
//  Created by Sudhanshu Singh Rajput on 01/02/25.
//

import Foundation

struct Posts:Codable,Identifiable{
    let id:String
    let userId:String
    let content:String
    let imageURL:[String]
    let createdAt:TimeInterval
    let fullName:String
    let profileImageURL:String?
    var likesCount:Int
    var likedBy: [String]
    var commentsCount: Int
    var tag:[String]
    
    var formattedLikes: String {
        formatNumber(likesCount)
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1_000_000_000 {
            return String(format: "%.1fB", Double(number) / 1_000_000_000.0)
        } else if number >= 1_000_000 {
            return String(format: "%.1fM", Double(number) / 1_000_000.0)
        } else if number >= 1_000 {
            return String(format: "%.1fK", Double(number) / 1_000.0)
        } else {
            return "\(number)"
        }
    }
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}
