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
    @Binding var posts: [Posts]
    var onPostAdded: (() -> Void)?
    @StateObject private var viewModel = AddNewPostViewModel()
    @StateObject private var profileVM = ProfileViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 16) {
                    
                    // **Post Description**
                    VStack(alignment: .leading) {
                        Text("Add Post Description")
                            .foregroundStyle(.gray)
                        TextEditor(text: $viewModel.postContent)
                            .frame(height: 150)
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                            .onChange(of: viewModel.postContent) { _, _ in viewModel.enforceLimits() }
                    }
                    .padding(.horizontal)
                    // **Image Preview Scroll**
                    VStack{
                        Text("Select Images")
                            .foregroundStyle(.gray)
                    }.padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    .frame(height:100)
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    
                    HStack(spacing:20) {
                        Spacer()
                        PhotosPicker(selection: $viewModel.selectedItems, matching: .images, photoLibrary: .shared()){
                            Button { } label: {
                                Image(systemName: "camera")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 18,height: 18)
                            }
                        }
                        PhotosPicker(selection: $viewModel.selectedItems, matching: .images, photoLibrary: .shared()){
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 18,height: 18)
                        }.onChange(of: viewModel.selectedItems) { _ , _ in viewModel.loadImages() }
                    }
                    
                    .padding(.horizontal,20)
                    
                    VStack(alignment: .leading) {
                        HStack{
                            Text("Select Tag")
                                .foregroundStyle(.gray)
                        }
                        .padding(.bottom, 5)
                        Divider()
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.tag, id: \.self) { tag in
                                Text(tag)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.selectedTag == tag ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                    .foregroundColor(viewModel.selectedTag == tag ? .blue : .black)
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
                        Button {
                            Task {
                                await viewModel.addPost(currentUser: authViewModel.currentUser)
                                onPostAdded?()
                                dismiss()
                            }
                        } label: {
                            Text("Post")
                        }.disabled(viewModel.postContent.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
        }
        .padding()
    }
}

