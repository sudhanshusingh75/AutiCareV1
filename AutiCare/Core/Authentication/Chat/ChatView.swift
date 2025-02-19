//
//  ChatView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 19/02/25.
//

//import SwiftUI
//
//struct ChatView: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject private var viewModel = ChatViewModel()
//    var body: some View {
//        NavigationStack{
//            VStack {
//                if viewModel.chats.isEmpty {
//                                    Text("No previous chats.")
//                                        .font(.title2)
//                                        .foregroundColor(.secondary)
//                                        .padding()
//                }
//                else{
//                    ScrollView{
//                        ForEach(0...10 ,id: \.self) { user in
//                            ChatCellView(chat: <#Chat#>)
//                        }
//                    }.overlay(alignment: .bottom) {
//                        Button {
//                            
//                        } label: {
//                            HStack{
//                                Text("+ New Message")
//                                    .padding()
//                                    .foregroundStyle(Color.white)
//                                    .background(Color.blue)
//                                    .clipShape(RoundedRectangle(cornerRadius: 32))
//                            }.padding(.horizontal)
//                        }
//                    }
//                }
//            }
//            .onAppear{
//                viewModel.fetchChats()
//            }
//            .navigationBarBackButtonHidden(true)
//            .navigationTitle("Chat")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Image(systemName: "chevron.left")
//                    }
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ChatView()
//}


import SwiftUI

struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ChatViewModel() // Initialize the ViewModel
    @State private var isShowingSearchView = false
    var body: some View {
        NavigationStack {
            VStack {
                // Show placeholder if no chats exist
                if viewModel.chats.isEmpty {
                    Text("No previous chats.")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    // Display chat cells
                    ScrollView {
                        ForEach(viewModel.chats) { chat in
                            if let user = viewModel.users[chat.userId] {
                                // Display the chat cell with full user details
                                NavigationLink(destination: ChatMessageView(chat: chat)) {
                                    ChatCellView(chat: chat, user: user)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                }
            }
            .overlay(alignment: .bottom) {
                Button {
                    // Handle new message button action
                    isShowingSearchView = true
                } label: {
                    HStack{
                        Text("+ New Message")
                            .padding()
                            .foregroundStyle(Color.white)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                    }.padding(.horizontal)
                }
            }
            .onAppear {
                viewModel.fetchChats() // Fetch chats when the view appears
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Chat")
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
            .sheet(isPresented: $isShowingSearchView) {
                            // Show the search view
                    ChatSearchView(viewModel: viewModel)
            }
        }
    }
}
