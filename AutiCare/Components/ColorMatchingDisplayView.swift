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

            HStack(spacing: 10) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 40, height: 40)
                Circle()
                    .fill(Color.green)
                    .frame(width: 40, height: 40)
                Circle()
                    .fill(Color.blue)
                    .frame(width: 40, height: 40)
            }
        }
        .frame(width: 200, height: 200)
    }
}


#Preview {
    ColorMatchingDisplayView()
}
