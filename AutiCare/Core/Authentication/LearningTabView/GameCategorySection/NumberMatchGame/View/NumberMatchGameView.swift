//
//  NumberMatchGameView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 07/07/25.
//

import SwiftUI

struct NumberMatchGameView: View {
    @StateObject private var viewModel = NumberMatchGameViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showResult = false
    
    var body: some View {
        VStack {
            Text("Match the Numbers")
                .font(.largeTitle.bold())
                .padding()
            
            HStack {
                VStack {
                    Text("Numbers")
                        .font(.headline)
                    ForEach(viewModel.numbers) { item in
                        if !item.isMatched {
                            Button("\(item.number)") {
                                AudioManager.shared.speak("\(item.number)")
                            }
                            .font(.title)
                            .padding()
                            .background(Color.yellow)
                            .clipShape(Circle())
                        }
                    }
                }
                
                VStack {
                    Text("Dots")
                        .font(.headline)
                    ForEach(viewModel.dots) { item in
                        if !item.isMatched {
                            Button {
                                viewModel.checkMatch(number: viewModel.numbers.first(where: { !$0.isMatched })!, dot: item)
                            } label: {
                                Text(String(repeating: "●", count: item.number))
                                    .font(.title)
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
            }
            .padding()

            Text("Score: \(viewModel.score)")
                .font(.title2)
                .padding()
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
                    viewModel.startGame()
                    showResult = false
                },
                onQuit: {
                    dismiss()
                }
            )
        }
    }
}


#Preview {
    NumberMatchGameView()
}
