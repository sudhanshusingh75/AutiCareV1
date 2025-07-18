import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @StateObject private var profileVM = ProfileViewModel()
    @EnvironmentObject var authVM: AuthViewModel
    //    @State private var posts: [Posts] = [] // This will hold the user's posts
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
                                        Circle().stroke(Color.init(red: 0, green: 0.387, blue: 0.5), lineWidth: 3)
                                    }
                            } else {
                                Text(user.initials)
                                    .font(.largeTitle)
                                    .frame(width: 80, height: 80)
                                    .background(Color.gray.opacity(0.3))
                                    .clipShape(Circle())
                                    .padding(.all, 5)
                                    .overlay {
                                        Circle().stroke(lineWidth: 2)
                                    }
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
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text(user.userName)
                                .font(.footnote)
//                            Text(user.bio ?? "")
//                                .font(.footnote)
//                                .foregroundStyle(Color.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        // Action button to edit profile
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
                            //                                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                        }
                        Divider()
                    }
                    // Post Grid View
                    if profileVM.myPosts.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color(red: 0, green: 0.387, blue: 0.5).opacity(0.6))
                            
                            Text("Your story starts here!")
                                .font(.headline)
                                .foregroundColor(Color(red: 0, green: 0.387, blue: 0.5))
                            
                            Text("Share your experiences, tips, or questions with the community. Every voice matters!")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .padding(.top)
                    }
                    
                    else{ LazyVGrid(columns: gridItems, spacing: 1) {
                        ForEach(profileVM.myPosts, id: \.id) { post in
                            if let imageURL = post.imageURL.first, let url = URL(string: imageURL) {
                                NavigationLink(destination: FeedView(selectedPostId: post.id)){
                                    WebImage(url: url)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width:125,height: 120)
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
                    }}
                    
                    
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    //                    ToolbarItem{
                    //                        NavigationLink {
                    //                            AddNewPostView
                    //                            {
                    //                                if let userId = authVM.currentUser?.id{
                    //                                    profileVM.fetchMyPosts(userId: userId)
                    //                                }
                    //                            }
                    //                        } label: {
                    //                            Image(systemName: "plus.app")
                    //                                .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                    //                        }
                    //                    }
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
//#Preview {
//    ProfileView().environmentObject(AuthViewModel())
//}


