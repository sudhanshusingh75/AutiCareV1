//
//  GameCategoryViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 25/06/25.
//

import Foundation

class GameCategoryViewModel:ObservableObject{
    @Published var categories:[GameCategory] = [
        GameCategory(name: "Matching Games", imageUrl: "square.grid.2x2.fill", games: [GameItem(title: "Color Matching", imageName: "ColorMatching"),GameItem(title: "Shape Matching", imageName: "ShapeMatching")]),
        GameCategory(name: "Number Games", imageUrl: "123.rectangle.fill", games: [/*GameItem(title: "Number Match", imageName: "xyz")*/]),
        GameCategory(name: "Memory Games", imageUrl: "brain.head.profile", games: [GameItem(title: "Memory Match", imageName: "MemoryMatch")]),
    ]
}
