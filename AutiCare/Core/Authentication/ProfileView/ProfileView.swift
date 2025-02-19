//
//  ProfileView.swift
//  FireBaseAuthTutorail
//
//  Created by Sudhanshu Singh Rajput on 19/01/25.
//
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @StateObject private var profileVM = ProfileViewModel()
    @EnvironmentObject var authVM: AuthViewModel
    @State private var posts:[Posts] = []
    var body: some View {
        NavigationStack{
            if let user = profileVM.user {
                VStack(spacing: 16) {
                    if let imageUrl = user.profileImageURL, let url = URL(string: imageUrl) {
                        WebImage(url: url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .padding(.all, 5)
                            .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                    } else {
                        Text(user.initials)
                            .font(.largeTitle)
                            .frame(width: 150, height: 150)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                            .padding(.all,5)
                            .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                    }
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text(user.fullName)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(user.userName)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        if let bio = user.bio, !bio.isEmpty {
                            Text(bio)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        if let location = user.location, !location.isEmpty {
                            Text(location)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }.padding()
                    
                    HStack(spacing: 50) {
                        NavigationLink(destination: FollowersView()) {
                            VStack {
                                Text("\(user.followers?.count ?? 0)")
                                    .font(.headline)
                                Text("Followers")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        VStack {
                            Text("\(user.followings?.count ?? 0)")
                                .font(.headline)
                            Text("Following")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Text("\(user.postsCount)")
                                .font(.headline)
                            Text("Posts")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack{
                        Button {
                            
                        } label: {
                            Text("Follow")
                        }
                        
                        Button {
                            
                        } label: {
                            Text("Message")
                        }

                    }
                    
                    Spacer()
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem{
                            NavigationLink {
                                AddNewPostView(posts: $posts)
                            } label: {
                                Image(systemName: "plus.app")
                            }
                    }
                    ToolbarItem {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gearshape")
                        }

                    }
                }
                .padding()
            } else {
                ProgressView("Loading...")
            }
        }
        // Fetch user details when the view appears
        .onAppear {
            if let userId = authVM.currentUser?.id {
                profileVM.fetchUser(userId: userId)
            }
        }
    }
    
    // Preview
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
                .environmentObject(AuthViewModel())
        }
    }
}
