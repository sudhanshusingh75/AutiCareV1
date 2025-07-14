//
//  OtherUserProfileView1.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 20/02/25.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct OtherUserProfileView: View {
    let userId: String
    @StateObject var viewModel = OtherUserProfileViewModel()
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)]
    
    var body: some View {
        NavigationStack{
            if let user = viewModel.user{
                ScrollView{
                    VStack(spacing: 10) {
                        // Pics and stats
                        HStack {
                            if let imageURL = user.profileImageURL, let url = URL(string: imageURL) {
                                WebImage(url: url)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .padding(.all,5)
                                    .overlay {
                                        Circle().stroke(lineWidth: 2)
                                    }
                            } else {
                                Text(user.initials)
                                    .font(.largeTitle)
                                    .frame(width: 80, height: 80)
                                    .background(Color.gray.opacity(0.3))
                                    .clipShape(Circle())
                                    .padding(.all, 5)
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                            }
                            Spacer()
                            HStack(spacing: 8) {
                                UserStatView(value: user.postsCount, title: "Posts")
                                NavigationLink(destination: FollowersView()) {
                                    UserStatView(value: user.followersCount, title: "Followers")
                                }
                                NavigationLink(destination: FollowingsView()) {
                                    UserStatView(value: user.followingCount, title: "Following")
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Name and Bio
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullName)
                                .font(.footnote)
                                .fontWeight(.semibold)
                            
                            Text(user.userName)
                                .font(.footnote)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        // Action button to edit profile
                        if user.id != Auth.auth().currentUser?.uid{
                            if let isFollowing = viewModel.isFollowing {
                                Button {
                                    if isFollowing {
                                        viewModel.unfollowUser(targetUserId: user.id)
                                    } else {
                                        viewModel.followUser(targetUserId: user.id)
                                    }
                                } label: {
                                    Text(isFollowing ? "Following" : "Follow")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding()
                                        .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                                        .frame(maxWidth: .infinity)
                                        .background(Color(red:0,green: 0.387,blue: 0.5).opacity(0.1))
                                        .cornerRadius(16)
                                        .padding()
                                }
                            }
                        }
                        Divider()
                        if viewModel.isFollowing ?? false {
                            if viewModel.othersPosts.isEmpty {
                                Text("No posts yet")
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                LazyVGrid(columns: gridItems, spacing: 1) {
                                    ForEach(viewModel.othersPosts, id: \.id) { post in
                                        if let imageURL = post.imageURL.first, let url = URL(string: imageURL) {
                                            NavigationLink(destination: FeedView(selectedPostId: post.id)) {
                                                WebImage(url: url)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 125, height: 120)
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                                    .padding(1)
                                            }
                                        } else if !post.content.isEmpty {
                                            NavigationLink(destination: FeedView(selectedPostId: post.id)) {
                                                Text(post.content)
                                                    .font(.caption)
                                                    .foregroundStyle(.black)
                                                    .multilineTextAlignment(.center)
                                                    .frame(width: 125, height: 120)
                                                    .background(Color.gray.opacity(0.2))
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                                    .padding(1)
                                            }
                                        } else {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 125, height: 120)
                                                .cornerRadius(8)
                                                .padding(1)
                                        }
                                    }
                                }
                            }
                        } else {
                            Text("Follow to see posts")
                                .foregroundColor(.gray)
                                .padding()
                        }

                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchUser(by: userId)
            viewModel.observeFollowStatus(targetUserId: userId)
        }
    }
}

