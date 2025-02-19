//
//  MenuView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 14/02/25.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: FeedViewModel
    let post: Posts
    
    var body: some View {
        VStack(alignment:.leading,spacing: 12) {
            
            // Connection Toggle
            if post.userId != viewModel.userId {
                Button {
                    viewModel.toggleFollow(userId: post.userId)
                } label: {
                    HStack {
                        Image(systemName: viewModel.connections[post.userId] ?? false ? "person.fill.xmark" : "person.fill.checkmark")
                        Text(viewModel.connections[post.userId] ?? false ? "Remove Connection" : "Connect")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.connections[post.userId] ?? false ? Color.red.opacity(0.2) : Color.blue.opacity(0.2))
                    .foregroundStyle(viewModel.connections[post.userId] ?? false ? Color.red : Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
            // Delete Post (Only for Owner)
            if post.userId == viewModel.userId {
                
                Button {
                    Task {
                        await viewModel.deletePost(post: post)
                    }
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Post")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.2))
                    .foregroundStyle(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
            // Report Post (Only for Others)
            if post.userId != viewModel.userId {
                Divider()
                
                Button {
                    // Report functionality here
                } label: {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("Report Post")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange.opacity(0.2))
                    .foregroundStyle(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            Divider()
            Button {
                
            } label: {
                Label("Share Post", systemImage: "square.and.arrow.up")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green.opacity(0.2))
            .foregroundStyle(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Spacer()
        }.padding()
    }
}




