//
//  VideoViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 29/03/25.
//

import Foundation

@MainActor
class VideoViewModel:ObservableObject{
    
    @Published var videos : [Videos] = []
    private let supabaseService = SupabaseService()
    
    func loadVideos() async{
        do{
            let fetchedVideos = try await supabaseService.fetchVideos()
            self.videos = fetchedVideos
            print(fetchedVideos)
        }
        catch{
            print("Failed to load Videos : \(error.localizedDescription)")
        }
    }
    
}
