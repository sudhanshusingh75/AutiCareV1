//
//  CommentViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 13/02/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class CommentViewModel: ObservableObject {
    @Published var comments: [Comments] = []
    private let db = Firestore.firestore()
    let postId: String
    
    init(postId: String) {
        self.postId = postId
    }
    
//    func fetchComments() {
//        db.collection("Comments")
//            .whereField("postId", isEqualTo: self.postId) // ✅ Explicitly use 'self'
//            .order(by: "createdAt", descending: true)
//            .addSnapshotListener { [weak self] snapshot, error in
//                guard let self = self else { return } // ✅ Prevent retain cycles
//                
//                if let error = error {
//                    print("❌ Error fetching comments: \(error.localizedDescription)")
//                    return
//                }
//                
//                guard let snapshot = snapshot, !snapshot.documents.isEmpty else {
//                    DispatchQueue.main.async {
//                        self.comments = [] // ✅ Clear comments if no data
//                    }
//                    print("⚠️ No comments found.")
//                    return
//                }
//                
//                DispatchQueue.main.async {
//                    self.comments = snapshot.documents.compactMap { doc in
//                        do {
//                            return try doc.data(as: Comments.self)
//                        } catch {
//                            print("❌ Error decoding comment: \(error.localizedDescription)")
//                            return nil
//                        }
//                    }
//                    print("✅ Successfully fetched \(self.comments.count) comments.")
//                }
//            }
//    }
    
    func fetchComments() {
        db.collection("Comments")
            .whereField("postId", isEqualTo: self.postId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("❌ Error fetching comments: \(error.localizedDescription)")
                    return
                }

                guard let snapshot = snapshot else {
                    DispatchQueue.main.async { self.comments = [] }
                    print("⚠️ No comments found.")
                    return
                }

                let dispatchGroup = DispatchGroup()
                var fetchedComments: [Comments] = []

                for document in snapshot.documents {
                    do {
                        var comment = try document.data(as: Comments.self)
                        dispatchGroup.enter()
                        
                        // Fetch user info
                        self.db.collection("Users").document(comment.userId).getDocument { userDoc, error in
                            if let user = try? userDoc?.data(as: User.self) {
                                comment.user = user
                            }
                            fetchedComments.append(comment)
                            dispatchGroup.leave()
                        }
                    } catch {
                        print("❌ Error decoding comment: \(error.localizedDescription)")
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self.comments = fetchedComments.sorted { $0.createdAt > $1.createdAt }
                    print("✅ Successfully fetched \(self.comments.count) comments.")
                }
            }
    }

    
    
    func addComment(content: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let userRef = db.collection("Users").document(userId)
        
        userRef.getDocument { [weak self] document, error in
            guard let self = self else { return } // ✅ Prevent retain cycle
            
            if let error = error {
                print("❌ Error fetching user details: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists,
                  let userData = try? document.data(as: User.self) else {
                print("⚠️ User data not found in Firestore")
                return
            }
            
            let commentId = UUID().uuidString
            let newComment = Comments(
                id: commentId,
                postId: self.postId, // ✅ Reference the correct post
                userId: userData.id,
                user: nil,
                content: content,
                createdAt: Date().timeIntervalSince1970
            )
            
            let postRef = db.collection("Posts").document(self.postId) // ✅ Post reference
            let commentRef = db.collection("Comments").document(commentId) // ✅ Comment reference
            
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                do {
                    // 🔹 Step 1: Read post document
                    let postSnapshot = try transaction.getDocument(postRef)
                    
                    guard postSnapshot.exists else {
                        print("❌ Error: Post not found")
                        return nil
                    }
                    
                    let currentCommentCount = postSnapshot.data()?["commentsCount"] as? Int ?? 0
                    
                    // 🔹 Step 2: Write operations
                    try transaction.setData(from: newComment, forDocument: commentRef) // ✅ Add comment
                    transaction.updateData(["commentsCount": currentCommentCount + 1], forDocument: postRef) // ✅ Only update count
                    
                } catch {
                    errorPointer?.pointee = error as NSError
                    return nil
                }
                return nil
            }) { (object, error) in
                if let error = error {
                    print("❌ Transaction failed: \(error.localizedDescription)")
                } else {
                    print("✅ Comment added successfully and comment count updated!")
                }
            }
        }
    }
    
    func deleteComment(commentId: String, postId: String) {
        let commentRef = db.collection("Comments").document(commentId)
        let postRef = db.collection("Posts").document(postId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                // 🔹 Step 1: Read post document
                let postSnapshot = try transaction.getDocument(postRef)
                guard var postData = postSnapshot.data() else {
                    print("❌ Error: Post not found")
                    return nil
                }
                
                // 🔹 Step 2: Get current comments count & decrement
                let currentCommentCount = postData["commentsCount"] as? Int ?? 0
                postData["commentsCount"] = max(0, currentCommentCount - 1) // Ensure it doesn't go negative
                
                // 🔹 Step 3: Delete the comment & update the post
                transaction.deleteDocument(commentRef) // ✅ Delete comment
                transaction.setData(postData, forDocument: postRef, merge: true) // ✅ Update post
                
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            return nil
        }) { (object, error) in
            if let error = error {
                print("❌ Failed to delete comment: \(error.localizedDescription)")
            } else {
                print("✅ Comment deleted successfully and comment count updated!")
            }
        }
    }


}
