import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class OtherUserProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var othersPosts: [Posts] = []
    @Published var isFollowing: Bool?  // Optional to detect change from nil → true/false

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    // MARK: - Fetch User
    func fetchUser(by userId: String) {
        db.collection("Users").document(userId).getDocument { snapshot, error in
            if let error = error {
                print("❌ Error fetching user: \(error.localizedDescription)")
                return
            }

            if let snapshot = snapshot {
                do {
                    self.user = try snapshot.data(as: User.self)
                } catch {
                    print("❌ Failed to decode user: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Fetch Posts
    func fetchOthersPosts(userId: String) {
        print("📥 Fetching posts for user: \(userId)")
        
        db.collection("Posts")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Failed to fetch posts: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("⚠️ No documents found")
                    return
                }
                
                let posts = documents.compactMap { try? $0.data(as: Posts.self) }
                print("✅ Fetched \(posts.count) posts")
                self.othersPosts = posts
            }
    }


    // MARK: - Follow User
    func followUser(targetUserId: String) {
        guard let currentUserId else { return }

        let followingRef = db.collection("Users").document(currentUserId).collection("following").document(targetUserId)
        let followersRef = db.collection("Users").document(targetUserId).collection("followers").document(currentUserId)

        let currentUserDoc = db.collection("Users").document(currentUserId)
        let targetUserDoc = db.collection("Users").document(targetUserId)

        let batch = db.batch()
        
        batch.setData([:], forDocument: followingRef) // Add to current user's following
        batch.setData([:], forDocument: followersRef) // Add to target user's followers

        // Increment counts
        batch.updateData(["followingCount": FieldValue.increment(Int64(1))], forDocument: currentUserDoc)
        batch.updateData(["followersCount": FieldValue.increment(Int64(1))], forDocument: targetUserDoc)

        batch.commit { error in
            if let error = error {
                print("❌ Error following user: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self.isFollowing = true
            }
        }
    }


    // MARK: - Unfollow User
    func unfollowUser(targetUserId: String) {
        guard let currentUserId else { return }

        let followingRef = db.collection("Users").document(currentUserId).collection("following").document(targetUserId)
        let followersRef = db.collection("Users").document(targetUserId).collection("followers").document(currentUserId)

        let currentUserDoc = db.collection("Users").document(currentUserId)
        let targetUserDoc = db.collection("Users").document(targetUserId)

        let batch = db.batch()

        batch.deleteDocument(followingRef) // Remove from following
        batch.deleteDocument(followersRef) // Remove from followers

        // Decrement counts
        batch.updateData(["followingCount": FieldValue.increment(Int64(-1))], forDocument: currentUserDoc)
        batch.updateData(["followersCount": FieldValue.increment(Int64(-1))], forDocument: targetUserDoc)

        batch.commit { error in
            if let error = error {
                print("❌ Error unfollowing user: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self.isFollowing = false
                self.othersPosts = []
            }
        }
    }


    // MARK: - Observe Realtime Follow Status
    func observeFollowStatus(targetUserId: String) {
        guard let currentUserId else { return }

        // Prevent duplicate listeners
//        listener?.remove()

        listener = db.collection("Users")
            .document(currentUserId)
            .collection("following")
            .document(targetUserId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }

                if let error = error {
                    print("❌ Listener error: \(error.localizedDescription)")
                    return
                }

                let followed = snapshot?.exists ?? false
                print("🔁 Realtime follow status for \(targetUserId): \(followed)")

                // Only update if value changed
                if self.isFollowing != followed {
                    DispatchQueue.main.async {
                        self.isFollowing = followed
                        if followed {
                            self.fetchOthersPosts(userId: targetUserId)
                        } else {
                            self.othersPosts = []
                        }
                    }
                }
            }
    }
    
    @MainActor
    func toggleFollow(for userId: String) async {
        if isFollowing == true {
            unfollowUser(targetUserId: userId)
        } else {
            followUser(targetUserId: userId)
        }
    }
    
    

    // MARK: - Cleanup
    deinit {
        listener?.remove()
        print("🧹 Listener removed from OtherUserProfileViewModel")
    }
}
