//
//  EnglishWordWorksheetView.swift
//  Auticare
//
//  Created by sourav_singh on 21/02/25.
//

import SwiftUI

struct EnglishWordWorksheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let wordOptions: [String: String] = [
        "A": "Apple", "B": "Ball", "C": "Cat", "D": "Dog", "E": "Elephant",
        "F": "Fish", "G": "Goat", "H": "Hat", "I": "Igloo", "J": "Jug",
        "K": "Kite", "L": "Lion", "M": "Monkey", "N": "Nest", "O": "Orange",
        "P": "Parrot", "Q": "Queen", "R": "Rabbit", "S": "Sun", "T": "Tiger",
        "U": "Umbrella", "V": "Violin", "W": "Watch", "X": "Xylophone", "Y": "Yak", "Z": "Zebra"
    ]
    
    let distractors: [String] = ["Chair", "Table", "Rocket", "Moon", "Leaf", "Laptop", "Garden", "Mirror", "Quiz", "Ring",
                                 "Pumpkin", "Necklace", "Octopus", "Train", "Volcano", "Yacht", "Window", "Shoe", "Bag", "Notebook"]

    @State private var selectedAlphabets: [String] = []
    @State private var selectedAnswers: [String: String] = [:]
    @State private var score = 0
    @State private var showScore = false
    @State private var showInstructions = true
    
    var body: some View {
        NavigationView {
            ZStack {
                
                
                VStack {
                    if showInstructions {
                        InstructionsssView(startGame: {
                            showInstructions = false
                            setupGame()
                        })
                        .transition(.scale)
                    } else if showScore {
                        ScoresView(score: score, total: selectedAlphabets.count) {
                            restartGame()
                        }
                    } else {
                        ScrollView {
                            VStack(spacing: 20) {
                                
                                ForEach(selectedAlphabets, id: \.self) { letter in
                                    QuestionsView(
                                        letter: letter,
                                        correctWord: wordOptions[letter] ?? "",
                                        distractors: generateDistractors(excluding: wordOptions[letter] ?? ""),
                                        selectedAnswer: $selectedAnswers[letter]
                                    )
                                }
                            }
                            .padding()
                        }
                        
                        Button("Submit") {
                            calculateScore()
                        }
                        .font(.title)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding()
                .navigationBarBackButtonHidden(true)
                
            }.toolbar(.hidden, for: .tabBar)
        }
    }
    
    func setupGame() {
        let allAlphabets = Array(wordOptions.keys).shuffled()
        selectedAlphabets = Array(allAlphabets.prefix(7))
    }
    
    func generateDistractors(excluding correctWord: String) -> [String] {
        var choices = distractors.shuffled().prefix(3).map { $0 }
        choices.append(correctWord)
        return choices.shuffled()
    }
    
    func calculateScore() {
        score = selectedAlphabets.reduce(0) { total, letter in
            let correctAnswer = wordOptions[letter]
            return total + (selectedAnswers[letter] == correctAnswer ? 1 : 0)
        }
        showScore = true
    }
    
    func restartGame() {
        selectedAnswers = [:]
        score = 0
        showScore = false
        setupGame()
    }
}

struct InstructionsssView: View {
    var startGame: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to the English Word Worksheet!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.black)
            
            Text("You will be given 7 random letters. Each question will have only **one correct answer** among the choices.")
                .font(.title3)
                .foregroundColor(.yellow)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: startGame) {
                Text("Start Learning!")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        
    }
}

struct QuestionsView: View {
    let letter: String
    let correctWord: String
    let distractors: [String]
    @Binding var selectedAnswer: String?
    
    var body: some View {
        VStack {
            Text("Which word starts with '\(letter)'?")
                .font(.title2)
                .bold()
                .foregroundColor(.black)
            
            ForEach(distractors, id: \.self) { option in
                Button(action: {
                    selectedAnswer = option
                }) {
                    Text(option)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedAnswer == option ? Color.green : Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.2)))
    }
}

struct ScoresView: View {
    let score: Int
    let total: Int
    var onRestart: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Your Score")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.black)
            
            Text("\(score) / \(total)")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(score > total / 2 ? .green : .red)
            
            Button("Play Again") {
                onRestart()
            }
            .font(.title)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        .padding()
        
    }
}

struct EnglishWordWorksheetView_Previews: PreviewProvider {
    static var previews: some View {
        EnglishWordWorksheetView()
    }
}
