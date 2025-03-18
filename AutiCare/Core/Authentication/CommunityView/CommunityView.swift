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
    @State private var inputText : String = ""
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Select View", selection: $selectedSegment) {
                    Text("Feed").tag(0)
                    Text("Explore").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedSegment == 0 {
                    FeedView()
                        // Show FeedView when "Feed" is selected
                } else {
                    // Add your ExploreView here
                    ExploreView()
                }
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
//                ToolbarItem(placement: .topBarTrailing) {
//                    NavigationLink(destination:ChatView()) {
//                        Image(systemName: "message")
//                    }
//                }
            }
        }
    }
}

#Preview {
    CommunityView()
}
