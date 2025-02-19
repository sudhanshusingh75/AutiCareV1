//
//  ChatSearchView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 19/02/25.
//

//import SwiftUI
//
//struct ChatSearchView: View {
//    @State private var searchText = ""
//    @State private var searchResults: [User] = []
//    @State private var selectedUser: User? = nil
//    
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var viewModel: ChatViewModel
//    
//    var body: some View {
//        VStack {
//            // Search bar
//            TextField("Search for users...", text: $searchText, onEditingChanged: { _ in
//                // Start searching when text changes
//                searchUsers()
//            })
//            .padding()
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//            .padding(.horizontal)
//
//            // Search results
//            List(searchResults) { user in
//                Button {
//                    // Select user and start a chat with them
//                    selectedUser = user
//                    if let selectedUser = selectedUser {
//                        viewModel.startChat(with: selectedUser) // Create the chat if not already
//                    }
//                } label: {
//                    HStack {
//                        if let profileImageURL = user.profileImageURL, let url = URL(string: profileImageURL) {
//                            AsyncImage(url: url) { image in
//                                image.resizable()
//                                     .scaledToFill()
//                                     .clipShape(Circle())
//                                     .frame(width: 40, height: 40)
//                            } placeholder: {
//                                Circle()
//                                    .frame(width: 40, height: 40)
//                                    .foregroundColor(.gray)
//                                    .overlay(
//                                        Text(user.initials)
//                                            .font(.title2)
//                                            .foregroundColor(.white)
//                                    )
//                            }
//                        } else {
//                            Circle()
//                                .frame(width: 40, height: 40)
//                                .foregroundColor(.gray)
//                                .overlay(
//                                    Text(user.initials)
//                                        .font(.title2)
//                                        .foregroundColor(.white)
//                                )
//                        }
//                        Text(user.userName) // Show the user's username
//                            .font(.body)
//                            .foregroundColor(.black)
//                    }
//                }
//            }
//        }
//        .navigationTitle("Search Users")
//        .navigationBarItems(trailing: Button("Cancel") {
//            dismiss()
//        })
//    }
//    
//    // Search users from Firestore
//    private func searchUsers() {
//        if searchText.isEmpty {
//            searchResults = []
//            return
//        }
//        
//        // Call your Firebase function to search users by name
//        viewModel.searchUsers(query: searchText) { users in
//            searchResults = users
//        }
//    }
//}
//
//#Preview {
//    ChatSearchView(viewModel: ChatViewModel())
//}

import SwiftUI

struct ChatSearchView: View {
    @State private var searchText = ""
    @State private var selectedUser: User? = nil
    @State private var searchResults: [User] = []
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        VStack {
            // Search bar
            TextField("Search for users...", text: $searchText, onEditingChanged: { _ in
                searchUsers()  // Trigger search when text changes
            })
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            
            // Display search results
            List(searchResults) { user in
                Button {
                    // Start chat with the selected user
                    if let selectedUser = selectedUser {
                        viewModel.startChat(with: selectedUser) // Start chat logic here
                    }
                } label: {
                    HStack {
                        if let profileImageURL = user.profileImageURL, let url = URL(string: profileImageURL) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                     .scaledToFill()
                                     .clipShape(Circle())
                                     .frame(width: 40, height: 40)
                            } placeholder: {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                                    .overlay(
                                        Text(user.initials)
                                            .font(.title2)
                                            .foregroundColor(.white)
                                    )
                            }
                        } else {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                                .overlay(
                                    Text(user.initials)
                                        .font(.title2)
                                        .foregroundColor(.white)
                                )
                        }
                        Text(user.userName) // Show the user's username
                            .font(.body)
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .navigationTitle("Search Users")
        .navigationBarItems(trailing: Button("Cancel") {
            dismiss()
        })
    }
    
    // Function to perform the user search
    private func searchUsers() {
        if searchText.isEmpty {
            searchResults = [] // Reset if no search text
            return
        }
        
        // Perform Firestore search
        viewModel.searchUsers(query: searchText) { users in
            DispatchQueue.main.async {
                self.searchResults = users // Update search results
            }
        }
    }
}

#Preview {
    ChatSearchView(viewModel: ChatViewModel())
}
