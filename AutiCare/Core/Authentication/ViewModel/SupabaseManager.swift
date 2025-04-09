//
//  SupabaseManager.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 09/04/25.
//

import Foundation
import Supabase

final class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient
    let storage: SupabaseStorageClient

    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: "https://zaaxtksuazyvxntlwmrn.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InphYXh0a3N1YXp5dnhudGx3bXJuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgzMTk2ODIsImV4cCI6MjA1Mzg5NTY4Mn0.5IBPLi4bdv0e04rWbaqqB9U3YDh23py4ieTijArJA8M"
        )
        self.storage = client.storage
    }
}
