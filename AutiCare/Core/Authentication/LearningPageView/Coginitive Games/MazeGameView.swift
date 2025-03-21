//
//  MazeGameView.swift
//  Auticare
//
//  Created by sourav_singh on 21/02/25.
//

import SwiftUI

struct MazeGameView: View {
    @State private var playerPosition = (x: 0, y: 0)
    @State private var gameStarted = false
    @State private var timer: Timer?
    @State private var elapsedTime = 0
    @State private var showWinMessage = false
    
    let maze: [[Int]] = [
        [0, 1, 0, 0, 0, 0],
        [0, 1, 0, 1, 1, 0],
        [0, 0, 0, 1, 0, 0],
        [1, 1, 0, 1, 0, 1],
        [0, 0, 0, 0, 0, 0],
        [0, 1, 1, 1, 1, 2]
    ]
    
    var body: some View {
        VStack {
            if gameStarted {
                
                HStack {
                    Text("Time: \(elapsedTime) sec")
                        .font(.title2)
                        .bold()
                        .padding()
                    Spacer()
                }
                
                Text("Maze Puzzle Game")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                GridView(maze: maze, playerPosition: playerPosition)
                
                // Control buttons
                VStack {
                    HStack {
                        ControlButton(label: "⬆️", action: { movePlayer(dx: 0, dy: -1) })
                    }
                    HStack {
                        ControlButton(label: "⬅️", action: { movePlayer(dx: -1, dy: 0) })
                        ControlButton(label: "➡️", action: { movePlayer(dx: 1, dy: 0) })
                    }
                    HStack {
                        ControlButton(label: "⬇️", action: { movePlayer(dx: 0, dy: 1) })
                    }
                }
                .padding()
                
            } else {
                
                InstructionView(startGame: startGame)
            }
        }.toolbar(.hidden, for: .tabBar)
        .padding()
        .alert("🎉 You Won! 🎉", isPresented: $showWinMessage) {
            Button("Play Again", action: resetGame)
        } message: {
            Text("You completed the maze in \(elapsedTime) seconds!")
        }
    }
    
    func movePlayer(dx: Int, dy: Int) {
        let newX = playerPosition.x + dx
        let newY = playerPosition.y + dy
        
        if newX >= 0, newX < maze[0].count, newY >= 0, newY < maze.count, maze[newY][newX] != 1 {
            playerPosition = (newX, newY)
            
            if maze[newY][newX] == 2 { // Exit reached
                timer?.invalidate()
                showWinMessage = true
            }
        }
    }

    func startGame() {
        gameStarted = true
        elapsedTime = 0
        showWinMessage = false
        playerPosition = (x: 0, y: 0)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime += 1
        }
    }
    
    func resetGame() {
        gameStarted = false
    }
}

// MARK: - Instructions View

struct InstructionView: View {
    var startGame: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Game Instructions")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("➡️ Use the arrow buttons to move through the maze.")
                Text("🧱 Avoid hitting the walls (grey blocks).")
                Text("🎯 Reach the green block to win!")
                Text("⏳ Timer starts when you begin the game.")
            }
            .font(.title2)
            .foregroundColor(.yellow)
            .padding()
            
            
            Button(action: startGame) {
                Text("Start Game")
                    .font(.title)
                    .padding()
                    .frame(width: 200)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct GridView: View {
    let maze: [[Int]]
    let playerPosition: (x: Int, y: Int)
    
    var body: some View {
        VStack(spacing: 5) {
            ForEach(0..<maze.count, id: \.self) { row in
                HStack(spacing: 5) {
                    ForEach(0..<maze[row].count, id: \.self) { col in
                        CellView(value: maze[row][col], isPlayer: (row == playerPosition.y && col == playerPosition.x))
                    }
                }
            }
        }
    }
}

struct CellView: View {
    let value: Int
    let isPlayer: Bool
    
    var body: some View {
        Rectangle()
            .fill(isPlayer ? Color.blue : (value == 1 ? Color.gray : (value == 2 ? Color.green : Color.mint)))
            .frame(width: 40, height: 40)
            .cornerRadius(5)
            .overlay(isPlayer ? Text("👦").font(.title) : nil)
    }
}

struct ControlButton: View {
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.largeTitle)
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

struct MazeGameView_Previews: PreviewProvider {
    static var previews: some View {
        MazeGameView()
    }
}


#Preview {
    MazeGameView()
}
