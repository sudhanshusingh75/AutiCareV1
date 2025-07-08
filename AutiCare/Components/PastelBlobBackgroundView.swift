//
//  BackgroundCirclesView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 04/07/25.
//

import SwiftUI

struct PastelBlobBackgroundView: View {
    let colors: [Color] = [
        Color(red: 1.0, green: 0.8, blue: 0.8), // light pink
        Color(red: 0.8, green: 0.9, blue: 1.0), // light blue
        Color(red: 0.9, green: 1.0, blue: 0.9), // mint
        Color(red: 1.0, green: 1.0, blue: 0.8), // light yellow
        Color(red: 0.95, green: 0.85, blue: 1.0) // lavender
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<30, id: \.self) { _ in
                    Ellipse()
                        .fill(colors.randomElement()!.opacity(0.4))
                        .frame(width: CGFloat.random(in: 40...100),
                               height: CGFloat.random(in: 20...60))
                        .rotationEffect(.degrees(Double.random(in: 0...360)))
                        .position(x: CGFloat.random(in: 0...geometry.size.width),
                                  y: CGFloat.random(in: 0...geometry.size.height))
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    PastelBlobBackgroundView()
}
