//
//  ShapeMatchingDisplayView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 08/07/25.
//

import SwiftUI

struct ShapeMatchingDisplayView: View {
    var body: some View {
        ZStack {
            // Light gradient background using the Auticare theme color
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0, green: 0.387, blue: 0.5).opacity(0.1),
                            Color(red: 0, green: 0.387, blue: 0.5).opacity(0.05)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 200, height: 200)
                .shadow(radius: 2)

            // Shapes
            Circle()
                .fill(Color.gray)
                .frame(width: 50, height: 50)
                .offset(x: -40, y: -30)

            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 40)
                .offset(x: 30, y: -40)

            Triangle()
                .fill(Color.gray.opacity(0.7))
                .frame(width: 50, height: 50)
                .offset(x: -30, y: 30)

            Hexagon()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 60, height: 60)
                .offset(x: 30, y: 40)
        }
        .frame(width: 200, height: 200)
    }
}
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))       // top
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))    // bottom right
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))    // bottom left
            path.closeSubpath()
        }
    }
}

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height
        let spacing = width * 0.25

        return Path { path in
            path.move(to: CGPoint(x: width * 0.5, y: 0))
            path.addLine(to: CGPoint(x: width, y: spacing))
            path.addLine(to: CGPoint(x: width, y: height - spacing))
            path.addLine(to: CGPoint(x: width * 0.5, y: height))
            path.addLine(to: CGPoint(x: 0, y: height - spacing))
            path.addLine(to: CGPoint(x: 0, y: spacing))
            path.closeSubpath()
        }
    }
}


#Preview {
    ShapeMatchingDisplayView()
}
