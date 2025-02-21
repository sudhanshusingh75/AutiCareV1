import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Supabase

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    private let supabase: SupabaseClient
    private let storage: SupabaseStorageClient
    
    struct MissingFirebaseTokenError: Error {}

    init() {
        self.userSession = Auth.auth().currentUser
        
        self.supabase = SupabaseClient(
            supabaseURL: URL(string: "https://zaaxtksuazyvxntlwmrn.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InphYXh0a3N1YXp5dnhudGx3bXJuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgzMTk2ODIsImV4cCI6MjA1Mzg5NTY4Mn0.5IBPLi4bdv0e04rWbaqqB9U3YDh23py4ieTijArJA8M"
        )
        self.storage = supabase.storage

        Task {
            await refreshAuthState()
            await fetchUser()
            
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("❌ Error \(error.localizedDescription)")
            throw error
        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String, profileImage: UIImage?,userName:String,dateOfBirth:Date,gender:String) async throws {
        do {
            // Create user in Firebase Auth
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            // Ensure user session is available
            guard let userSession = self.userSession else {
                throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User session not found."])
            }
            
            var profileImageURL: String? = ""
            
            // Upload profile image if available
            if let profileImage {
                profileImageURL = try await uploadProfileImage(image: profileImage, userId: userSession.uid)
            }
            
            // Construct User object with safe default values
            let newUser = User(
                id: userSession.uid,
                fullName: fullName,
                email: email,
                userName: userName,
                profileImageURL: profileImageURL,
                location: "",
                dob: dateOfBirth,
                gender: gender,
                followers: [],
                followings: [],
                postsCount: 0,
                bio: ""
            )
            
            let encodedUser = try Firestore.Encoder().encode(newUser)
            
            // Save user data in Firestore
            try await Firestore.firestore().collection("Users").document(newUser.id).setData(encodedUser)
            
            // Fetch user data after creating the account
            await fetchUser()
        } catch {
            print("⚠️ Failed to create a user with error: \(error.localizedDescription)")
            throw error
        }
    }

    func checkUsernameUniqueness(_ username: String) async -> Bool {
            do {
                let snapshot = try await Firestore.firestore().collection("Users")
                    .whereField("userName", isEqualTo: username)
                    .getDocuments()
                
                return snapshot.documents.isEmpty  // ✅ Returns true if unique
            } catch {
                print("Error checking username: \(error.localizedDescription)")
                return false
            }
        }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("⚠️ Failed to sign out with error \(error.localizedDescription)")
        }
    }
    func deleteAccount() async {
        guard let user = Auth.auth().currentUser else { return }
        
        do {
            // Step 1: Delete user data from Firestore
            let userId = user.uid
            
            let followersQuery = Firestore.firestore().collection("Users").whereField("followers", arrayContains: userId)
                    let followersSnapshot = try await followersQuery.getDocuments()

                    for document in followersSnapshot.documents {
                        let userDocId = document.documentID
                        try await Firestore.firestore().collection("Users").document(userDocId).updateData([
                            "followers": FieldValue.arrayRemove([userId])
                        ])
                        print("✅ Removed user from \(userDocId)'s followers list")
                    }

                    // Step 2: Remove all "following" references
                    let followingQuery = Firestore.firestore().collection("Users").whereField("followings", arrayContains: userId)
                    let followingSnapshot = try await followingQuery.getDocuments()

                    for document in followingSnapshot.documents {
                        let userDocId = document.documentID
                        try await Firestore.firestore().collection("Users").document(userDocId).updateData([
                            "following": FieldValue.arrayRemove([userId])
                        ])
                        print("✅ Removed user from \(userDocId)'s following list")
                    }
            
            let postQuery = Firestore.firestore().collection("Posts").whereField("userId",isEqualTo: userId)
            let postDocument = try await postQuery.getDocuments()
            
            for document in postDocument.documents {
                        let postId = document.documentID
                let commentQuery = Firestore.firestore().collection("Comments").whereField("postId", isEqualTo: postId)
                let commentDocument = try await commentQuery.getDocuments()
                for document in commentDocument.documents{
                    let commentId = document.documentID
                    try await Firestore.firestore().collection("Comments").document(commentId).delete()
                    print("✅ Deleted Comment: \(commentId)")
                }
                try await Firestore.firestore().collection("Posts").document(postId).delete()
                        print("✅ Deleted post: \(postId)")

                        // Optional: Delete associated images from Supabase Storage
                        let imagePath = "Post_Images/\(postId).jpg" // Adjust based on your storage path
                        do {
                            try await storage.from("user-uploads").remove(paths: [imagePath])
                            print("✅ Deleted post image: \(imagePath)")
                        } catch {
                            print("⚠️ Failed to delete post image: \(error.localizedDescription)")
                        }
                    }
            
            try await Firestore.firestore().collection("Users").document(userId).delete()
            print("✅ User data deleted from Firestore")
            
            // Step 2: Delete profile image from Supabase Storage
            let filePath = "Profile_Image/\(userId).jpg"
            do {
                try await storage.from("user-uploads").remove(paths: [filePath])
                print("✅ Profile image deleted from Supabase Storage")
            } catch {
                print("⚠️ Failed to delete profile image: \(error.localizedDescription)")
            }
            
            // Step 3: Delete Firebase Authentication account
            try await user.delete()
            print("✅ User account deleted from Firebase Auth")
            
            // Step 4: Clear session
            self.userSession = nil
            self.currentUser = nil
            
        } catch {
            print("❌ Error deleting account: \(error.localizedDescription)")
        }
    }


    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await Firestore.firestore().collection("Users").document(uid).getDocument()
            
            // Decode the data into a User object
            self.currentUser = try snapshot.data(as: User.self)
            
        } catch {
            print("DEBUG: Failed to fetch user data with error \(error.localizedDescription)")
        }
    }


    func uploadProfileImage(image: UIImage, userId: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Image"])
        }

        let fileName = "Profile_Image/\(userId)_\(UUID().uuidString).jpg"
        
        do {
            // Upload Image to Supabase Storage
            let _ = try await storage.from("user-uploads").upload(fileName, data: imageData)
            
            // Get Public URL
            let downloadURL = try await storage.from("user-uploads").getPublicURL(path: fileName).absoluteString
            
            print("✅ Image uploaded successfully: \(downloadURL)")
            return downloadURL
        } catch {
            throw NSError(domain: "UploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to upload image to Supabase Storage"])
        }
    }
    
    func refreshAuthState() async {
            do {
                try await Auth.auth().currentUser?.reload()
                self.userSession = Auth.auth().currentUser
                print("✅ Auth state refreshed: \(String(describing: userSession?.email))")
            } catch {
                print("⚠️ Failed to refresh auth state: \(error.localizedDescription)")
            }
        }
    
}

