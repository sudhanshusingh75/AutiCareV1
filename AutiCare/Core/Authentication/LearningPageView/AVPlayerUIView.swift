//
//  AVPlayerUIView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 30/03/25.
//

import Foundation
import SwiftUI
import AVKit

struct AVPlayerUIView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerVC = AVPlayerViewController()
        let player = AVPlayer(url: url)
        
        playerVC.player = player
        player.play()  // ✅ Auto-play the video
        playerVC.showsPlaybackControls = true // ✅ Show controls
        playerVC.exitsFullScreenWhenPlaybackEnds = true
        
        return playerVC
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No need to update the player controller
        
    }
}
