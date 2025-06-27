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
            Group{
                CommunityView()
                    .tabItem {
                        Label("Community", systemImage: "person.3.fill")
                    }
                
                LearningTabView()
                    .tabItem {
                        Label("Learning", systemImage:"book.fill")
                    }
                
                ProgressTab()
                    .tabItem {
                        Label("Progress", systemImage: "chart.bar")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
            }
        }
        .tint(Color.init(red: 0, green: 0.387, blue: 0.5))
    }
}

#Preview {
    TabBarView()
}
