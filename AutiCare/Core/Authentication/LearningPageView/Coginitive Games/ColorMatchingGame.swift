//
//  ColorMatchingGame.swift
//  Auticare
//
//  Created by sourav_singh on 20/03/25.
//

import SwiftUI

struct ColorMatchingGame: View {
    // Game State
    @State private var targetPattern: [Color] = []
    @State private var playerPattern: [Color] = []
    @State private var timeRemaining = 30
    @State private var isGameOver = false
    @State private var showInstructions = true
    @State private var isGameWon = false
    
    // Timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Available Colors
    let colors: [Color] = [.red, .blue, .green, .yellow]
    
    // Initialize the game
    init() {
        _targetPattern = State(initialValue: generateTargetPattern())
        _playerPattern = State(initialValue: Array(repeating: .gray, count: 4))
    }
    
    var body: some View {
        ZStack {
            if showInstructions {
                InstructionssssView(startGame: {
                    showInstructions = false
                })
            } else {
                VStack {
                    // Title
                    
                    // Timer
                    Text("Time: \(timeRemaining)")
                        .font(.title2)
                        .foregroundColor(.green)
                        .padding()
                    
                    // Target Pattern
                    Text("Match This Pattern:")
                        .font(.title2)
                        .padding()
                    HStack {
                        ForEach(targetPattern.indices, id: \.self) { index in
                            Circle()
                                .fill(targetPattern[index])
                                .frame(width: 50, height: 50)
                        }
                    }
                    .padding()
                    
                    // Player Pattern
                    Text("Your Pattern:")
                        .font(.title2)
                        .padding()
                    HStack {
                        ForEach(playerPattern.indices, id: \.self) { index in
                            Circle()
                                .fill(playerPattern[index])
                                .frame(width: 50, height: 50)
                                .onTapGesture {
                                    changeColor(at: index)
                                }
                        }
                    }
                    .padding()
                    
                    // Reset Button
                    Button(action: resetGame) {
                        Text("Reset Game")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        isGameOver = true
                        isGameWon = false
                    }
                }
                .alert(isPresented: $isGameOver) {
                    Alert(
                        title: Text(isGameWon ? "Congratulations 🎉🎉!" : "Time's Up!"),
                        message: Text(isGameWon ? "You matched the pattern in time!" : "You didn't match the pattern in time."),
                        dismissButton: .default(Text("Play Again")) {
                            resetGame()
                        }
                    )
                }
            }
        }.toolbar(.hidden, for: .tabBar)
    }
    
    // Change Color in Player Pattern
    func changeColor(at index: Int) {
        let currentColor = playerPattern[index]
        let currentIndex = colors.firstIndex(of: currentColor) ?? -1
        let nextIndex = (currentIndex + 1) % colors.count
        playerPattern[index] = colors[nextIndex]
        
        // Check for a match
        if playerPattern == targetPattern {
            isGameOver = true
            isGameWon = true
        }
    }
    
    // Reset the Game
    func resetGame() {
        targetPattern = generateTargetPattern()
        playerPattern = Array(repeating: .gray, count: 4)
        timeRemaining = 30
        isGameOver = false
        isGameWon = false
    }
    
    // Generate a Random Target Pattern
    func generateTargetPattern() -> [Color] {
        var pattern: [Color] = []
        for _ in 0..<4 {
            pattern.append(colors.randomElement()!)
        }
        return pattern
    }
}

// Instruction View
struct InstructionssssView: View {
    var startGame: () -> Void
    
    var body: some View {
        VStack {
            Text("Game Instructions")
                .font(.largeTitle)
                .padding()
        
            Text("1. A target pattern of colored circles will appear at the top.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.yellow)
            Text("2. Tap on the gray circles below to change their colors.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.yellow)
            Text("3. Match the target pattern within 30 seconds to win!")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.yellow)
            Button(action: startGame) {
                Text("Start Game")
                    .font(.title2)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

// Preview
struct ColorMatchingGame_Previews: PreviewProvider {
    static var previews: some View {
        ColorMatchingGame()
    }
}
