//
//  BackgroundCirclesView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 04/07/25.
//

import SwiftUI

struct BackgroundCirclesView: View {
    @State private var circles: [CircleData] = []
    let circleCount = 35
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(circles) { circle in
                    Circle()
                        .fill(circle.color.opacity(circle.opacity))
                        .frame(width: circle.size, height: circle.size)
                        .position(circle.position)
                        .blur(radius: circle.blur)
                        .animation(.easeInOut(duration: circle.animationDuration).repeatForever(autoreverses: true), value: circle.id)
                }
            }
            .onAppear {
                circles = (0..<circleCount).map { _ in
                    CircleData(in: geometry.size)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct CircleData: Identifiable {
    let id = UUID()
    let size: CGFloat
    let color: Color
    let opacity: Double
    let blur: CGFloat
    let animationDuration: Double
    let position: CGPoint

    init(in size: CGSize) {
        self.size = CGFloat.random(in: 10...80)
        self.color = Color(
            hue: Double.random(in: 0...1),
            saturation: 0.3,
            brightness: 1
        )
        self.opacity = Double.random(in: 0.5...0.8)
        self.blur = CGFloat.random(in: 1...5)
        self.animationDuration = Double.random(in: 2...5)
        self.position = CGPoint(
            x: CGFloat.random(in: 0...size.width),
            y: CGFloat.random(in: 0...size.height)
        )
    }
}

#Preview {
    BackgroundCirclesView()
}
