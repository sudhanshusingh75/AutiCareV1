//
//  ChatMessageView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 19/02/25.
//

//import SwiftUI
//
//struct ChatMessageView: View {
//    @Environment(\.dismiss) var dismiss
//    var body: some View {
//        NavigationStack{
//            
//            
//        }.toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button {
//                    dismiss()
//                } label: {
//                    Image(systemName: "chevron.left")
//                }
//            }
//            ToolbarItem(placement: .topBarLeading) {
//                HStack{
//                    Image("profilePic")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 40, height: 40)
//                        .clipShape(Circle())
//                    VStack(alignment:.leading, spacing: 0) {
//                        Text("UserName")
//                            .font(.title3)
//                            .fontWeight(.bold)
//                        HStack(spacing:2){
//                            Circle()
//                                .foregroundStyle(Color.green)
//                                .frame(width: 5, height: 5)
//                            Text("Online")
//                                .font(.footnote)
//                                .foregroundStyle(Color.secondary)
//                        }
//                    }
//                
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ChatMessageView()
//}


import SwiftUI

struct ChatMessageView: View {
    @Environment(\.dismiss) var dismiss
    var chat: Chat
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        VStack {
            // Display user details
            if let user = viewModel.users[chat.userId] {
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
                                    Text(user.initials) // Display initials if no profile picture
                                        .font(.title2)
                                        .foregroundColor(.white)
                                )
                        }
                    } else {
                        // Placeholder if no profile picture
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                            .overlay(
                                Text(user.initials) // Display initials if no profile picture
                                    .font(.title2)
                                    .foregroundColor(.white)
                            )
                    }
                    
                    VStack(alignment: .leading) {
                        Text(user.fullName)
                            .font(.title3)
                            .fontWeight(.bold)
                        HStack(spacing: 2) {
                            Circle()
                                .foregroundStyle(Color.green)
                                .frame(width: 5, height: 5)
                            Text("Online")
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                        }
                    }
                }
            }
            
            // Messages list
            ScrollView {
                ForEach(viewModel.messages) { message in
                    Text(message.text)
                        .padding()
                }
            }

            Spacer()
        }
        .onAppear {
            viewModel.fetchMessage(for: chat.id) // Fetch messages when the view appears
        }
        .navigationTitle("Chat")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
    }
}
