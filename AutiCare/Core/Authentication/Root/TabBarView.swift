//
//  TabBarView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 11/02/25.
//

import SwiftUI

struct TabBarView: View {
    
    var body: some View {
        TabView{
            CommunityView()
            .tabItem {
                Label("Home", systemImage: "house")
            }
            LearningPageView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Learning")
                }
            ProgressTabView()
                            .tabItem {
                                Label("Progress", systemImage: "chart.bar")
                            }
            ProfileView()
            .tabItem {
                Label("Profile", systemImage: "person.circle")
            }
        }
    }
}

#Preview {
    TabBarView()
}
