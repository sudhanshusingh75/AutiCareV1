//
//  EditProfileViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 09/04/25.
//

import Foundation
import PhotosUI
import SwiftUI
import Supabase
import FirebaseAuth
import FirebaseFirestore

@MainActor
class EditProfileViewModel:ObservableObject{
    
    @Published var selectedImage:UIImage?
    {
        didSet{
            checkForChanges()
        }
    }
    @Published var photosPickerItem:PhotosPickerItem?
    
    @Published var fullName:String = ""{
        didSet{
            checkForChanges()
        }
    }
    @Published var userName:String = ""
    {
        didSet{
            checkForChanges()
        }
    }
    @Published var bio:String = ""
    {
        didSet{
            checkForChanges()
        }
    }
    @Published var location:String = ""
    {
        didSet{
            checkForChanges()
        }
    }
    @Published var gender:String = ""
    {
        didSet{
            checkForChanges()
        }
    }
    @Published var dob = Date()
    {
        didSet{
            checkForChanges()
        }
    }
    @Published var profileImageURL:String = ""
    {
        didSet{
            checkForChanges()
        }
    }
    @Published var isSaveEnabled = false
    
    
    private var initialFullName:String = ""
    private var initialUserName:String = ""
    private var initialBio:String = ""
    private var initialLocation:String = ""
    private var initialGender:String = ""
    private var initialDob:Date = Date()
    private var initialProfileImageURL:String = ""
    
    
    var user:User?{
        
        didSet{
            if let user = user{
                Task{
                    await setInitialValues(from: user)
                }
            }
        }
    }
    
    func setInitialValues(from user: User) async {
        await MainActor.run {
            fullName = user.fullName
            userName = user.userName
            bio = user.bio ?? ""
            location = user.location ?? ""
            gender = user.gender
            dob = user.dob
            profileImageURL = user.profileImageURL ?? ""

            initialFullName = fullName
            initialUserName = userName
            initialBio = bio
            initialLocation = location
            initialGender = gender
            initialDob = dob
            initialProfileImageURL = profileImageURL

            checkForChanges()
        }
    }
    
    private func checkForChanges() {
        let calendar = Calendar.current
        let dobChanged = !calendar.isDate(dob, inSameDayAs: initialDob)

        isSaveEnabled = fullName != initialFullName ||
                        userName != initialUserName ||
                        bio != initialBio ||
                        location != initialLocation ||
                        gender != initialGender ||
                        dobChanged ||
                        selectedImage != nil
    }
    
    func handelImagePickerChange() async {
         guard let item = photosPickerItem else { return }
         do {
             if let data = try await item.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                 await MainActor.run {
                     selectedImage = uiImage
                 }
             }
         } catch {
             print("Image loading error: \(error)")
         }
     }
    
    func uploadProfileImage(image: UIImage, userId: String, oldProfileImageURL: String) async -> String {
        let bucketName = "user-uploads"
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("❌ Failed to convert UIImage to JPEG data")
            return oldProfileImageURL
        }

        let fileName = "\(userId)_\(UUID().uuidString).jpg"
        let filePath = "Profile_Image/\(fileName)"

        do {
            // Remove old image
            if let oldFileName = oldProfileImageURL.components(separatedBy: "/").last {
                let oldPath = "Profile_Image/\(oldFileName)"
                try await SupabaseManager.shared.storage
                    .from(bucketName)
                    .remove(paths: [oldPath])
                print("🗑️ Deleted old image at: \(oldPath)")
            }

            // Upload new image
            _ = try await SupabaseManager.shared.storage
                .from(bucketName)
                .upload(path: filePath, file: imageData, options: FileOptions(contentType: "image/jpeg"))
            print("✅ Uploaded new image at: \(filePath)")

            // Get public URL the right way
            let publicURL = try SupabaseManager.shared.storage
                .from(bucketName)
                .getPublicURL(path: filePath).absoluteString
            return publicURL

        } catch {
            print("❌ Upload error: \(error)")
            return oldProfileImageURL
        }
    }
    
    func saveChanges() async {
        guard let user = user else { return }

        var imageUrl = profileImageURL

        if let image = selectedImage {
            imageUrl = await uploadProfileImage(image: image, userId: user.id, oldProfileImageURL: profileImageURL)
        }

        await updateUserProfile(
            userId: user.id,
            fullName: fullName,
            userName: userName,
            profileImageURL: imageUrl,
            location: location,
            dob: dob,
            gender: gender,
            bio: bio
        )

        await MainActor.run {
            self.user?.fullName = self.fullName
//            self.user?.userName = self.userName
            self.user?.bio = self.bio
            self.user?.location = self.location
            self.user?.gender = self.gender
            self.user?.dob = self.dob
            self.user?.profileImageURL = imageUrl

            Task {
                await self.setInitialValues(from: self.user!)
            }
        }
    }
    
    func updateUserProfile(
        userId: String,
        fullName: String,
        userName: String,
        profileImageURL: String,
        location: String,
        dob: Date,
        gender: String,
        bio: String
    ) async {
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(userId)
        
        let updatedData: [String: Any] = [
            "fullName": fullName,
            "userName": userName,
            "profileImageURL": profileImageURL,
            "location": location,
            "dob": Timestamp(date: dob),
            "gender": gender,
            "bio": bio
        ]
        
        do {
            try await userRef.setData(updatedData, merge: true)
            print("✅ User profile updated successfully.")
        } catch {
            print("❌ Error updating user profile: \(error.localizedDescription)")
        }
    }

}
