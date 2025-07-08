//
//  MemoryGameView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 07/07/25.
//

import SwiftUI

struct MemoryGameView: View {
    @StateObject private var viewModel = MemoryGameViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showResult = false

    let columns = [GridItem(.adaptive(minimum: 80))]

    var body: some View {
        NavigationStack {
            ZStack {
                PastelBlobBackgroundView()
                VStack {
                    Text("Memory Match")
                        .font(.largeTitle.bold())
                        .padding()
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.cards) { card in
                            CardView(card: card)
                                .onTapGesture {
                                    viewModel.flipCard(card)
                                }
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                viewModel.onGameCompleted = {
                    showResult = true
                }
            }
            .fullScreenCover(isPresented: $showResult) {
                GameResultView(
                    score: viewModel.score,
                    total: viewModel.totalAttempts,
                    onRestart: {
                        viewModel.startNewGame()
                        showResult = false
                    },
                    onQuit: {
                        dismiss()
                    }
                )
            }
            .toolbar(.hidden, for: .tabBar)
        }
        .navigationBarBackButtonHidden(true)
    }
}



#Preview {
    MemoryGameView()
}
