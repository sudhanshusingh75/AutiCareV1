import Foundation
import FirebaseFirestore

class SearchViewModel: ObservableObject {
    @Published var user: [User] = []
    @Published var searchText: String = ""
    @Published var followers: [User] = []
    @Published var followings: [User] = []
    
    private let db = Firestore.firestore()
    
    // MARK: - Fetch All Users (with search)
    func fetchAllUsers() async {
        var query: Query = db.collection("Users")
        
        if !searchText.isEmpty {
            query = query
                .whereField("fullName", isGreaterThanOrEqualTo: searchText)
                .whereField("fullName", isLessThanOrEqualTo: searchText + "\u{f8ff}")
        }
        
        do {
            let snapshot = try await query.getDocuments()
            let fetchedUsers: [User] = snapshot.documents.compactMap { doc in
                let data = doc.data()
                return User(
                    id: doc.documentID,
                    fullName: data["fullName"] as? String ?? "Unknown",
                    email: data["email"] as? String ?? "",
                    userName: data["userName"] as? String ?? "",
                    profileImageURL: data["profileImageURL"] as? String,
                    dob: (data["dob"] as? Timestamp)?.dateValue() ?? Date(),
                    gender: data["gender"] as? String ?? "",
                    followersCount: data["followersCount"] as? Int ?? 0,
                    followingCount: data["followingCount"] as? Int ?? 0,
                    postsCount: data["postsCount"] as? Int ?? 0,
                    bio: data["bio"] as? String
                )
            }
            DispatchQueue.main.async {
                self.user = fetchedUsers
            }
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Fetch Followers using subcollection
    func fetchFollowers(for userId: String) async {
        do {
            let snapshot = try await db.collection("Users")
                .document(userId)
                .collection("followers")
                .getDocuments()
            
            let followerIds = snapshot.documents.map { $0.documentID }
            var fetchedFollowers: [User] = []
            
            for id in followerIds {
                let doc = try await db.collection("Users").document(id).getDocument()
                if let data = doc.data() {
                    let user = User(
                        id: doc.documentID,
                        fullName: data["fullName"] as? String ?? "Unknown",
                        email: data["email"] as? String ?? "",
                        userName: data["userName"] as? String ?? "",
                        profileImageURL: data["profileImageURL"] as? String,
                        dob: (data["dob"] as? Timestamp)?.dateValue() ?? Date(),
                        gender: data["gender"] as? String ?? "",
                        followersCount: data["followersCount"] as? Int ?? 0,
                        followingCount: data["followingCount"] as? Int ?? 0,
                        postsCount: data["postsCount"] as? Int ?? 0,
                        bio: data["bio"] as? String
                    )
                    fetchedFollowers.append(user)
                }
            }
            
            DispatchQueue.main.async {
                self.followers = fetchedFollowers
            }
        } catch {
            print("Error fetching followers: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Fetch Followings using subcollection
    func fetchFollowings(for userId: String) async {
        do {
            let snapshot = try await db.collection("Users")
                .document(userId)
                .collection("following")
                .getDocuments()
            
            let followingIds = snapshot.documents.map { $0.documentID }
            var fetchedFollowings: [User] = []
            
            for id in followingIds {
                let doc = try await db.collection("Users").document(id).getDocument()
                if let data = doc.data() {
                    let user = User(
                        id: doc.documentID,
                        fullName: data["fullName"] as? String ?? "Unknown",
                        email: data["email"] as? String ?? "",
                        userName: data["userName"] as? String ?? "",
                        profileImageURL: data["profileImageURL"] as? String,
                        dob: (data["dob"] as? Timestamp)?.dateValue() ?? Date(),
                        gender: data["gender"] as? String ?? "",
                        followersCount: data["followersCount"] as? Int ?? 0,
                        followingCount: data["followingCount"] as? Int ?? 0,
                        postsCount: data["postsCount"] as? Int ?? 0,
                        bio: data["bio"] as? String
                    )
                    fetchedFollowings.append(user)
                }
            }
            
            DispatchQueue.main.async {
                self.followings = fetchedFollowings
            }
        } catch {
            print("Error fetching followings: \(error.localizedDescription)")
        }
    }
}
