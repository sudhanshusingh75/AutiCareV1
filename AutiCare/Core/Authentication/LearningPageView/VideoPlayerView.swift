//
//  VideoPlayer.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 29/03/25.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoURL:String
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            if let url = URL(string: videoURL){
                AVPlayerUIView(url: url)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
            }
            else{
                Text("Invalid Video URL")
            }
        }
        .overlay(
            Button(action: {
                presentationMode.wrappedValue.dismiss() // ✅ Exit video screen
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
                    .padding()
                    
            },alignment: .topLeading
            
        )
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden,for: .tabBar)
//        .onDisappear{
//            UINavigationController().setNavigationBarHidden(false, animated: true)
//        }
    }
}

