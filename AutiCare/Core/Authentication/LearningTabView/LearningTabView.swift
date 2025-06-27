//
//  LearningTabView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 25/06/25.
//

import SwiftUI

struct LearningTabView: View {
    var body: some View {
        NavigationStack{
            ScrollView{
                GameCategoryListView()
                VideoSectionView()
            }
            .navigationTitle("Learning")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LearningTabView()
}
