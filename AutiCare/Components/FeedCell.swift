//
//  FeedCell1.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 14/02/25.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct FeedCell: View {
    @ObservedObject var viewModel:FeedViewModel
    @State private var isLinked = false
    @State private var showFullDescription = false
    @State private var showCommentView = false
    @State private var showMenuView = false
    let post:Posts
    let currentUser = Auth.auth().currentUser
    let currentUserProfileImage:String?
    
    var body: some View {
        VStack{
            HStack{
               //Header Section of the Feed
                if post.userId == currentUser?.uid{
                    NavigationLink(destination: ProfileView()){
                        if let url = URL(string: post.profileImageURL ?? ""){
                            WebImage(url: url)
                                .resizable()
                                .frame(width: 50,height: 50)
                                .clipShape(Circle())
                            
                        }
                        VStack(alignment:.leading){
                            Text(post.fullName)
                                .font(.callout)
                                .foregroundStyle(Color.black)
                            Text(viewModel.timeFormatter(from: post.createdAt))
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
                else{
                    NavigationLink(destination: OtherUserProfileView(userId: post.userId)){
                        if let url = URL(string: post.profileImageURL ?? ""){
                            WebImage(url: url)
                                .resizable()
                                .frame(width: 50,height: 50)
                                .clipShape(Circle())
                            
                        }
                        VStack(alignment:.leading){
                            Text(post.fullName)
                                .font(.callout)
                                .foregroundStyle(Color.black)
                            Text(viewModel.timeFormatter(from: post.createdAt))
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
                Spacer()
                HStack (spacing:20){
                    HStack{
                        Button{
                            showMenuView.toggle()
                        }label: {
                            Image(systemName: "ellipsis")
                            
                        }
                       
                    }.sheet(isPresented: $showMenuView) {
                        MenuView(viewModel: viewModel, post: post)
                            .presentationDetents([.fraction(0.4)])
                            .presentationDragIndicator(.visible)
                        .onAppear {
                            viewModel.checkifConnected(userId: post.userId)
                        }
                    }
                    Button {
                        viewModel.removeFromFeed(postId: post.id)
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

            }.padding(.horizontal)
            
            if !post.imageURL.isEmpty{
                ZStack{
                    VStack(alignment:.leading,spacing: 1){
                        if !post.content.isEmpty{
                            Text(post.content)
                                .lineLimit(showFullDescription ? nil : 1)
                                .font(.callout)
                            Button {
                                withAnimation {
                                    showFullDescription.toggle()
                                }
                            } label: {
                                Text(showFullDescription ? " Less...":"More...")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding(.vertical,4)
                                
                            }
                        }
                        else{
                            Text(post.content)
                                .lineLimit(showFullDescription ? nil : 1)
                                .font(.callout)
                        }
                    }
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.horizontal, 20)
                VStack{
                    //caption + Image Body
                    TabView{
                        ForEach(post.imageURL, id: \.self) { imageUrl in
                            if let url = URL(string: imageUrl){
                                WebImage(url: url)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 375, height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 300)
                }
            }
            else{
                VStack{
                    Text(post.content)
                        .font(.callout)
                }.frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.horizontal, 20)
            }
            HStack(alignment:.center,spacing: 20){
                //like+comment+share
                HStack{
                Button {
                    withAnimation(.spring(response: 0.4,dampingFraction: 0.6)) {
                        viewModel.toggleLike(for: post)
                    }
                   
                } label: {
                    Image(systemName: viewModel.isLiked(post: post) ? "heart.fill":"heart")
                        .resizable()
                        .frame(width: 18,height: 18)

                }
                Text("\(post.likesCount)")
                        .foregroundStyle(Color.gray)
            }
                HStack{
                    Button {
                        showCommentView.toggle()
                    } label: {
                        Image(systemName: "message")
                            .resizable()
                            .frame(width: 18,height:18)
                        
                    }
                    Text("\(post.commentsCount)")
                            .foregroundStyle(Color.gray)
                }.sheet(isPresented: $showCommentView) {
                    CommentSectionView(viewModel: CommentViewModel(postId: post.id), currentUserProfileImageURL: currentUserProfileImage)
                        .presentationDragIndicator(.visible)
                }
                    Button {
                        sharePost()
                    } label: {
                        Image(systemName: "arrow.uturn.right")
                            .resizable()
                            .frame(width: 18,height: 18)

                    }
                    Spacer()
            }.padding(.horizontal)
                .padding(.top,10)
            Divider()
            Spacer()
        }
        
    }
    
    
    private func sharePost() {
        let textToShare = post.content
        let imageUrl = post.imageURL
        
        var itemsToShare: [Any] = [textToShare]
        
        if let imageUrl = imageUrl.first, let url = URL(string: imageUrl) {
            itemsToShare.append(url)
        }
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true, completion: nil)
        }
    }
}


