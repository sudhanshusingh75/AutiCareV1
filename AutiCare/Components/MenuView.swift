import SwiftUI
import FirebaseAuth

struct MenuView: View {
    @ObservedObject var feedViewModel: FeedViewModel
    @ObservedObject var profileViewModel: OtherUserProfileViewModel
    let post: Posts
    @Environment(\.dismiss) var dismiss
    
    private var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }
    
    var body: some View {
        //        VStack(alignment:.leading,spacing: 12) {
        //
        //            // Follow/Unfollow for Other Users
        //            if post.userId != currentUserId {
        //                Button {
        //                    Task {
        //                        await profileViewModel.toggleFollow(for: post.userId)
        //                    }
        //                } label: {
        //                    let currentlyFollowing = profileViewModel.isFollowing ?? false
        //
        //                    HStack {
        //                        Image(systemName: currentlyFollowing ? "person.fill.xmark" : "person.fill.checkmark")
        //                        Text(currentlyFollowing ? "Unfollow" : "Follow")
        //                    }
        //                    .frame(maxWidth: .infinity)
        //                    .padding()
        //                    .background(currentlyFollowing ? Color.red.opacity(0.2) : Color.blue.opacity(0.2))
        //                    .foregroundStyle(currentlyFollowing ? Color.red : Color.blue)
        //                    .clipShape(RoundedRectangle(cornerRadius: 10))
        //                }
        //            }
        //
        //            // Delete Post (Only for Owner)
        //            if post.userId == currentUserId {
        //                Button {
        //                    Task {
        //                        await feedViewModel.deletePost(post: post)
        //                    }
        //                } label: {
        //                    HStack {
        //                        Image(systemName: "trash")
        //                        Text("Delete Post")
        //                    }
        //                    .frame(maxWidth: .infinity)
        //                    .padding()
        //                    .background(Color.red.opacity(0.2))
        //                    .foregroundStyle(Color.red)
        //                    .clipShape(RoundedRectangle(cornerRadius: 10))
        //                }
        //            }
        //
        //            // Report Post (Only for Others)
        //            if post.userId != currentUserId {
        //                Divider()
        //                Button {
        //                    Task {
        //                        try await feedViewModel.reportPost(postId: post.id)
        //                        dismiss()
        //                    }
        //                } label: {
        //                    HStack {
        //                        Image(systemName: "exclamationmark.triangle.fill")
        //                        Text("Report Post")
        //                    }
        //                    .frame(maxWidth: .infinity)
        //                    .padding()
        //                    .background(Color.orange.opacity(0.2))
        //                    .foregroundStyle(Color.orange)
        //                    .clipShape(RoundedRectangle(cornerRadius: 10))
        //                }
        //            }
        //
        //            Divider()
        //
        ////            Button {
        ////                sharePost()
        ////            } label: {
        ////                Label("Share Post", systemImage: "square.and.arrow.up")
        ////            }
        ////            .frame(maxWidth: .infinity)
        ////            .padding()
        ////            .background(Color.green.opacity(0.2))
        ////            .foregroundStyle(Color.green)
        ////            .clipShape(RoundedRectangle(cornerRadius: 10))
        //
        //            Spacer()
        //        }
        //        .padding()
        
        VStack(alignment: .leading, spacing: 12) {
            
            // Follow / Unfollow
            if post.userId != currentUserId {
                menuButton(
                    title: profileViewModel.isFollowing == true ? "Unfollow" : "Follow",
                    icon: profileViewModel.isFollowing == true ? "person.crop.circle.badge.xmark" : "person.crop.circle.badge.checkmark",
                    bgColor: Color(red: 0, green: 0.387, blue: 0.5).opacity(0.08),
                    fgColor: Color(red: 0, green: 0.387, blue: 0.5)
                ) {
                    Task {
                        await profileViewModel.toggleFollow(for: post.userId)
                    }
                }
            }
            
            // Delete
            if post.userId == currentUserId {
                menuButton(
                    title: "Delete Post",
                    icon: "trash",
                    bgColor: Color.red.opacity(0.08),
                    fgColor: .red
                ) {
                    Task {
                        await feedViewModel.deletePost(post: post)
                    }
                }
            }
            
            // Report
            if post.userId != currentUserId {
                Divider()
                menuButton(
                    title: "Report Post",
                    icon: "exclamationmark.triangle",
                    bgColor: Color.orange.opacity(0.08),
                    fgColor: .orange
                ) {
                    Task {
                        try await feedViewModel.reportPost(postId: post.id)
                        dismiss()
                    }
                }
            }
            // Block User (Only for Others)
            if post.userId != currentUserId {
                menuButton(
                    title: "Block User",
                    icon: "hand.raised.fill",
                    bgColor: Color.red.opacity(0.15),
                    fgColor: Color.red
                ) {
                    // TODO: Add confirmation alert or direct logic
                    print("Blocked user: \(post.userId)")
                    // Optionally:
                    // await feedViewModel.blockUser(userId: post.userId)
                    dismiss()
                }
            }

            Spacer(minLength: 10)
        }
        .padding()
    }
    @ViewBuilder
    func menuButton(title: String, icon: String, bgColor: Color, fgColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .imageScale(.medium)
                Text(title)
                    .font(.system(size: 15, weight: .medium))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(bgColor)
            .foregroundStyle(fgColor)
            .clipShape(RoundedRectangle(cornerRadius: 10)) // Soft rounding
        }
    }

}
