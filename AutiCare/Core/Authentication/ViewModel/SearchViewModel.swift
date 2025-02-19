//
//  SearchViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 10/02/25.
//

import Foundation
import FirebaseFirestore

class SearchViewModel:ObservableObject{
    @Published var user : [User] = []
    @Published var searchText : String = ""
    @Published var followers:[User] = []
    let db = Firestore.firestore()
    
    func fetchAllUsers() async{
        var query:Query = db.collection("Users")
        
        if !searchText.isEmpty{
            query = query.whereField("fullName",isGreaterThanOrEqualTo: searchText)
                .whereField("fullName",isLessThanOrEqualTo: searchText+"\u{f8ff}")
                .whereField("userName", isGreaterThanOrEqualTo: searchText)
                .whereField("userName", isLessThanOrEqualTo: searchText+"\u{f8ff}")
        }
        do{
            let querySnapshot = try await query.getDocuments()
            let fetchedUser:[User] = querySnapshot.documents.compactMap { document in
                let data = document.data()
                return User(id: document.documentID,
                            fullName: data["fullName"] as? String ?? "Unknown",
                            email: data["email"] as? String ?? "",
                            userName: data["userName"] as? String ?? "",
                            profileImageURL: data["profileImageURL"] as? String,
                            dob: (data["dob"] as? Timestamp)?.dateValue() ?? Date(),
                            gender: data["gender"] as? String ?? "",
                            followers: data["followers"] as? [String] ?? [],  // Default empty array for missing followers
                            followings: data["followings"] as? [String] ?? [],  // Default empty array for missing followings
                            postsCount: data["postsCount"] as? Int ?? 0,  // Default zero for missing postsCount
                            bio: data["bio"] as? String)
            }
            DispatchQueue.main.async{
                self.user = fetchedUser
            }
        }
        catch{
            print("Error fetching users: \(error.localizedDescription)")
        }
    }
    
    func fetchFollowers(for userId: String) async {
            let db = Firestore.firestore()
            do {
                // Get the current user's document
                let userDoc = try await db.collection("Users").document(userId).getDocument()
                
                if let data = userDoc.data(),
                   let followerIds = data["followers"] as? [String] {
                    // Fetch users based on follower ids
                    var fetchedFollowers: [User] = []
                    for followerId in followerIds {
                        let userDoc = try await db.collection("Users").document(followerId).getDocument()
                        if let userData = userDoc.data() {
                            let user = User(id: userDoc.documentID,
                                            fullName: userData["fullName"] as? String ?? "Unknown",
                                            email: userData["email"] as? String ?? "",
                                            userName: userData["userName"] as? String ?? "",
                                            profileImageURL: userData["profileImageURL"] as? String,
                                            dob: (userData["dob"] as? Timestamp)?.dateValue() ?? Date(),
                                            gender: userData["gender"] as? String ?? "",
                                            followers: userData["followers"] as? [String] ?? [],
                                            followings: userData["followings"] as? [String] ?? [],
                                            postsCount: userData["postsCount"] as? Int ?? 0,
                                            bio: userData["bio"] as? String)
                            fetchedFollowers.append(user)
                        }
                    }
                    DispatchQueue.main.async{
                        self.followers = fetchedFollowers
                    }
                }
            } catch {
                print("Error fetching followers: \(error.localizedDescription)")
            }
        }
    
}
