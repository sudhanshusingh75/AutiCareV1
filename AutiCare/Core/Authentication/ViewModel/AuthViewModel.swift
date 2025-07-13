import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Supabase
import SwiftUI

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var completedSignUp: Bool = false
    @Published var emailVerfied: Bool = false
    @Published var isLoading:Bool = true
    
    private var listener:ListenerRegistration?
    private var db = Firestore.firestore()
    
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
            
        }
    }
    deinit{
        listener?.remove()
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            if result.user.isEmailVerified{
                await refreshAuthState()
            }
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = error.localizedDescription
                self.showAlert = true
            }
        }
    }
    
    func completeUserProfile(fullName: String,profileImage: UIImage?,userName: String,dateOfBirth: Date,gender: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user found."])
        }
        var profileImageURL: String? = ""
        
        if let profileImage {
            profileImageURL = try await uploadProfileImage(image: profileImage, userId: user.uid)
        }
        
        let newUser = User(
            id: user.uid,
            fullName: fullName,
            email: user.email ?? "",
            userName: userName,
            profileImageURL: profileImageURL,
            location: "",
            dob: dateOfBirth,
            gender: gender,
            isProfileComplete: true, followersCount: 0,
            followingCount: 0,
            postsCount: 0,
            bio: ""
        )
        
        let encodedUser = try Firestore.Encoder().encode(newUser)
        
        try await db.collection("Users").document(newUser.id).setData(encodedUser)
        
        await fetchUser()
        
    }
    
    func checkUsernameUniqueness(_ username: String) async -> Bool {
        do {
            let snapshot = try await db.collection("Users")
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
    
    func sendVerificationEmail() async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "Auticare.Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No user signed in"])
        }
        try await user.sendEmailVerification()
    }
    
    func isEmailVerified() async -> Bool {
        do{
            try await Auth.auth().currentUser?.reload()
            self.emailVerfied = Auth.auth().currentUser?.isEmailVerified ?? false
            return emailVerfied
        }
        catch{
            return false
        }
    }
    
    func deleteAccount(password: String) async {
        guard let user = Auth.auth().currentUser,
              let email = user.email else { return }
        
        do {
            let userId = user.uid
            
            // Step 1: Reauthenticate
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            try await user.reauthenticate(with: credential)
            print("✅ Reauthentication successful")
            
            // Step 2: Remove from followers
            let followersQuery = db.collection("Users").whereField("followers", arrayContains: userId)
            let followersSnapshot = try await followersQuery.getDocuments()
            for document in followersSnapshot.documents {
                try await db.collection("Users").document(document.documentID).updateData([
                    "followers": FieldValue.arrayRemove([userId])
                ])
                print("✅ Removed from \(document.documentID)'s followers")
            }
            
            // Step 3: Remove from following
            let followingQuery = db.collection("Users").whereField("followings", arrayContains: userId)
            let followingSnapshot = try await followingQuery.getDocuments()
            for document in followingSnapshot.documents {
                try await db.collection("Users").document(document.documentID).updateData([
                    "followings": FieldValue.arrayRemove([userId])
                ])
                print("✅ Removed from \(document.documentID)'s followings")
            }
            
            // Step 4: Delete user's posts and comments
            let postQuery = db.collection("Posts").whereField("userId", isEqualTo: userId)
            let postSnapshot = try await postQuery.getDocuments()
            for postDoc in postSnapshot.documents {
                let postId = postDoc.documentID
                
                // Delete comments for each post
                let commentQuery = db.collection("Comments").whereField("postId", isEqualTo: postId)
                let commentSnapshot = try await commentQuery.getDocuments()
                for commentDoc in commentSnapshot.documents {
                    try await db.collection("Comments").document(commentDoc.documentID).delete()
                    print("✅ Deleted comment \(commentDoc.documentID)")
                }
                
                // Delete post image
                let imagePath = "Post_Images/\(postId).jpg"
                do {
                   let path = try await storage.from("user-uploads").remove(paths: [imagePath])
                    print("✅ Deleted post image: \(imagePath)")
                } catch {
                    print("⚠️ Failed to delete post image: \(error.localizedDescription)")
                }
                
                try await db.collection("Posts").document(postId).delete()
                print("✅ Deleted post: \(postId)")
            }
            
            // Step 5: Delete user Firestore data
            try await db.collection("Users").document(userId).delete()
            print("✅ Deleted user document from Firestore")
            
            // Step 6: Delete profile image from Supabase
            let profilePath = "Profile_Image/\(userId).jpg"
            do {
                let path = try await storage.from("user-uploads").remove(paths: [profilePath])
                print("✅ Deleted profile image: \(profilePath)")
            } catch {
                print("⚠️ Failed to delete profile image: \(error.localizedDescription)")
            }
            
            // Step 7: Delete Firebase Authentication account
            try await user.delete()
            print("✅ User deleted from Firebase Auth")
            
            // Step 8: Clear session
            self.userSession = nil
            self.currentUser = nil
            
            await refreshAuthState()
            
        } catch {
            print("❌ Error deleting account: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.currentUser = nil
            return
        }
        do {
            let doc = try await db.collection("Users").document(uid).getDocument()

            guard doc.data() != nil else {
                print("❌ No user data found.")
                DispatchQueue.main.async {
                    self.completedSignUp = false
                }
                return
            }

            let user = try doc.data(as: User.self)

            DispatchQueue.main.async {
                self.currentUser = user
                self.completedSignUp = user.isProfileComplete
            }

        } catch {
            print("❌ Error fetching user: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.currentUser = nil
                self.completedSignUp = false
            }
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
            let downloadURL = try storage.from("user-uploads").getPublicURL(path: fileName).absoluteString
            
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
            self.emailVerfied = await isEmailVerified()
            if userSession != nil{
                await fetchUser()
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
            print("✅ Auth state refreshed: \(String(describing: userSession?.email))")
        } catch {
            print("⚠️ Failed to refresh auth state: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func forgotPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print("Error sending reset link:", error.localizedDescription)
            throw error // ✅ This is the key change
        }
    }
}

