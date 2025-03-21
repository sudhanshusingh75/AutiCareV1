//
//  ISpyGameView.swift
//  Auticare
//
//  Created by sourav_singh on 21/02/25.
//


import SwiftUI

struct ISpyGameView: View {
    @State private var showRules = true
    @State private var score = 0
    @State private var currentItemIndex = 0
    @State private var gameFinished = false
    
    let items = [
        (name: "Red Ball", image: "redBall"),
        (name: "Blue Car", image: "blueCar"),
        (name: "Green Apple", image: "greenApple"),
        (name: "Yellow Sun", image: "yellowSun")
    ]
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                if showRules {
                    RulesView(showRules: $showRules)
                } else if gameFinished {
                    ScoreView(score: score, restartGame: restartGame)
                } else {
                    GameView(score: $score, currentItemIndex: $currentItemIndex, items: items, finishGame: finishGame)
                }
            }
            .padding()
        }.toolbar(.hidden, for: .tabBar)
    }
    
    private func restartGame() {
        score = 0
        currentItemIndex = 0
        gameFinished = false
        showRules = true
    }
    
    private func finishGame() {
        gameFinished = true
    }
}

struct RulesView: View {
    @Binding var showRules: Bool
    
    var body: some View {
        VStack {
            Text("Game Instructions")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.black)
                .padding()
            Text("1. Look at the description given.\n2. Tap on the correct object from the choices.\n3. Each correct answer gives you points.\n4. Try to get the highest score!")
                .multilineTextAlignment(.center)
                .foregroundColor(.yellow)
                .padding()
            Button("Start Game") {
                showRules = false
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        
        .padding()
    }
}

struct GameView: View {
    @Binding var score: Int
    @Binding var currentItemIndex: Int
    let items: [(name: String, image: String)]
    let finishGame: () -> Void
    
    var body: some View {
        VStack {
            Text("Find: \(items[currentItemIndex].name)")
                .font(.title)
                .bold()
                .foregroundColor(.purple)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                ForEach(items.indices, id: \.self) { index in
                    Button(action: {
                        if index == currentItemIndex {
                            score += 1
                        }
                        nextItem()
                    }) {
                        Image(items[index].image)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .border(Color.blue, width: 3)
                    }
                }
            }
            .padding()
        }
    }
    
    private func nextItem() {
        if currentItemIndex < items.count - 1 {
            currentItemIndex += 1
        } else {
            finishGame()
        }
    }
}

struct ScoreView: View {
    let score: Int
    let restartGame: () -> Void
    
    var body: some View {
        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.red)
            Text("Your Score: \(score)")
                .font(.title)
                .foregroundColor(.green)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            Button("Play Again") {
                restartGame()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
       
        .padding()
    }
}

struct ISpyGameView_Previews: PreviewProvider {
    static var previews: some View {
        ISpyGameView()
    }
}


#Preview {
    ISpyGameView()
}
