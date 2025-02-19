//
//  ChatViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 19/02/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ChatViewModel:ObservableObject{
    
    @Published var chats:[Chat] = []
    @Published var messages: [Message] = []
    @Published var users:[String:User] = [:]
    
    let db = Firestore.firestore()
    
    
    func searchUsers(query: String, completion: @escaping ([User]) -> Void) {
        db.collection("Users")
            .whereField("userName", isGreaterThanOrEqualTo: query)
            .whereField("userName", isLessThanOrEqualTo: query + "\u{f8ff}") // Firebase range query
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error searching users: \(error)")
                    completion([])
                } else {
                    let users = snapshot?.documents.compactMap { document -> User? in
                        try? document.data(as: User.self)
                    } ?? []
                    completion(users)
                }
            }
    }
    
    
    func startChat(with user: User) {
        // Check if chat already exists between the current user and selected user
        let currentUserId = Auth.auth().currentUser?.uid // Replace with the actual current user's ID
        db.collection("chats")
            .whereField("userIds", arrayContains: currentUserId as Any)
            .whereField("userIds", arrayContains: user.id)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching chat: \(error)")
                } else {
                    if snapshot?.documents.isEmpty == true {
                        // If no chat exists, create a new chat
                        self.createNewChat(with: user)
                    } else {
                        // If chat exists, navigate to the existing chat
                        print("Existing chat found")
                    }
                }
            }
    }
    
    private func createNewChat(with user: User) {
        let newChat = Chat(id: UUID().uuidString, userId: user.id, lastMessage: "", lastMessageTime: Date().timeIntervalSince1970, lastSenderId: "", isGroupChat: false)
        
        do {
            try db.collection("chats").document(newChat.id).setData(from: newChat)
            print("New chat created with user \(user.userName)")
        } catch {
            print("Error creating new chat: \(error)")
        }
    }
    
    func fetchChats() {
        db.collection("chats").getDocuments { snapshot, error in
            if let error = error{
                print("Error Getting Chats: \(error.localizedDescription)")
            }
            else{
                self.chats = snapshot?.documents.compactMap({ document in
                    try? document.data(as: Chat.self)
                }) ?? []
            }
        }
    }
    
    func fetchUsers(for chats:[Chat]){
        for chat in chats {
            db.collection("Users").document(chat.userId) // Assuming users are stored in "users" collection
                .getDocument { snapshot, error in
                    if let error = error {
                        print("Error getting user details: \(error)")
                    } else if let snapshot = snapshot, snapshot.exists {
                        let user = try? snapshot.data(as: User.self)
                        if let user = user {
                            self.users[chat.userId] = user
                        }
                    }
                }
        }
    }
    
    func fetchMessage(for chatId:String){
        db.collection("chats").document(chatId).collection("messages").order(by: "timeStamp",descending: true).getDocuments{snapshot , error in
            if let error = error{
                print("Error getting messages: \(error.localizedDescription)")
            }
            else{
                self.messages = snapshot?.documents.compactMap { document in
                                        try? document.data(as: Message.self)
                } ?? []
            }
        }
    }
    
    
    func sendMessage(to chatId: String, message: Message) {
        do {
            try db.collection("chats")
                .document(chatId)
                .collection("messages")
                .addDocument(from: message)
        } catch let error {
            print("Error sending message: \(error.localizedDescription)")
        }
    }
    
}
