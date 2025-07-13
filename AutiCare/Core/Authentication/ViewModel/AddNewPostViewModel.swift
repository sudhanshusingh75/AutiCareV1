//
//  NewPostViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 13/02/25.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseAuth
import Supabase

class AddNewPostViewModel: ObservableObject {
    @Published var postContent: String = ""
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var selectedImages: [UIImage] = []
    @Published var isUploading = false
    @Published var posts:[Posts] = []
    @Published var tag:[String] = ["Milestones", "Health", "Sports", "Education", "Creativity","Motivation"]
    @Published var selectedTag:String = ""
    let wordLimit = 200
    let charLimit = 1000
    let supabase = SupabaseClient(
        supabaseURL: URL(string: "https://zaaxtksuazyvxntlwmrn.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InphYXh0a3N1YXp5dnhudGx3bXJuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgzMTk2ODIsImV4cCI6MjA1Mzg5NTY4Mn0.5IBPLi4bdv0e04rWbaqqB9U3YDh23py4ieTijArJA8M"
    )
    
    func loadImages() {
        Task {
            var images: [UIImage] = []
            for item in selectedItems {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    images.append(image)
                }
            }
            DispatchQueue.main.async {
                self.selectedImages = images
            }
        }
    }
    
    func wordCount() -> Int {
        return postContent.split { $0.isWhitespace || $0.isNewline }.count
    }
    
    func enforceLimits() {
        let words = postContent.split { $0.isWhitespace || $0.isNewline }
        
        if postContent.count > charLimit {
            postContent = String(postContent.prefix(charLimit))
        }
        
        if words.count > wordLimit {
            postContent = words.prefix(wordLimit).joined(separator: " ")
        }
    }
    
    func addPost(currentUser: User?) async {
        guard !postContent.isEmpty || !selectedImages.isEmpty else { return }
        guard let user = currentUser else {
            DispatchQueue.main.async {
                print("❌ No user found in AuthViewModel")
                self.isUploading = false
            }
            return
        }

        await MainActor.run { self.isUploading = true } // ✅ Ensure UI update on the main thread
        let postId = UUID().uuidString
        let db = Firestore.firestore()

        // ✅ Upload images concurrently
        let imageUrls: [String] = await withTaskGroup(of: String?.self) { group in
            var urls: [String] = []

            for image in selectedImages {
                group.addTask { [self] in
                    do {
                        return try await uploadImageToSupabase(image)
                    } catch {
                        await MainActor.run { // ✅ Ensure error logging happens on main thread
                            print("❌ Error uploading image: \(error.localizedDescription)")
                        }
                        return nil
                    }
                }
            }

            for await result in group {
                if let url = result {
                    urls.append(url)
                }
            }

            return urls
        }

        let newPost = Posts(
            id: postId,
            userId: user.id,
            content: postContent,
            imageURL: imageUrls,
            createdAt: Date().timeIntervalSince1970,
            user: nil,
            likesCount: 0,
            likedBy: [],
            commentsCount: 0, tag: selectedTag.isEmpty ? [] : [selectedTag]
        )

        do {
            try db.collection("Posts").document(postId).setData(from: newPost)
            let userRef = db.collection("Users").document(user.id)
            try await userRef.updateData([
                "posts": FieldValue.arrayUnion([postId]),
                "postsCount": FieldValue.increment(Int64(1))
            ])

            await MainActor.run { // ✅ Ensure UI update on the main thread
                self.posts.append(newPost)
                self.isUploading = false
            }
        } catch {
            await MainActor.run {
                print("❌ Error saving post: \(error.localizedDescription)")
                self.isUploading = false
            }
        }
    }


        private func uploadImageToSupabase(_ image: UIImage) async throws -> String {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Image"])
            }
            
            let fileName = "Post_Image/\(UUID().uuidString).jpg"
            
            do {
                try await supabase.storage.from("user-uploads").upload(fileName, data: imageData)
                let downloadURL = try supabase.storage.from("user-uploads").getPublicURL(path: fileName).absoluteString
                
                print("✅ Image uploaded successfully: \(downloadURL)")
                return downloadURL
            } catch {
                throw NSError(domain: "UploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to upload image to Supabase Storage"])
            }
        }
}
