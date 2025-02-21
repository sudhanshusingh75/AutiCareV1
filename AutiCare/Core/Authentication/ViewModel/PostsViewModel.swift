//
//  PostsViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 19/02/25.
//

import Foundation
import FirebaseFirestore

class PostsViewModel:ObservableObject{
    @Published var myPosts: [Posts] = []
    let db = Firestore.firestore()
    
    func fetchMyPosts(userId:String){
        db.collection("Posts").whereField("userId", isEqualTo: userId).order(by: "timeStamp",descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
            } else {
                // Map the documents to Post model
                self.myPosts = snapshot?.documents.compactMap { document -> Posts? in
                    try? document.data(as: Posts.self)
                } ?? []
            }
        }
    }
    
}
