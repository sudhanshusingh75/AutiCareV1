//
//  VideoSectionView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 25/06/25.
//

import SwiftUI

struct VideoSectionView: View {
    
    @StateObject private var viewModel = VideoViewModel()
    @State private var showAlert: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Videos")
                    .font(.largeTitle.bold())
//                    .foregroundStyle(.white)
//                Spacer()
//                NavigationLink(destination: Text("Hello World")) {
//                    Text("See All")
//                        .font(.subheadline)
//                        .foregroundColor(.white)
//                }
                Spacer(minLength: 8)
                Button {
                    showAlert = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(Color(red:0,green:0.387,blue:0.5))
                }
                .alert(isPresented: $showAlert){
                    Alert(title: Text("About Videos"),message: Text("These videos are created to support learning and engagement for autistic children. They are general educational resources and do not substitute professional therapy or diagnosis."),dismissButton: .default(Text("Got it!")))
                }
            }
            .padding()
//            .background(Color(red: 0, green: 0.387, blue: 0.5))
//            .cornerRadius(20)
//            .padding(.horizontal)
            
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
                    HStack{
                        ForEach(viewModel.videos.prefix(total)) { video in
                            NavigationLink(destination:VideoSectionVideoPlayer(video: video)) {
                                HStack(spacing:16){
                                    Image(systemName: "play.rectangle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                        .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                                        
                                    Text(video.name)
                                        .font(.headline)
                                        .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                                        .multilineTextAlignment(.leading)
                                }
                                .frame(width: 150,height: 100)
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
