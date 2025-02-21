import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @StateObject private var profileVM = ProfileViewModel()
    @EnvironmentObject var authVM: AuthViewModel
    @State private var posts: [Posts] = [] // This will hold the user's posts
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        // Conditional rendering for user data
        NavigationStack {
            if let user = profileVM.user {
                ScrollView {
                    // Header Section
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
                                NavigationLink(destination: FollowingsView()) {
                                    UserStatView(value: user.followings?.count ?? 0, title: "Following")
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
                        NavigationLink {
                            if let user = authVM.currentUser {
                                EditProfileView(user: user)
                                    .navigationBarBackButtonHidden(true)
                            }
                        } label: {
                            Text("Edit Profile")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .frame(width: 360, height: 32)
                                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                        }
                        Divider()
                    }
                    // Post Grid View
                    LazyVGrid(columns: gridItems, spacing: 1) {
                        ForEach(profileVM.myPosts, id: \.id) { post in
                            if let imageURL = post.imageURL.first, let url = URL(string: imageURL) {
                                NavigationLink(destination: FeedView(selectedPostId: post.id)){
                                    WebImage(url: url)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width:132,height: 132)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .padding(1)
                                }
                            } else {
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
                    ToolbarItem{
                            NavigationLink {
                                AddNewPostView(posts: $posts)
                                {
                                    if let userId = authVM.currentUser?.id{
                                        profileVM.fetchMyPosts(userId: userId)
                                    }
                                }
                            } label: {
                                Image(systemName: "plus.app")
                            }
                    }
                    ToolbarItem {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }

                    }
                }
            }
            else {
                // Loading View if user data is not available
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
    

// Preview
#Preview {
    ProfileView()
}

