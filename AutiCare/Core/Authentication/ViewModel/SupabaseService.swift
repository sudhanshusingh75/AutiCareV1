//
//  SupabaseService.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 29/03/25.
//

import Foundation
import Supabase

class SupabaseService{
    private let client = SupabaseClient(supabaseURL: URL(string: "https://zaaxtksuazyvxntlwmrn.supabase.co")!,
                                        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InphYXh0a3N1YXp5dnhudGx3bXJuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgzMTk2ODIsImV4cCI6MjA1Mzg5NTY4Mn0.5IBPLi4bdv0e04rWbaqqB9U3YDh23py4ieTijArJA8M")
    
    func fetchVideos() async throws -> [Videos] {
        print("🟡 Fetching videos from Supabase Storage...")

        let bucketName = "learningvideos"
        let storage = client.storage.from(bucketName)

        do {
            let files = try await storage.list(path: "")
            print("🟢 Files found: \(files.map { $0.name })")

            if files.isEmpty {
                print("❌ No videos found in Supabase Storage.")
                return []
            }

            return try files.map { file in
                let url = try storage.getPublicURL(path: file.name)
                print("✅ Video: \(file.name) -> \(url)")
                return Videos(name: file.name, url: url.absoluteString)
            }
        } catch {
            print("❌ Error fetching videos: \(error.localizedDescription)")
            throw error
        }
    }

    
}
