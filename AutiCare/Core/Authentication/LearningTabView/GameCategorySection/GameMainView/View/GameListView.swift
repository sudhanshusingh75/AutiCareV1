//
//  GameListView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 07/07/25.
//

import SwiftUI

struct GameListView: View {
    let category: GameCategory
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(category.name)
                    .font(.largeTitle.bold())
                    .padding(.horizontal)

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(category.games) { game in
                        NavigationLink(destination: destinationView(for: game)) {
                            VStack(spacing: 8) {
                                gameDisplayView(for: game)
                                    .frame(width: 100, height: 100)
                                    .background(.white)
                                    .cornerRadius(16)

                                Text(game.title)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0, green: 0.387, blue: 0.5).opacity(0.1))
                            .cornerRadius(20)
                            .shadow(color: .white.opacity(0.4), radius: 4, x: 0, y: 2)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    @ViewBuilder
    private func destinationView(for game: GameItem) -> some View {
        switch game.title {
        case "Color Matching":
            ColorMatchingGameView()
        case "Shape Matching":
            ShapeMatchingGameView()
        case "Memory Match":
            MemoryGameView()
        case "Number Match":
            NumberMatchGameView()
        default:
            Text("Coming Soon...")
        }
    }

    @ViewBuilder
    private func gameDisplayView(for game: GameItem) -> some View {
        switch game.title {
        case "Color Matching":
            ColorMatchingDisplayView()
        case "Shape Matching":
            ShapeMatchingDisplayView()
        case "Memory Match":
            MemoryMatchingDisplayView()
        default:
            Image(game.imageName)
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    GameListView(category: GameCategory(name: "Color Matching", imageUrl: "", games: [GameItem(title: "Shape Matching", imageName: ""),GameItem(title: "Color Matching", imageName: ""),GameItem(title: "Color Matching", imageName: "colorMatching")]))
}
