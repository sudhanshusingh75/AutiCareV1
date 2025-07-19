//
//  FeedViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 11/02/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Supabase
import SwiftUI

class FeedViewModel: ObservableObject,Identifiable {
    @Published var posts: [Posts] = []
    @Published var isLoading: Bool = false
    private let db = Firestore.firestore()
    @Published var userId:String = (Auth.auth().currentUser?.uid ?? "")
    @Published var isDeleting = false


    let supabase = SupabaseClient(
        supabaseURL: URL(string: "https://zaaxtksuazyvxntlwmrn.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InphYXh0a3N1YXp5dnhudGx3bXJuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgzMTk2ODIsImV4cCI6MjA1Mzg5NTY4Mn0.5IBPLi4bdv0e04rWbaqqB9U3YDh23py4ieTijArJA8M"
    )
    
    init() {
        fetchAllPosts()
    }
    
    
    

    func fetchAllPosts() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        isLoading = true
        let db = Firestore.firestore()

        // Step 1: Fetch hidden posts
        db.collection("Users").document(userId).collection("hiddenPosts").getDocuments { hiddenSnapshot, error in
            let hiddenPostIds = hiddenSnapshot?.documents.map { $0.documentID } ?? []

            // Step 2: Fetch blocked users
            db.collection("Users").document(userId).collection("blockedUsers").getDocuments { blockedSnapshot, error in
                let blockedUserIds = blockedSnapshot?.documents.map { $0.documentID } ?? []

                // Step 3: Listen to all posts
                db.collection("Posts").order(by: "createdAt", descending: true).addSnapshotListener { snapshot, error in
                    if let error = error {
                        print("❌ Error listening for updates: \(error.localizedDescription)")
                        return
                    }

                    guard let snapshot = snapshot else {
                        print("❌ Error fetching posts: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }

                    let dispatchGroup = DispatchGroup()
                    var fetchedPosts: [Posts] = []

                    for document in snapshot.documents {
                        if var post = try? document.data(as: Posts.self),
                           !hiddenPostIds.contains(post.id),
                           !blockedUserIds.contains(post.userId) {

                            dispatchGroup.enter()
                            let userRef = db.collection("Users").document(post.userId)
                            userRef.getDocument { userDoc, error in
                                if let userData = try? userDoc?.data(as: User.self) {
                                    post.user = userData
                                }
                                fetchedPosts.append(post)
                                dispatchGroup.leave()
                            }
                        }
                    }

                    dispatchGroup.notify(queue: .main) {
                        self.posts = fetchedPosts.sorted(by: { $0.createdAt > $1.createdAt })
                        self.isLoading = false
                    }
                }
            }
        }
    }

    func fetchPosts(forTag tag: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        isLoading = true

        // Step 1: Fetch hidden post IDs
        db.collection("Users").document(userId).collection("hiddenPosts").getDocuments { hiddenSnapshot, error in
            let hiddenPostIds = hiddenSnapshot?.documents.map { $0.documentID } ?? []

            // Step 2: Fetch blocked user IDs
            self.db.collection("Users").document(userId).collection("blockedUsers").getDocuments { blockedSnapshot, error in
                let blockedUserIds = blockedSnapshot?.documents.map { $0.documentID } ?? []

                // Step 3: Fetch tag-specific posts
                self.db.collection("Posts")
                    .whereField("tag", arrayContains: tag)
                    .order(by: "createdAt", descending: true)
                    .addSnapshotListener { snapshot, error in
                        if let error = error {
                            print("❌ Error listening for tag posts: \(error.localizedDescription)")
                            return
                        }

                        guard let snapshot = snapshot else {
                            print("❌ Error fetching tag posts: \(error?.localizedDescription ?? "Unknown error")")
                            return
                        }

                        let dispatchGroup = DispatchGroup()
                        var fetchedPosts: [Posts] = []

                        for document in snapshot.documents {
                            if var post = try? document.data(as: Posts.self),
                               !hiddenPostIds.contains(post.id),
                               !blockedUserIds.contains(post.userId) {

                                dispatchGroup.enter()
                                let userRef = self.db.collection("Users").document(post.userId)
                                userRef.getDocument { userDoc, error in
                                    if let userData = try? userDoc?.data(as: User.self) {
                                        post.user = userData
                                    }
                                    fetchedPosts.append(post)
                                    dispatchGroup.leave()
                                }
                            }
                        }

                        dispatchGroup.notify(queue: .main) {
                            self.posts = fetchedPosts.sorted(by: { $0.createdAt > $1.createdAt })
                            self.isLoading = false
                        }
                    }
            }
        }
    }


    func toggleLike(for post: Posts) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }

        var updatedPost = posts[index]
        let wasLiked = updatedPost.likedBy.contains(userId)

        if wasLiked {
            updatedPost.likedBy.removeAll { $0 == userId }
            updatedPost.likesCount -= 1
        } else {
            updatedPost.likedBy.append(userId)
            updatedPost.likesCount += 1
        }

        // 🔥 Optimistically update the UI
        DispatchQueue.main.async {
            self.posts[index] = updatedPost
        }

        let postRef = db.collection("Posts").document(post.id)
        postRef.updateData([
            "likedBy": updatedPost.likedBy,
            "likesCount": updatedPost.likesCount
        ]) { error in
            if let error = error {
                print("❌ Error updating like: \(error.localizedDescription)")
                
                // 🚨 Rollback the UI if Firestore update fails
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return } // Prevent retain cycles

                    if wasLiked {
                        self.posts[index].likedBy.append(self.userId) // ✅ Explicit 'self'
                        self.posts[index].likesCount += 1
                    } else {
                        self.posts[index].likedBy.removeAll { $0 == self.userId } // ✅ Explicit 'self'
                        self.posts[index].likesCount -= 1
                    }
                }

            }
        }
    }
    
    func deletePost(post: Posts) async {
        guard (Auth.auth().currentUser?.uid) != nil else {
            print("❌ No authenticated user found.")
            return
        }

        await MainActor.run { self.isDeleting = true } // ✅ Ensure UI update on main thread
        let db = Firestore.firestore()

        do {
            // ✅ Step 1: Delete images from Supabase (Concurrent Execution)
            if !post.imageURL.isEmpty {
                await withTaskGroup(of: Void.self) { group in
                    for imageUrl in post.imageURL {
                        group.addTask { [weak self] in
                            guard let self = self else { return }
                            do {
                                try await self.deleteImageFromSupabase(imageUrl)
                            } catch {
                                await MainActor.run {
                                    print("❌ Error deleting image: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            }

            // ✅ Step 2: Delete post from Firestore
            let commentQuery = db.collection("Comments").whereField("postId", isEqualTo: post.id)
            let commentDocument = try await commentQuery.getDocuments()
            for comment in commentDocument.documents{
                let commentId = comment.documentID
                try await db.collection("Comments").document(commentId).delete()
                print("✅ Comments deleted Sucessfully:\(commentId)")
            }
            
            try await db.collection("Posts").document(post.id).delete()
            
            
            // ✅ Step 3: Remove post from user's "posts" array
            let userRef = db.collection("Users").document(post.userId)
            try await userRef.updateData([
                "posts": FieldValue.arrayRemove([post.id]), // ✅ Store only post ID for deletion
                "postsCount":FieldValue.increment(Int64(-1))
            ])

            // ✅ Step 4: Update UI safely
            await MainActor.run {
                self.posts.removeAll { $0.id == post.id }
                self.isDeleting = false
            }

            print("✅ Post deleted successfully!")

        } catch {
            await MainActor.run {
                print("❌ Error deleting post: \(error.localizedDescription)")
                self.isDeleting = false
            }
        }
    }
    
    func timeFormatter(from timeStamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let formatter = DateComponentsFormatter()
        
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.allowsFractionalUnits = false
        
        if let timeString = formatter.string(from: date, to: Date()) {
            return "\(timeString) ago"
        } else {
            return "Just now"
        }
    }
    
    private func deleteImageFromSupabase(_ imageUrl: String) async throws {
        guard let url = URL(string: imageUrl) else { return }
        let path = url.pathComponents.suffix(2).joined(separator: "/") // Extract correct path
        
        do {
           let path = try await supabase.storage.from("user-uploads").remove(paths: [path])
            print("✅ Image deleted from Supabase: \(imageUrl)")
        } catch {
            print("❌ Error deleting image from Supabase: \(error.localizedDescription)")
        }
    }

    
    func isLiked(post: Posts) -> Bool {
        return post.likedBy.contains(userId)
    }

    func removeFromFeed(postId: String, reason: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("Users")
          .document(userId)
          .collection("hiddenPosts")
          .document(postId)
          .setData([
              "reason": reason,
              "timestamp": Timestamp(date: Date())
          ]) { error in
              if let error = error {
                  print("Error: \(error.localizedDescription)")
              } else {
                  // Remove from feed list in app
                  DispatchQueue.main.async {
                      self.posts.removeAll { $0.id == postId }
                  }
              }
          }
    }

    func reportPost(postId: String/*, reason: String*/) async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let reportId = UUID().uuidString
        let report = Report(
            id: reportId, postId: postId,
            reportedBy: userId, reson: "",
            timeStamp: Date().timeIntervalSince1970
        )

        do {
            let _ = try db.collection("reports").addDocument(from: report)
            print("Post reported successfully!")
        } catch {
            print("Error reporting post: \(error.localizedDescription)")
            throw error
        }
    }

}


