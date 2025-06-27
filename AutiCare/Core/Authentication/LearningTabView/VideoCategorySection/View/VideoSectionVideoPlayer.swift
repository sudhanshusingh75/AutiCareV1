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
    var body: some View {
        VStack {
            if let url = URL(string: video.url) {
                VideoPlayer(player:
                                AVPlayer(url: url)
                )
//                .aspectRatio(contentMode: .fit)
//                .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                
            } else {
                Text("Invalid video URL")
                    .foregroundColor(.red)
            }
        }
        .toolbar(.hidden,for: .tabBar)
    }
}

