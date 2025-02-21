//
//  OtherUserProfileViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 18/02/25.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class OtherUserProfileViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isLoading: Bool = false
    private var db = Firestore.firestore()
    @Published var othersPosts : [Posts] = []
    
    // Fetch user data from Firestore
    func fetchUser(by userId: String) {
        isLoading = true
        db.collection("Users").document(userId).getDocument { (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                self.isLoading = false
                return
            }
            
            if let document = document, document.exists {
                do {
                    // Decode user data from Firestore
                    let data = try document.data(as: User.self)
                    self.user = data
                } catch {
                    print("Error decoding user data: \(error.localizedDescription)")
                }
            }
            self.isLoading = false
        }
    }
    func fetchOthersPosts(userId: String) {
        db.collection("Posts")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching posts: \(error.localizedDescription)")
                } else {
                    self.othersPosts = snapshot?.documents.compactMap { document in
                        try? document.data(as: Posts.self)
                    } ?? []
                }
            }
    }
}

