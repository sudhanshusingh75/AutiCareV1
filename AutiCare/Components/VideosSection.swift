//
//  VideosSection.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 29/03/25.
//

import SwiftUI

struct VideosSection: View {
    let title: String
    let description: String
    
    @StateObject private var viewModel = VideoViewModel()
    @State private var showDescription = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // MARK: - Title & Description Button
            headerView
            
            // MARK: - Video List
            if viewModel.videos.isEmpty {
                ProgressView("Loading videos...") // Show loading indicator
                    .padding()
            } else {
                videoListView
            }
        }
        .task {
            await viewModel.loadVideos()
        }
    }
}

// MARK: - Extracted Components
extension VideosSection {
    private var headerView: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Button(action: {
                showDescription.toggle()
            }) {
                Image(systemName: "info.circle")
                    .foregroundColor(.white)
            }
            .alert(title, isPresented: $showDescription) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(description)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.mint)
        .cornerRadius(15)
        .padding(.horizontal)
    }

    private var videoListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(viewModel.videos) { video in
                    NavigationLink(destination: VideoSectionVideoPlayer(video: video)) {
                        videoCard(video: video)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func videoCard(video: Videos) -> some View {
        VStack {
            Image(.videoPlayButton)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 5)
            
            Text(video.name)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.top, 5)
        }
        .frame(width: 160, height: 180)
        .background(Color.white)
        .cornerRadius(15)
    }
}

#Preview {
    VideosSection(title: "Videos", description: "Hello World")
}
