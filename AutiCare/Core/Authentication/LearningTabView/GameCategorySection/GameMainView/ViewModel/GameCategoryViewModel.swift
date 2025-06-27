//
//  GameCategoryViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 25/06/25.
//

import Foundation

class GameCategoryViewModel:ObservableObject{
    @Published var categories:[GameCategory] = [
        GameCategory(name: "Matching Games", imageUrl: "square.grid.2x2.fill"),
        GameCategory(name: "Number Games", imageUrl: "123.rectangle.fill"),
        GameCategory(name: "Memory Games", imageUrl: "brain.head.profile"),
        GameCategory(name: "Color Games", imageUrl: "paintpalette.fill")
    ]
}
