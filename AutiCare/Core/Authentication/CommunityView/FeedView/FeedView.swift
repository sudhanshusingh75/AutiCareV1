//
//  FeedView.swift
//  FireBaseAuthTutorail
//
//  Created by Sudhanshu Singh Rajput on 01/02/25.
//

import SwiftUI
import FirebaseAuth

struct FeedView: View {
    @ObservedObject private var viewModel = FeedViewModel()
    @EnvironmentObject var authViewModel : AuthViewModel
    var selectedPostId: String? // ✅ Accept selected post ID for scrolling

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                if viewModel.posts.isEmpty {
                    Text("No posts available")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(viewModel.posts, id: \.id) { post in
                        FeedCell(viewModel: viewModel, post: post, currentUserProfileImage: authViewModel.currentUser?.profileImageURL)
                            .id(post.id) // ✅ Assign unique ID for scrolling
                    }
                }
            }
            .refreshable {
                viewModel.fetchAllPosts()
            }
            .onAppear {
                viewModel.fetchAllPosts()

                // ✅ Scroll to the selected post if coming from ExploreView
                if let selectedId = selectedPostId {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            proxy.scrollTo(selectedId, anchor: .top)
                        }
                    }
                }
            }
        }
    }
}






