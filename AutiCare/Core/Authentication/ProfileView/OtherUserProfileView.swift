//
//  SwiftUIView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 10/02/25.
//
import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct OtherUserProfileView: View {
    let userId: String
    @StateObject var viewModel = OtherUserProfileViewModel()  // Assuming you have a view model for fetching user data
    @State private var selectedSegment: Int = 0
    @State private var navigateToChat = false
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                // Show loading indicator
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if let user = viewModel.user {
                // Show user profile when data is loaded
                Image("background")
                    .resizable()
                    .frame(width: 500, height: 300)
                if let url = URL(string: user.profileImageURL ?? "") {
                    WebImage(url: url)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(Color.white, lineWidth: 3)
                        }
                        .offset(x: -105, y: -80)
                }
                VStack {
                    Text(user.fullName)
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .offset(x: -105, y: -130)
                
                Button {
                    navigateToChat = true
                    
                } label: {
                    Text("Message")
                }
                
                Picker("Select View", selection: $selectedSegment) {
                    Text("Posts").tag(0)
                    Text("About").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .offset(y: -125)

                if selectedSegment == 0 {
                    // Show posts section
                } else {
                    // Show about section
                }
            } else {
                // Handle case if user data is missing or nil
                Text("User not found.")
            }
        }
        .onAppear {
            viewModel.fetchUser(by: userId)  // Fetch user data when the view appears
        }
        .ignoresSafeArea(.all)
        .navigationDestination(isPresented: $navigateToChat) {
//                    ChatView(receiverId: userId)
        }
    }
}

