//
//  ColorBackGround.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 08/07/25.
//

import SwiftUI

struct ColorMatchingDisplayView: View {
    var body: some View {
            ZStack {
                // Light gradient background with max opacity 0.1
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

                // Colorful shapes
                Circle()
                    .fill(Color.green.opacity(0.6))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(15))
                    .offset(x: -40, y: -40)

                Circle()
                    .fill(Color.blue.opacity(0.6))
                    .frame(width: 70, height: 70)
                    .offset(x: 30, y: -30)

                Circle()
                    .fill(Color.red.opacity(0.6))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-10))
                    .offset(x: -20, y: 30)

                Circle()
                    .fill(Color.yellow.opacity(0.6))
                    .frame(width: 80, height: 30)
                    .offset(x: 30, y: 40)
            }
            .frame(width: 150, height: 150)
        }
}

#Preview {
    ColorMatchingDisplayView()
}
