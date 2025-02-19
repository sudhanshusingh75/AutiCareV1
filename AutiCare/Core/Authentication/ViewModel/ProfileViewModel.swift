//
//  ProfileViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 17/02/25.
//

import Foundation
import FirebaseFirestore
import Supabase
import FirebaseAuth
class ProfileViewModel:ObservableObject{
    @Published var user:User?
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    let supabase = SupabaseClient(supabaseURL: URL(string: "https://zaaxtksuazyvxntlwmrn.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InphYXh0a3N1YXp5dnhudGx3bXJuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgzMTk2ODIsImV4cCI6MjA1Mzg5NTY4Mn0.5IBPLi4bdv0e04rWbaqqB9U3YDh23py4ieTijArJA8M")
    
    func fetchUser(userId:String) {
        // ✅ Remove previous listener to avoid duplicate listeners
        listener?.remove()

        // ✅ Add Firestore real-time listener
        listener = db.collection("Users").document(userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self, let snapshot = snapshot, snapshot.exists else {
                    print("❌ Error fetching user: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    self.user = try snapshot.data(as: User.self) // ✅ Decode using Firestore's built-in method
                    print("✅ User data updated in real-time")
                } catch {
                    print("❌ Error decoding user data: \(error.localizedDescription)")
                    
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .dataCorrupted(let context):
                            print("⚠️ Data corrupted at: \(context.codingPath) - \(context.debugDescription)")
                        case .keyNotFound(let key, let context):
                            print("⚠️ Key '\(key.stringValue)' not found at: \(context.codingPath) - \(context.debugDescription)")
                        case .valueNotFound(let value, let context):
                            print("⚠️ Expected value '\(value)' not found at: \(context.codingPath) - \(context.debugDescription)")
                        case .typeMismatch(let type, let context):
                            print("⚠️ Type mismatch for \(type) at: \(context.codingPath) - \(context.debugDescription)")
                        @unknown default:
                            print("⚠️ Unknown decoding error: \(error.localizedDescription)")
                        }
                    } else {
                        print("⚠️ Non-decoding error: \(error.localizedDescription)")
                    }
                }

            }
    }

    deinit {
        listener?.remove() // ✅ Clean up Firestore listener when ViewModel is destroyed
    }


    
    
    func updateUserProfile(fullName:String? = nil,userName:String? = nil,profileImageURL:String? = nil,location:String? = nil,dob:Date? = nil,gender:String? = nil ,bio:String? = nil) async{
     
        guard let userId = Auth.auth().currentUser?.uid else{
            print("No Authenticated User Found")
            return
        }
        var updates : [String:Any] = [:]
        if let fullName = fullName{
            updates["fullName"] = fullName
        }
        if let userName = userName{
            updates["userName"] = userName
        }
        if let profileImageURL = profileImageURL{
            updates["profileImageURL"] = profileImageURL
        }
        if let location = location{
            updates["location"] = location
        }
        if let dob = dob {
            updates["dob"] = dob
        }
        if let gender = gender{
            updates["gender"] = gender
        }
        if let bio = bio{
            updates["bio"] = bio
        }
        
        guard !updates.isEmpty else{
            print("⚠️ No changes to update.")
            return
        }
        do{
            try await db.collection("Users").document(userId).updateData(updates)
            await fetchUser(userId: userId)
            print("User Profile Updated Successfully!")
        }
        catch{
            print("Error Updating the Profile Details \(error.localizedDescription)")
        }
    }
    
    func uploadProfileImage(image: UIImage, userId: String , oldProfileImageURL:String?) async -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("❌ Invalid Image Data")
            return nil
        }

        let newFileName = "Profile_Image/\(userId)_\(UUID().uuidString).jpg"
        do{
            if let oldProfileImageURL = oldProfileImageURL{
                let oldFileName = oldProfileImageURL.split(separator: "/").last.map{String($0)} ?? ""
                try await supabase.storage.from("user-uploads").remove(paths: [oldFileName])
                print("✅ Old image deleted: \(oldFileName)")
            }
            
            let _ = try await supabase.storage.from("user-uploads").upload(newFileName, data: imageData)
            let downloadURL = try supabase.storage.from("user-uploads").getPublicURL(path: newFileName).absoluteString
            print("✅ Image replaced successfully: \(downloadURL)")
            return downloadURL
            
        } catch {
            print("❌ Error replacing image: \(error.localizedDescription)")
            return nil
        }
    }
    
        // ✅ Format numbers to be more readable (e.g., 1,234 or 1.2K)
    func formatNumber(_ number: Int) -> String {
        if number >= 1_000_000_000 {
            return String(format: "%.1fB", Double(number) / 1_000_000_000.0)
        } else if number >= 1_000_000 {
            return String(format: "%.1fM", Double(number) / 1_000_000.0)
        } else if number >= 1_000 {
            return String(format: "%.1fK", Double(number) / 1_000.0)
        } else {
            return "\(number)"
        }
    }
    
}
