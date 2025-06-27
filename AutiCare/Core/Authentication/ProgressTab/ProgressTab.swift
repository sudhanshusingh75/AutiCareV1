//
//  ProgressTab.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 26/06/25.
//

import SwiftUI

struct ProgressTab: View {
    var body: some View {
        NavigationStack{
            ScrollView{
                AssessmentSectionView()
                ResultSectionView()
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProgressTab()
}
