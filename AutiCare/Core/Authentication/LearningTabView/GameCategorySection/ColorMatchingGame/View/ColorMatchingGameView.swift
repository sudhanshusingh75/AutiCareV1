//
//  ColorMatchingGameView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 04/07/25.
//

import SwiftUI

struct ColorMatchingGameView: View {
    @StateObject private var viewModel = ColorMatchingGameViewModel(level: basicLevel)
    @Environment(\.dismiss) var dismiss
    @State private var showResult = false
    
    var body: some View {
        NavigationStack {
            if viewModel.isGameOver{
                GameResultView(
                    score: viewModel.score,
                    total: viewModel.totalQuestions,
                    onRestart: {
                        viewModel.restartGame()
                        showResult = false
                    },
                    onQuit: {
                        dismiss()
                    }
                )
                .onAppear {
                    AudioManager.shared.speak("You scored \(viewModel.score) out of \(viewModel.totalQuestions). Well done!")
                }
            }
            else{
                ZStack{
                    PastelBlobBackgroundView()
                    VStack(spacing: 40) {
                        HStack {
                            Text("Score: \(viewModel.score)")
                                .padding()
                                .foregroundStyle(.white)
                                .background(.orange)
                                .cornerRadius(20)
                            Spacer()
                            Text("Question: \(viewModel.questionCount)/\(viewModel.totalQuestions)")
                                .padding()
                                .foregroundStyle(.white)
                                .background(.orange)
                                .cornerRadius(20)
                            
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                        
                        // Target Color Display
                        VStack(spacing: 12) {
                            Text("Match This Color")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                            
                            RoundedRectangle(cornerRadius: 30)                           .fill(viewModel.targetColor.color)
                                .frame(width: 180, height: 150)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 30).stroke(.black,lineWidth: 2)
                                    Text(viewModel.targetColor.name)
                                        .foregroundStyle(
                                            ["Yellow", "Green"].contains(viewModel.targetColor.name) ? .black : .white
                                        )
                                        .font(.largeTitle.bold())
                                }
                        }
                        
                        // Game Instructions
                        Text("Select the Correct Color")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(red: 0, green: 0.387, blue: 0.5))
                        // Color Options Grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                            ForEach(viewModel.options) { colorItem in
                                Button(action: {
                                    viewModel.selectColor(colorItem)
                                    
                                    // Show result screen when game finishes
                                    if viewModel.questionCount >= viewModel.totalQuestions {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            showResult = true
                                        }
                                    }
                                }) {
                                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                                        .fill(colorItem.color)
                                        .frame(width: 180, height: 150)
                                        .overlay{
                                            RoundedRectangle(cornerRadius: 30).stroke(.black, lineWidth: 2)
                                            Text(colorItem.name)
                                                .foregroundStyle(
                                                    ["Yellow", "Green"].contains(colorItem.name) ? .black : .white
                                                )
                                                .font(.largeTitle.bold())
                                        }
                                }
                                .disabled(viewModel.isGameOver)
                            }
                        }
                    }
                    .padding()
                    .animation(.easeInOut, value: viewModel.isAnswerCorrect)
                    // Feedback
                    if let feedback = viewModel.feedbackMessage {
                        Text(feedback)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(20)
                            .background(
                                viewModel.isAnswerCorrect == true ? Color.green : Color.red
                            )
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .transition(.opacity)
                            .zIndex(1)
                    }
                    
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ColorMatchingGameView()
}
