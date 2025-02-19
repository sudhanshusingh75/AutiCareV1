//
//  ChatCellView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 19/02/25.
//

//import SwiftUI
//
//struct ChatCellView: View {
//    var chat:Chat
//    var body: some View {
//        VStack {
//            HStack{
//                Image(systemName: "person.circle")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 45,height: 45)
//                VStack(alignment: .leading){
//                    Text("Name")
//                        .font(.subheadline)
//                        .fontWeight(.bold)
//                    Text("Message sent to user")
//                        .font(.caption)
//                        .foregroundStyle(Color.secondary)
//                }
//                Spacer()
//                Text("22D")
//                    .font(.subheadline)
//                    .fontWeight(.semibold)
//            }.padding()
//            Divider()
//        }
//    }
//}
//
//#Preview {
//    ChatCellView()
//}

import SwiftUI

struct ChatCellView: View {
    var chat: Chat
    var user: User // Pass the full user details
    
    var body: some View {
        HStack {
            // Profile Picture
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
                Text(user.fullName) // Display the user's full name
                    .fontWeight(.bold)
                Text(chat.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            Text(DateFormatter.localizedString(from: Date(timeIntervalSince1970: chat.lastMessageTime), dateStyle: .none, timeStyle: .short))
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
