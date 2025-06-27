//
//  VideoPlayerView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 25/06/25.
//

import SwiftUI
import AVKit

struct VideoPlayer: View {
    let video: Videos
    var body: some View {
        VStack {
            if let url = URL(string: video.url) {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(height: 250)
                    .cornerRadius(12)
                    .padding()
            } else {
                Text("Invalid video URL")
                    .foregroundColor(.red)
            }

            Text(video.name)
                .font(.title2)
                .padding(.top)

            Spacer()
        }
        .navigationTitle(video.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

