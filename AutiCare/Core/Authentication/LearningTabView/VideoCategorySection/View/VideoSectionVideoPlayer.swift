//
//  VideoPlayerView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 25/06/25.
//

import SwiftUI
import AVKit

struct VideoSectionVideoPlayer: View {
    let video: Videos
    @State private var player: AVPlayer? = nil

    var body: some View {
        VStack {
            if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .onAppear {
                        player.play()
                        player.isMuted = false
                    }
            } else {
                Text("Invalid video URL")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            if let url = URL(string: video.url) {
                player = AVPlayer(url: url)
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}


