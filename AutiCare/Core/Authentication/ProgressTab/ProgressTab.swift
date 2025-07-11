//
//  ProgressTab.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 26/06/25.
//

import SwiftUI

struct ProgressTab: View {
    @StateObject private var navManager = NavigationManager()
    var body: some View {
        NavigationStack{
            ScrollView{
                AssessmentSectionView()
                ResultSectionView()
            }
            .environmentObject(navManager)
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
        }

    }
}

#Preview {
    ProgressTab()
}
