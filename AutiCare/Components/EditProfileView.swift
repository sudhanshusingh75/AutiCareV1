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
    
    let user:User

    @StateObject private var vm = EditProfileViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    PhotosPicker(selection: $vm.photosPickerItem, matching: .images, photoLibrary: .shared()) {
                        if let selectedUIImage = vm.selectedImage {
                            Image(uiImage: selectedUIImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                                .shadow(radius: 2)
                        } else if let url = URL(string: vm.profileImageURL) {
                            WebImage(url: url)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                                .shadow(radius: 2)
                        }
                    }
                    .onChange(of: vm.photosPickerItem) { _,_ in
                        Task{
                            await vm.handelImagePickerChange()
                        }
                    }
                    
                    InputView(text: $vm.fullName, title: "Full Name", placeholder: "")
                    InputView(text: $vm.bio, title: "Bio", placeholder: "Tell Something About Yourself")
                    InputView(text: $vm.location, title: "Address", placeholder: "Enter Your Address")
//                  InputView(text: $vm.gender, title: "Gender", placeholder: "Select Your Gender")
                    
                    
                    
                    
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
                        Task{
                            await vm.saveChanges()
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                            .foregroundStyle(vm.isSaveEnabled ? Color.blue:Color.gray)
                    }
                    .disabled(!vm.isSaveEnabled) // Disable if no data has changed
                }
            }
        }
        .onAppear{
            vm.user = user
        }
    }
}
