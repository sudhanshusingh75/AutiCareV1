//
//  VideoSectionView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 25/06/25.
//

import SwiftUI

struct VideoSectionView: View {
    
    @StateObject private var viewModel = VideoViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Videos")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Spacer()
                NavigationLink(destination: Text("Hello World")) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color(red: 0, green: 0.387, blue: 0.5))
            .cornerRadius(20)
            .padding(.horizontal)
            
            if viewModel.videos.isEmpty {
                ProgressView("Loading videos...")
                    .frame(height: 100)
                    .onAppear {
                        Task {
                            await viewModel.loadVideos()
                        }
                    }
            } else {
                let total = viewModel.videos.count
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.videos.prefix(total)) { video in
                            NavigationLink(destination:VideoSectionVideoPlayer(video: video)) {
                                VStack{
                                    Image(systemName: "play.rectangle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                                        
                                    Text(video.name)
                                        .font(.headline)
                                        .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: 150,height: 150)
                                .padding()
                                .background(Color(red: 0, green: 0.387, blue: 0.5).opacity(0.1))
                                .cornerRadius(16)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}


#Preview {
    VideoSectionView()
}
