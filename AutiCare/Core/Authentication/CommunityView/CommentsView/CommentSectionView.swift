//
//  CommentsSectionView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 13/02/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentSectionView: View {
   
    @StateObject var viewModel: CommentViewModel
    @State private var newComment = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var currentUserVm: AuthViewModel
    var body: some View {
        VStack {
            // Title
            HStack{
                Text("Comments")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName:"xmark")
                        .resizable()
                        .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                        .scaledToFill()
                        .frame(width: 18,height: 18)
                }
            }
            .padding()
            Divider()
            // Comments List
            ScrollView {
                VStack(alignment: .leading) {
                    if viewModel.comments.isEmpty {
                        Text("No comments yet. Be the first to comment!")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(viewModel.comments) { comment in
                            CommentCell(comment: comment, viewModel: CommentViewModel(postId: comment.postId))
                            .padding(.horizontal, 10)
                        }
                    }
                }
            }
            Spacer()
            Divider()
            HStack(spacing: 10) {
                            // Profile Image
                if let url = URL(string: currentUserVm.currentUser?.profileImageURL ?? "") {
                                WebImage(url: url)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                            }
                            
                            // TextField for New Comment
                            TextField("Write a comment...", text: $newComment)
                                .padding()
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(maxWidth: .infinity)
                                .shadow(radius: 2)
                            // Send Button
                            Button {
                                // Action to post comment
                                viewModel.addComment(content: newComment)
                                newComment = ""
                            } label: {
                                Image(systemName: newComment.isEmpty ? "paperplane":"paperplane.fill")
                                    .resizable()
                                    .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                                    .scaledToFill()
                                    .frame(width:18,height:18)
                                    .foregroundColor(.blue)
                                    
                            }.disabled(newComment.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
            .padding()
            Spacer()
        }
        .onAppear {
            viewModel.fetchComments()
        }
    }
}



