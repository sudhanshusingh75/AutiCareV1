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
        VStack(alignment:.leading,spacing: 12) {
            
            // Follow/Unfollow for Other Users
            if post.userId != currentUserId {
                Button {
                    Task {
                        await profileViewModel.toggleFollow(for: post.userId)
                    }
                } label: {
                    let currentlyFollowing = profileViewModel.isFollowing ?? false
                    
                    HStack {
                        Image(systemName: currentlyFollowing ? "person.fill.xmark" : "person.fill.checkmark")
                        Text(currentlyFollowing ? "Unfollow" : "Follow")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(currentlyFollowing ? Color.red.opacity(0.2) : Color.blue.opacity(0.2))
                    .foregroundStyle(currentlyFollowing ? Color.red : Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
            // Delete Post (Only for Owner)
            if post.userId == currentUserId {
                Button {
                    Task {
                        await feedViewModel.deletePost(post: post)
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
            if post.userId != currentUserId {
                Divider()
                Button {
                    Task {
                        try await feedViewModel.reportPost(postId: post.id)
                        dismiss()
                    }
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

//            Button {
//                sharePost()
//            } label: {
//                Label("Share Post", systemImage: "square.and.arrow.up")
//            }
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(Color.green.opacity(0.2))
//            .foregroundStyle(Color.green)
//            .clipShape(RoundedRectangle(cornerRadius: 10))

            Spacer()
        }
        .padding()
    }
}
