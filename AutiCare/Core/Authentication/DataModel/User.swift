//
//  User.swift
//  FireBaseAuthTutorail
//
//  Created by Sudhanshu Singh Rajput on 19/01/25.
//

import Foundation


struct User: Identifiable, Codable {
    let id: String
    var fullName: String
    let email: String
    let userName: String
    var profileImageURL: String?
    var location:String? = ""
    var dob:Date
    var gender:String
    var isProfileComplete: Bool = false
    var followersCount: Int = 0
    var followingCount: Int = 0
    var postsCount: Int = 0 // Default zero
    var bio:String?
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

