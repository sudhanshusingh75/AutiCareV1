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
    
//    func fetchMyPosts(userId:String){
//        db.collection("Posts").whereField("userId", isEqualTo: userId).order(by: "timeStamp",descending: true).getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching posts: \(error.localizedDescription)")
//            } else {
//                // Map the documents to Post model
//                self.myPosts = snapshot?.documents.compactMap { document -> Posts? in
//                    try? document.data(as: Posts.self)
//                } ?? []
//            }
//        }
//    }
    
    func fetchMyPosts(userId:String){
        db.collection("Posts").whereField("userId",isEqualTo: userId).order(by: "createdAt",descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                self.myPosts = []
                return
            }
            var fetchedPosts:[Posts] = []
            let disPatchGroup = DispatchGroup()
            for doc in documents{
                do{
                    var post = try doc.data(as: Posts.self)
                    disPatchGroup.enter()
                    
                    //Fetch user info for each post
                    self.db.collection("Posts").document(post.userId).getDocument{userDoc,error in
                        if let userDoc = userDoc{
                            post.user = try? userDoc.data(as: User.self)
                        }
                        fetchedPosts.append(post)
                        disPatchGroup.leave()
                    }
                }
                catch{
                    print("❌ Error decoding post: \(error)")
                }
            }
            disPatchGroup.notify(queue: .main) {
                self.myPosts = fetchedPosts
            }
        }
    }
}
