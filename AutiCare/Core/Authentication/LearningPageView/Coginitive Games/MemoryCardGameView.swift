//
//  MemoryCardGameView.swift
//  Auticare
//
//  Created by sourav_singh on 20/02/25.
//

import SwiftUI

struct MemoryCardGameView: View {
    @State private var cards: [Card] = []
    @State private var firstFlippedIndex: Int? = nil
    @State private var matchedPairs = 0
    @State private var timeLeft = 60
    @State private var gameOver = false
    @State private var showInstructions = true
    @State private var timer: Timer?
    
    let columns = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                if showInstructions {
                    InstructionsView(startGame: startGame)
                        .transition(.scale)
                } else {
                    Text("Time Left: \(timeLeft)s")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(cards.indices, id: \ .self) { index in
                            CardView(card: cards[index])
                                .onTapGesture {
                                    flipCard(at: index)
                                }
                        }
                    }
                    .padding()
                    
                    if gameOver {
                        VStack {
                            Text(matchedPairs == cards.count / 2 ? "🎉 YOU WON! 🎉" : "Game Over! Try Again")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                            
                            Button(action: startGame) {
                                Text("Play Again")
                                    .font(.title2)
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .onAppear {
            setupGame()
        }
    }
    
    func startGame() {
        showInstructions = false
        setupGame()
        startTimer()
    }
    
    func setupGame() {
        let images = ["apple", "orange", "grapes", "watermelon", "strawberry", "cherry"]
        let shuffledImages = (images + images).shuffled()
        cards = shuffledImages.map { Card(imageName: $0) }
        matchedPairs = 0
        timeLeft = 60
        gameOver = false
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                gameOver = true
                timer?.invalidate()
            }
        }
    }
    
    func flipCard(at index: Int) {
        guard !cards[index].isMatched, !cards[index].isFlipped else { return }
        
        cards[index].isFlipped = true
        
        if let firstIndex = firstFlippedIndex {
            if cards[firstIndex].imageName == cards[index].imageName {
                cards[firstIndex].isMatched = true
                cards[index].isMatched = true
                matchedPairs += 1
                if matchedPairs == cards.count / 2 {
                    gameOver = true
                    timer?.invalidate()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    cards[firstIndex].isFlipped = false
                    cards[index].isFlipped = false
                }
            }
            firstFlippedIndex = nil
        } else {
            firstFlippedIndex = index
        }
    }
}

struct Card: Identifiable {
    let id = UUID()
    let imageName: String
    var isFlipped = false
    var isMatched = false
}

struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack {
            if card.isFlipped || card.isMatched {
                Image(card.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.green.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "questionmark")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    )
                    .shadow(radius: 5)
            }
        }
        .animation(.easeInOut, value: card.isFlipped)
    }
}

struct InstructionsView: View {
    var startGame: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Memory Card Game")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            Text("Match all the pairs before time runs out!")
                .font(.title3)
                .foregroundColor(.yellow)
            Text("Click on a card to reveal its image. Find the matching image to form a pair.")
                .padding()
                .foregroundColor(.white)
            Button(action: startGame) {
                Text("Start Game")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(0.8)))
        .shadow(radius: 10)
    }
}

struct MemoryCardGameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryCardGameView()
    }
}




#Preview {
    MemoryCardGameView()
}

