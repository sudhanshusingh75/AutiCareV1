//
//  ShapeItem.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 08/07/25.
//

import Foundation
import SwiftUI

struct ShapeItem: Identifiable, Equatable {
    let id = UUID()
    let shapeType: ShapeType
    let color: Color
}

enum ShapeType: String, CaseIterable {
    case circle, square, triangle, hexagon

    @ViewBuilder
    func filledShape(color: Color) -> some View {
        switch self {
        case .circle:
            Circle().fill(color)
        case .square:
            Rectangle().fill(color)
        case .triangle:
            Triangle().fill(color)
        case .hexagon:
            Hexagon().fill(color)
        }
    }

    @ViewBuilder
    func strokedShape(style: StrokeStyle = StrokeStyle(lineWidth: 3, dash: [5])) -> some View {
        switch self {
        case .circle:
            Circle().stroke(style: style)
        case .square:
            Rectangle().stroke(style: style)
        case .triangle:
            Triangle().stroke(style: style)
        case .hexagon:
            Hexagon().stroke(style: style)
        }
    }
}

