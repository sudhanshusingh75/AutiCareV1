//
//  myProfileView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 16/07/25.
//

import SwiftUI
import SDWebImageSwiftUI


struct myProfileView: View {
    @StateObject private var profileVM = ProfileViewModel()
    @EnvironmentObject var authVM: AuthViewModel
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)]
    var body: some View {
        NavigationStack{
            if let user = profileVM.user{
                ScrollView{
                    VStack{
                        if let imageURL = user.profileImageURL, let url = URL(string: imageURL){
                            WebImage(url: url)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150,height: 150)
                                .clipShape(Circle())
                                .clipped()
                                .overlay {
                                    Circle().stroke(.gray, lineWidth: 2)
                            }
                        }
                        
                        Text(user.fullName)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(user.userName)
                            .font(.title3)
                            .foregroundStyle(.gray)
                        HStack{
                            UserStatView(value: user.postsCount, title: "Posts")
                            NavigationLink(destination: FollowersView()) {
                                UserStatView(value: user.followersCount, title: "Followers")
                            }
                            NavigationLink(destination: FollowingsView()) {
                                UserStatView(value: user.followingCount, title: "Following")
                            }
                        }
                        NavigationLink {
                            if let user = profileVM.user {
                                EditProfileView(user: user)
                                    .navigationBarBackButtonHidden(true)
                            }
                        } label: {
                            Text("Edit Profile")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding()
                                .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                                .frame(maxWidth: .infinity)
                                .background(Color(red:0,green: 0.387,blue: 0.5).opacity(0.1))
                                .cornerRadius(16)
                                .padding()
                        }
                        Divider()
                    }.padding(.vertical)
                    LazyVGrid(columns: gridItems, spacing: 2) {
                        ForEach(profileVM.myPosts, id: \.id) { post in
                            if let imageURL = post.imageURL.first, let url = URL(string: imageURL) {
                                NavigationLink(destination: FeedView(selectedPostId: post.id)){
                                    WebImage(url: url)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width:125,height: 125)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .padding(1)
                                }
                            }
                            else if !post.content.isEmpty{
                                NavigationLink(destination: FeedView(selectedPostId:post.id)){
                                    VStack{
                                        Text(post.content)
                                            .font(.caption)
                                            .foregroundStyle(Color.black)
                                            .padding(8)
                                            .multilineTextAlignment(.center)
                                            .frame(width: 125, height: 125)
                                            .background(Color.gray.opacity(0.2))
                                            .clipShape(RoundedRectangle(cornerRadius:8))
                                    }.padding(1)
                                }
                            }
                            else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 150)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        NavigationLink {
                            SettingsView(profileVM: profileVM)
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                        }
                        
                    }
                }
            }
            else{
                ProgressView("Loading...")
            }
            
        }
        .onAppear {
            // Fetch user data and posts when the view appears
            if let userId = authVM.currentUser?.id {
                profileVM.fetchUser(userId: userId)
                profileVM.fetchMyPosts(userId: userId)
            }
        }
    }
}

#Preview {
    myProfileView().environmentObject(AuthViewModel())
}
