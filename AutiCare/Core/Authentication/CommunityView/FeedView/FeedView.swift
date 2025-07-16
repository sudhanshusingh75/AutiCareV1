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
    let tags: [String] = ["Milestones", "Health", "Sports", "Education", "Creativity", "Motivation"]
    @State private var selectedTag: String? = nil

    var body: some View {
        
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                Button {
                    selectedTag = nil
                    viewModel.fetchAllPosts()
                } label: {
                    Text("All")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(selectedTag == nil ? Color(red: 0, green: 0.387, blue: 0.5) : Color.gray.opacity(0.2))
                        .foregroundColor(selectedTag == nil ? .white : .black)
                        .cornerRadius(20)
                }
                ForEach(tags,id: \.self){tag in
                    Button {
                        selectedTag = tag
                        viewModel.fetchPosts(forTag: tag)
                    } label: {
                        Text(tag)
                            .padding(.horizontal,12)
                            .padding(.vertical,8)
                            .background(selectedTag == tag ? Color(red: 0, green: 0.387, blue: 0.5) : Color.gray.opacity(0.2))
                            .foregroundColor(selectedTag == tag ? .white : .black)
                            .cornerRadius(20)
                    }
                }
                
            }
            .padding(.horizontal)
        }
        
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                if viewModel.posts.isEmpty {
                    Text("No posts yet — be the first to share something amazing!")
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.posts, id: \.id) { post in
                        FeedCell(viewModel: viewModel, post: post, currentUserProfileImage: authViewModel.currentUser?.profileImageURL)
                            .id(post.id) // ✅ Assign unique ID for scrolling
                    }
                }
            }
            .refreshable {
                if let tag = selectedTag
                {
                    viewModel.fetchPosts(forTag: tag)
                }
                else{
                    viewModel.fetchAllPosts()
                }
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






