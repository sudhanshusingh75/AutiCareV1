//
//  PictureRepresentingActionGameView.swift
//  Auticare
//
//  Created by sourav_singh on 20/02/25.
//

import SwiftUI

struct PictureRepresentingActionGameView: View {
    struct Question {
        let text: String
        let option1: String
        let option2: String
        let correctOption: Int
    }
    
    @State private var questions: [Question] = [
        Question(text: "Who is flying?", option1: "notfly0", option2: "fly0", correctOption: 2),
        Question(text: "Who is flying?", option1: "fly1", option2: "notFly1", correctOption: 1),
        Question(text: "Who is flying?", option1: "fly2", option2: "notFly2", correctOption: 1),
        Question(text: "Who is flying?", option1: "notFly3", option2: "fly3", correctOption: 2),
        Question(text: "Who is flying?", option1: "fly4", option2: "notFly4", correctOption: 1)
    ]
    
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var showDisclaimer = true
    @State private var showGameOver = false
    
    var body: some View {
        ZStack {
            
            
            if showDisclaimer {
                DisclaimerView(startGame: { showDisclaimer = false })
            } else if showGameOver {
                GameOverView(score: score, restartGame: restartGame)
            } else {
                gameView
            }
        }.toolbar(.hidden, for: .tabBar)
    }
    
    var gameView: some View {
        VStack {
            Text("Score: \(score)")
                .font(.title2)
                .bold()
                .foregroundColor(.green)
                .padding()
            
            
            
            let question = questions[currentQuestionIndex]
            
            Text(question.text)
                .font(.title)
                .bold()
                .foregroundColor(.black)
                .padding()
                .multilineTextAlignment(.center)
            
            HStack(spacing: 40) {
                imageButton(imageName: question.option1, isCorrect: question.correctOption == 1)
                imageButton(imageName: question.option2, isCorrect: question.correctOption == 2)
            }
            .padding()
        }
    }
    
    func imageButton(imageName: String, isCorrect: Bool) -> some View {
        Button(action: {
            checkAnswer(isCorrect: isCorrect)
        }) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 170)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 5))
        }
    }
    
    func checkAnswer(isCorrect: Bool) {
        if isCorrect {
            score += 1
        }
        
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            showGameOver = true
        }
    }
    
    func restartGame() {
        score = 0
        currentQuestionIndex = 0
        showGameOver = false
    }
}

struct DisclaimerView: View {
    var startGame: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Game Instructions")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.black)
            Text("Identify which image contains an object that should fly.")
                .foregroundColor(.yellow)
                .multilineTextAlignment(.center)
                .padding()
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
        
        
    }
}

struct GameOverView: View {
    var score: Int
    var restartGame: () -> Void
    var questions: Int = 5
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Game Over")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.black)
            
            Text("Final Score: \(score)/\(questions)")
                .font(.title2)
                .foregroundColor(.green)
            
            Button(action: restartGame) {
                Text("Play Again")
                    .font(.title2)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        
    }
}

struct PictureRepresentingActionGameView_Previews: PreviewProvider {
    static var previews: some View {
        PictureRepresentingActionGameView()
    }
}


#Preview {
    PictureRepresentingActionGameView()
}
