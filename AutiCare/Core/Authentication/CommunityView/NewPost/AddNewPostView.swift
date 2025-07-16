//
//  AddNewPost.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 14/02/25.
//

import SwiftUI
import PhotosUI

struct AddNewPostView: View {
    @State private var selectedTag = ""
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    //    @Binding var posts: [Posts]
    var onPostAdded: (() -> Void)?
    @StateObject private var viewModel = AddNewPostViewModel()
    @StateObject private var profileVM = ProfileViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isPosting = false
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 16) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.yellow)
                            Text("Community Guidelines")
                                .font(.title3.bold())
                                .foregroundColor(.black)
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            GuidelineItem(text: "Avoid sharing your child’s full name or identifiable photos.")
                            GuidelineItem(text: "Use nicknames or initials to maintain anonymity.")
                            GuidelineItem(text: "Share experiences respectfully and supportively.")
                            GuidelineItem(text: "No medical advice or diagnoses — this is a peer support space.")
                            Text("By posting, you agree to follow these guidelines.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.top, 4)
                        }
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)

                    
                    // **Post Description**
                    VStack(alignment: .leading) {
                        Text("Add Post Description")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                        ZStack(alignment: .topLeading){
                            if viewModel.postContent.isEmpty && !isTextEditorFocused {
                                Text("Share your thoughts, experiences, or questions with the community...")
                                    .font(.footnote)
                                    .padding(.top)
                                    .padding(.horizontal)
                                    .foregroundColor(.gray)
                                    .transition(.opacity)
                                    .zIndex(1)
                                    .allowsHitTesting(false)
                            }
                            
                            TextEditor(text: $viewModel.postContent)
                                .focused($isTextEditorFocused)
                                .padding(.horizontal, 12)
                                .padding(.top, 8)
                                .frame(height: 150)
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 5)
                                .onChange(of: viewModel.postContent) { _, _ in
                                    viewModel.enforceLimits()
                                }
                        }
                    }
                    .padding(.horizontal)
                    // **Image Preview Scroll**
                    VStack{
                        HStack{
                            Text("Select Images")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                            Spacer()
                            PhotosPicker(selection: $viewModel.selectedItems, matching: .images, photoLibrary: .shared()){
                                Label("", systemImage: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                            }.onChange(of: viewModel.selectedItems) { _ , _ in viewModel.loadImages()
                            }
                        }
                    }.padding(.horizontal)
                    Group {
                        if !viewModel.selectedImages.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.selectedImages, id: \.self) { image in
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100,height: 100)
                                                .clipped()
                                                .cornerRadius(10)
                                            
                                            Button(action: {
                                                if let index = viewModel.selectedImages.firstIndex(of: image) {
                                                    viewModel.selectedImages.remove(at: index)
                                                    viewModel.selectedItems.remove(at: index)
                                                }
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.white)
                                                    .background(Color.black.opacity(0.6))
                                                    .clipShape(Circle())
                                            }
                                        }
                                        .frame(width: 100, height: 100) // Ensure the outer container matches
                                        .clipped()
                                        
                                    }
                                }
                            }
                            .frame(height: 100)
                        } else {
                            PhotosPicker(selection: $viewModel.selectedItems, matching: .images, photoLibrary: .shared()) {
                                VStack(spacing: 8) {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45, height: 45)
                                        .foregroundColor(Color(red: 0, green: 0.387, blue: 0.5))
                                    
                                    Text("No images selected")
                                        .font(.footnote)
                                        .foregroundColor(Color(red: 0, green: 0.387, blue: 0.5))
                                }
                                .frame(maxWidth: .infinity, minHeight: 100)
                            }
                            .onChange(of: viewModel.selectedItems) { _, _ in
                                viewModel.loadImages()
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    
                    
                    VStack(alignment: .leading) {
                        HStack{
                            Text("Select Tag")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                        }
                        .padding(.bottom, 5)
                        Divider()
                        
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.tag, id: \.self) { tag in
                                Text(tag)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.selectedTag == tag ? Color.init(red: 0, green: 0.387, blue: 0.5) : Color(red: 0, green: 0.387, blue: 0.5).opacity(0.1))
                                    .foregroundColor(viewModel.selectedTag == tag ? .white : Color(red: 0, green: 0.387, blue: 0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture {
                                        viewModel.selectedTag = tag
                                    }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    Spacer()
                }.toolbar {
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        if isPosting{
                            ProgressView().progressViewStyle(CircularProgressViewStyle())
                        }
                        else{
                            Button {
                                isPosting = true
                                Task {
                                    await viewModel.addPost(currentUser: authViewModel.currentUser)
                                    onPostAdded?()
                                    isPosting = false
                                    dismiss()
                                }
                            } label: {
                                Text("Post")
                            }.disabled(viewModel.postContent.trimmingCharacters(in: .whitespaces).isEmpty || isPosting)
                        }
                    }
                }
            }
            .padding()
        }
    }
    @ViewBuilder
    func GuidelineItem(text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text("•")
                .font(.body)
                .padding(.top, 1)
            Text(text)
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }

}

#Preview {
    AddNewPostView().environmentObject(AuthViewModel())
}


