import SwiftUI
import FirebaseAuth

struct MenuView: View {
    @ObservedObject var feedViewModel: FeedViewModel
    @ObservedObject var profileViewModel: OtherUserProfileViewModel
    let post: Posts
    @Environment(\.dismiss) var dismiss
    @StateObject private var userManagement = UserRelationshipManager()
    @State private var showBlockAlert = false
    @State private var selectedUserId: String?
    @State private var showReportAlert = false


    
    private var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }
    
    var body: some View {
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
                    showReportAlert = true
                }
                
                .alert("Report this post?", isPresented: $showReportAlert) {
                    Button("Report", role: .destructive) {
                        Task {
                            try await feedViewModel.reportPost(postId: post.id)
                            dismiss()
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Your report will be reviewed and actions will be taken within 24 hours.")
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
                    selectedUserId = post.userId
                    showBlockAlert = true
                }
                .alert("Block this user?", isPresented: $showBlockAlert) {
                    Button("Block", role: .destructive) {
                        if let userId = selectedUserId {
                            Task {
                                await userManagement.blockUser(userId: userId)
                                feedViewModel.fetchAllPosts()
                                dismiss()
                            }
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("They will be removed from your followers and followings. You won’t see each other’s posts anymore.")
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
