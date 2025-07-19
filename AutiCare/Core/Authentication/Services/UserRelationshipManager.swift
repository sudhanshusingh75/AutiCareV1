//
//  UserRelationshipManager.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 19/07/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserRelationshipManager: ObservableObject {
    private let db = Firestore.firestore()
    private let currentUserId = Auth.auth().currentUser?.uid ?? ""
    @Published var blockedUserIds: Set<String> = []
    
    init() {
        listenToBlockedUsers()
    }
    private func listenToBlockedUsers() {
        guard !currentUserId.isEmpty else { return }
        
        db.collection("Users")
            .document(currentUserId)
            .collection("blockedUsers")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self?.blockedUserIds = Set(documents.map { $0.documentID })
            }
    }
    
    func blockUser(userId: String) async {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        let currentUserRef = db.collection("Users").document(currentUserId)
        let targetUserRef = db.collection("Users").document(userId)

        let followingRef = currentUserRef.collection("following").document(userId)
        let followerRef = targetUserRef.collection("followers").document(currentUserId)

        let reverseFollowerRef = currentUserRef.collection("followers").document(userId)
        let reverseFollowingRef = targetUserRef.collection("following").document(currentUserId)

        do {
            let followingDoc = try await followingRef.getDocument()
            if followingDoc.exists {
                // You are following them, remove it
                try await followingRef.delete()
                try await currentUserRef.updateData([
                    "followingCount": FieldValue.increment(Int64(-1))
                ])
            }

            let reverseFollowerDoc = try await reverseFollowerRef.getDocument()
            if reverseFollowerDoc.exists {
                // They are following you, remove it
                try await reverseFollowerRef.delete()
                try await currentUserRef.updateData([
                    "followersCount": FieldValue.increment(Int64(-1))
                ])
            }

            // Optional: remove reverse following doc (clean up)
            let reverseFollowingDoc = try await reverseFollowingRef.getDocument()
            if reverseFollowingDoc.exists {
                try await reverseFollowingRef.delete()
                try await targetUserRef.updateData([
                    "followingCount": FieldValue.increment(Int64(-1))
                ])
            }

            // Optional: remove you from their followers as well (clean up)
            let followerDoc = try await followerRef.getDocument()
            if followerDoc.exists {
                try await followerRef.delete()
                try await targetUserRef.updateData([
                    "followersCount": FieldValue.increment(Int64(-1))
                ])
            }

            // Block user
            try await currentUserRef.collection("blockedUsers").document(userId).setData([
                "timestamp": Timestamp()
            ])

        } catch {
            print("Error blocking user: \(error)")
        }
    }

    
    func unblockUser(_ targetUserId: String) async {
        let ref = db.collection("Users")
            .document(currentUserId)
            .collection("blockedUsers")
            .document(targetUserId)
        try? await ref.delete()
    }
    
    func isUserBlocked(_ targetUserId: String) async -> Bool {
        let doc = try? await db.collection("Users")
            .document(currentUserId)
            .collection("blockedUsers")
            .document(targetUserId)
            .getDocument()
        return doc?.exists ?? false
    }
    
    func hasBlockedMe(_ targetUserId: String) async -> Bool {
        let doc = try? await db.collection("Users")
            .document(targetUserId)
            .collection("blockedUsers")
            .document(currentUserId)
            .getDocument()
        return doc?.exists ?? false
    }
    
    func getBlockedUserIDs() async -> [String] {
        let ref = db.collection("Users")
            .document(currentUserId)
            .collection("blockedUsers")
        
        do {
            let snapshot = try await ref.getDocuments()
            let blockedUserIDs = snapshot.documents.map { $0.documentID }
            return blockedUserIDs
        } catch {
            print("Failed to fetch blocked user IDs:", error)
            return []
        }
    }
    
}

