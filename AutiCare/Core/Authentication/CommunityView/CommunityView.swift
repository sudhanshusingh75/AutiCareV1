//
//  CommunityView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 08/02/25.
//

import SwiftUI
import FirebaseAuth
struct CommunityView: View {
    @State private var selectedSegment = 0
    @State private var searchViewisPresented = false

    var body: some View {
        NavigationStack {
            VStack {
                    FeedView()
                    .padding(.vertical)
            }
            .navigationTitle("Community")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    NavigationLink {
                        AddNewPostView()
                    } label: {
                        Image(systemName: "plus.app")
                            .foregroundStyle(Color.init(red: 0, green: 0.387, blue: 0.5))
                    }
                }
            }
        }
    }
}

#Preview {
    CommunityView()
}
