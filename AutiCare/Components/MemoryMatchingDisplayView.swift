//
//  MemoryMatchingDisplayView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 08/07/25.
//

import SwiftUI

struct MemoryMatchingDisplayView: View {
    var body: some View {
        ZStack {
            // Light background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.85, green: 0.95, blue: 1.0),
                    Color(red: 0.75, green: 0.85, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                HStack(spacing: 16) {
                    MemoryCardPreviewView(symbol: "star", isFaceUp: true)
                    MemoryCardPreviewView(symbol: "sun.max", isFaceUp: false)
                    MemoryCardPreviewView(symbol: "leaf", isFaceUp: true)
                }
                Text("Memory Match")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0, green: 0.387, blue: 0.5))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(24)
            .shadow(radius: 10)
            .padding()
        }
    }
}

struct MemoryCardPreviewView: View {
    let symbol: String
    let isFaceUp: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(isFaceUp ? Color.white : Color(red: 0.4, green: 0.6, blue: 0.8))
                .frame(width: 60, height: 80)
                .shadow(radius: 4)

            if isFaceUp {
                Text(symbol)
                    .font(.largeTitle)
            } else {
                Image(systemName: "questionmark.square.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
        }
    }
}


#Preview {
    MemoryMatchingDisplayView()
}
