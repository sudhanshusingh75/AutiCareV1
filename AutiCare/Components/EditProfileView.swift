//
//  EditProfileView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 17/02/25.
//

import SwiftUI
import PhotosUI
import Supabase
import SDWebImageSwiftUI

struct EditProfileView: View {
    @State private var selectedUIImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var email: String = ""
    @State private var fullName: String = ""
    @State private var userName: String = ""
    @State private var bio: String = ""
    @State private var gender: String = ""
    @State private var location: String = ""
    @State private var dob: Date = Date()
    @State private var profileImageURL: String = ""
    @StateObject private var profileVm = ProfileViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var initialFullName: String = ""
    @State private var initialUserName: String = ""
    @State private var initialBio: String = ""
    @State private var initialLocation: String = ""
    @State private var initialGender: String = ""
    @State private var initialDob: Date = Date()
    @State private var initialProfileImageURL: String = ""
    
    let user: User
    
    var isDataChanged: Bool {
        let calendar = Calendar.current
        
        let isDobChanged = !calendar.isDate(dob, inSameDayAs: initialDob)
        
        return fullName != initialFullName ||
               userName != initialUserName ||
               bio != initialBio ||
               location != initialLocation ||
               gender != initialGender ||
               isDobChanged ||  // Use refined date comparison
               profileImageURL != initialProfileImageURL
    }

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()) {
                        if let selectedUIImage = selectedUIImage {
                            Image(uiImage: selectedUIImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                                .shadow(radius: 2)
                        } else if let url = URL(string: profileImageURL) {
                            WebImage(url: url)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                                .shadow(radius: 2)
                        } else {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFill()
                                .padding(.all, 40)
                                .frame(width: 100, height: 100, alignment: .center)
                                .foregroundStyle(Color.white)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                        }
                    }
                    .onChange(of: photosPickerItem) { oldValue, newValue in
                        Task {
                            if let newValue = newValue {
                                do {
                                    if let data = try await newValue.loadTransferable(type: Data.self) {
                                        if let uiImage = UIImage(data: data) {
                                            selectedUIImage = uiImage
                                        }
                                    }
                                } catch {
                                    print("Failed to load image: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                    InputView(text: $fullName, title: "Full Name", placeholder: "")
                    InputView(text: $userName, title: "Username", placeholder: "")
                    InputView(text: $bio, title: "Bio", placeholder: "Tell Something About Yourself")
                    InputView(text: $location, title: "Address", placeholder: "Enter Your Address")
                    InputView(text: $gender, title: "Gender", placeholder: "Select Your Gender")
                    InputView(text: $email, title: "Email", placeholder: "")
                }.padding()
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss() // Dismiss the EditProfileView
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            var updatedProfileImageURL = profileImageURL
                            
                            if let selectedUIImage = selectedUIImage {
                                if let imageURL = await profileVm.uploadProfileImage(image: selectedUIImage, userId: user.id, oldProfileImageURL: user.profileImageURL) {
                                    updatedProfileImageURL = imageURL
                                }
                            }
                            
                            await profileVm.updateUserProfile(
                                fullName: fullName.isEmpty ? nil : fullName,
                                userName: userName.isEmpty ? nil : userName,
                                profileImageURL: updatedProfileImageURL,
                                location: location.isEmpty ? nil : location,
                                dob: dob,
                                gender: gender.isEmpty ? nil : gender,
                                bio: bio.isEmpty ? nil : bio
                            )
                            
                            profileImageURL = updatedProfileImageURL // Update UI after saving
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                            .foregroundStyle(isDataChanged ? Color.blue:Color.gray)
                    }
                    .disabled(!isDataChanged) // Disable if no data has changed
                }
            }
        }
        .onAppear {
            initialFullName = user.fullName
            initialUserName = user.userName
            initialBio = user.bio ?? ""
            initialLocation = user.location ?? ""
            initialGender = user.gender
            initialDob = user.dob
            initialProfileImageURL = user.profileImageURL ?? ""
            
            // Set current values to the UI fields
            fullName = user.fullName
            email = user.email
            userName = user.userName
            gender = user.gender
            dob = user.dob
            if let bio = user.bio{
                self.bio = bio
            }
            if let location = user.location{
                self.location = location
            }
            profileImageURL = user.profileImageURL ?? ""
        }
    }
}
