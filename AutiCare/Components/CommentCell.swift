//
//  CommentCell.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 13/02/25.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct CommentCell: View {
    let comment: Comments
    @ObservedObject var viewModel:CommentViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Profile Image
           
                if let imageUrl = comment.profileImageURL, let url = URL(string: imageUrl) {
                    WebImage(url: url)
                        .resizable()
                        .indicator(.activity)
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                    
                    
                }else{
                    Text(comment.initials)
                        .font(.title3)
                        .frame(width: 30, height: 30)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(Circle())
                }
            // Comment Content
            VStack(alignment: .leading, spacing: 5) {
                HStack{
                    Text(comment.fullName)
                        .font(.system(size: 14, weight: .bold))
                    Text("·\(timeFormatter(from: comment.createdAt))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Spacer()
                    if Auth.auth().currentUser?.uid == comment.userId {
                        Menu {
                            Button(role: .destructive) {
                                viewModel.deleteComment(commentId: comment.id, postId: comment.postId) // ✅ Call ViewModel
                            } label: {
                                Label("Delete Comment", systemImage: "trash")
                            }
                        } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.black)
                            .rotationEffect(.degrees(90))
                        }
                    }
                }
                Text(comment.content)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
    private func timeFormatter(from timeStamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let formatter = DateComponentsFormatter()
        
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.allowsFractionalUnits = false
        
        if let timeString = formatter.string(from: date, to: Date()) {
            return "\(timeString) ago"
        } else {
            return "Just now"
        }
    }
}

#Preview {
    CommentCell(
        comment: Comments(
            id: "1",
            postId: "101",
            userId: "user123",
            fullName: "John Doe",
            profileImageURL: "person.circle",
            content: "This is a test comment!",
            createdAt: Date().timeIntervalSince1970
        ),
        viewModel: CommentViewModel(postId: "101") // ✅ Correctly passing a ViewModel instance
    )
}



