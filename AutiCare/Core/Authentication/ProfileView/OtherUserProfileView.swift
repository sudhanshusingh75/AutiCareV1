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
    @StateObject var feedViewModel = FeedViewModel()
    @StateObject var viewModel = OtherUserProfileViewModel()

    
    var body: some View {
        NavigationStack{
            if let user = viewModel.user{
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
                                .frame(width: 150, height: 150)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                                .padding(.all, 5)
                                .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                        }
                        Spacer()
                        HStack(spacing: 8) {
                            UserStatView(value: user.postsCount, title: "Posts")
                            NavigationLink(destination: FollowersView()) {
                                UserStatView(value: user.followers?.count ?? 0, title: "Followers")
                            }
                            UserStatView(value: 3, title: "Following")
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
                    if user.id != feedViewModel.userId{
                        Button{
                            feedViewModel.toggleFollow(userId: user.id)
                        }
                        label: {
                            HStack {
                                // If user is not followed (i.e., connection is false or nil)
                                if feedViewModel.connections[user.id] == false || feedViewModel.connections[user.id] == nil {
                                    Text("Follow")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .frame(width: 360, height: 32)
                                        .background(Color.blue)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                } else {
                                    // If user is followed (i.e., connection is true)
                                    Text("Followed")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .frame(width: 360, height: 32)
                                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                                }
                            }
                        }
                    }
                    Divider()
                }
                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchUser(by: userId)
            feedViewModel.checkifConnected(userId: userId)
        }
    }
}

