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
                SectionView(title: "Games", description: "Hello There", item:  [Items(name: "Color Matching", image: "shapeQuiz"),
                    Items(name: "Color Matching", image: "shapeQuiz"),
                    Items(name: "Color Matching", image: "shapeQuiz"),
                    Items(name: "Color Matching", image: "shapeQuiz")])
                SectionView(title: "Videos", description: "Hello There", item:  [Items(name: "Color Matching", image: "shapeQuiz"),
                    Items(name: "Hello World", image: "shapeQuiz"),
                    Items(name: "Color Matching", image: "shapeQuiz"),
                    Items(name: "Color Matching", image: "shapeQuiz")])
                SectionView(title: "WorkSheets", description: "Hello There", item:  [Items(name: "Color Matching", image: "shapeQuiz"),
                    Items(name: "Color Matching", image: "shapeQuiz"),
                    Items(name: "Color Matching", image: "shapeQuiz"),
                    Items(name: "Color Matching", image: "shapeQuiz")])
            }
            .navigationTitle("Learning")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LearningTabView()
}
