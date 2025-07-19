//
//  BlockedUsersListViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 19/07/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class BlockedUsersListViewModel: ObservableObject {
    @Published var blockedUsers: [User] = []
    
    private let db = Firestore.firestore()
    private let currentUserId = Auth.auth().currentUser?.uid ?? ""

    func loadBlockedUsers() async {
        let blockedIDs = await getBlockedUserIDs()
        var users: [User] = []
        
        for id in blockedIDs {
            if let user = try? await fetchUser(with: id) {
                users.append(user)
            }
        }
        self.blockedUsers = users
    }

    func unblockUser(userId: String) async {
        let ref = db.collection("Users")
            .document(currentUserId)
            .collection("blockedUsers")
            .document(userId)

        do {
            try await ref.delete()
            blockedUsers.removeAll { $0.id == userId }
        } catch {
            print("Error unblocking user:", error)
        }
    }

    private func getBlockedUserIDs() async -> [String] {
        let ref = db.collection("Users")
            .document(currentUserId)
            .collection("blockedUsers")
        
        do {
            let snapshot = try await ref.getDocuments()
            return snapshot.documents.map { $0.documentID }
        } catch {
            print("Failed to fetch blocked user IDs:", error)
            return []
        }
    }

    private func fetchUser(with id: String) async throws -> User? {
        let doc = try await db.collection("Users").document(id).getDocument()
        return try? doc.data(as: User.self)
    }
}
