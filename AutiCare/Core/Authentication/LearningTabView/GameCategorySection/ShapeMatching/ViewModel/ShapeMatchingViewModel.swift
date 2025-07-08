//
//  ShapeMatchingViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 08/07/25.
//

import Foundation
import SwiftUI

class ShapeMatchingViewModel: ObservableObject {
    @Published var draggableShapes: [ShapeItem] = []
    @Published var targetShapes: [ShapeItem] = []
    @Published var matchedShapes: [UUID] = []
    @Published var score: Int = 0
    @Published var isGameComplete: Bool = false

    init() {
        generateShapes()
    }

    func generateShapes() {
        matchedShapes = []
        score = 0
        isGameComplete = false

        let shapeCount = 6
        let shapeTypes = (0..<shapeCount).map { _ in ShapeType.allCases.randomElement()! }
        let shapes = shapeTypes.map { ShapeItem(shapeType: $0, color: .random) }

        draggableShapes = shapes
        targetShapes = shapes.shuffled()
    }

    func match(shape: ShapeItem, with target: ShapeItem) -> Bool {
        let isMatch = shape.shapeType == target.shapeType
        if isMatch, !matchedShapes.contains(target.id) {
            matchedShapes.append(target.id)
            score += 1
            checkIfGameComplete()
        }
        return isMatch
    }

    func checkIfGameComplete() {
        isGameComplete = matchedShapes.count == targetShapes.count
    }
}
extension Color {
    static var random: Color {
        let colors: [Color] = [.red, .green, .blue, .orange, .purple, .pink]
        return colors.randomElement() ?? .gray
    }
}

