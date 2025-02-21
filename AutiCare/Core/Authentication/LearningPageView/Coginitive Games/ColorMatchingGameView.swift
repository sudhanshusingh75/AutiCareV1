//
//  ColorMatchingGameView.swift
//  Auticare
//
//  Created by sourav_singh on 21/02/25.
//

import SwiftUI

struct ColorMatchingGameView: View {
    
    @State private var currentLevel = 1
    @State private var shapes: [ShapeModel] = []
    @State private var targets: [ShapeModel] = []
    @State private var score = 0
    @State private var showScoreboard = false
    @State private var showInstructions = true
    
    private let maxLevel = 3
    private let shapeColors: [Color] = [.red, .blue, .green]
    private let shapeTypes: [ShapeType] = [.circle, .square, .triangle]

    var body: some View {
        ZStack {
            
            LinearGradient(colors: [.blue.opacity(0.2), .purple.opacity(0.3)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                Text("Color Matching Game")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding()

                Text("Level \(currentLevel)")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Spacer()
                
                HStack {
                    ForEach(targets) { target in
                        TargetShapeView(shape: target)
                    }
                }
                .padding()

                
                HStack {
                    ForEach(shapes) { shape in
                        DraggableShapeView(shape: shape, onDrop: checkForMatch)
                    }
                }
                .padding()
                
                Spacer()

            }
        }
        .overlay(
            ScoreboardView(isPresented: $showScoreboard, score: score, onRetry: resetGame)
        )
        .overlay(
            InstructionssssView(isPresented: $showInstructions, onDismiss: { showInstructions = false })
        )
        .onAppear {
            startLevel()
        }
    }

    func startLevel() {
        shapes.removeAll()
        targets.removeAll()

        for index in 0..<currentLevel {
            let color = shapeColors[index]
            let type = shapeTypes[index]
            
            let shape = ShapeModel(id: UUID(), type: type, color: color)
            let target = ShapeModel(id: UUID(), type: type, color: color)
            
            shapes.append(shape)
            targets.append(target)
        }
    }

    func checkForMatch(shape: ShapeModel) {
        if let target = targets.first(where: { $0.color == shape.color && $0.type == shape.type }) {
            score += 10
            shapes.removeAll { $0.id == shape.id }
            targets.removeAll { $0.id == target.id }
            
            if shapes.isEmpty {
                nextLevel()
            }
        }
    }

    func nextLevel() {
        if currentLevel < maxLevel {
            currentLevel += 1
            startLevel()
        } else {
            showScoreboard = true
        }
    }

    func resetGame() {
        currentLevel = 1
        score = 0
        startLevel()
    }
}

struct DraggableShapeView: View {
    let shape: ShapeModel
    var onDrop: (ShapeModel) -> Void
    @State private var offset = CGSize.zero
    
    var body: some View {
        shapeView()
            .fill(shape.color)
            .frame(width: 80, height: 80)
            .overlay(shapeView().stroke(Color.white, lineWidth: 3))
            .shadow(radius: 5)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { _ in
                        onDrop(shape)
                        offset = .zero
                    }
            )
            .animation(.spring(), value: offset)
    }
    
    private func shapeView() -> AnyShape {
        switch shape.type {
        case .circle:
            return AnyShape(Circle())
        case .square:
            return AnyShape(Rectangle())
        case .triangle:
            return AnyShape(TriangleShape())
        }
    }
}

struct TargetShapeView: View {
    let shape: ShapeModel
    
    var body: some View {
        shapeView()
            .stroke(shape.color, lineWidth: 4)
            .frame(width: 80, height: 80)
            .overlay(shapeView().fill(Color.clear))
            .shadow(radius: 3)
    }

    private func shapeView() -> AnyShape {
        switch shape.type {
        case .circle:
            return AnyShape(Circle())
        case .square:
            return AnyShape(Rectangle())
        case .triangle:
            return AnyShape(TriangleShape())
        }
    }
}

struct ScoreboardView: View {
    @Binding var isPresented: Bool
    let score: Int
    var onRetry: () -> Void
    
    var body: some View {
        if isPresented {
            VStack {
                Text("Game Over!")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Text("Your Score: \(score)")
                    .font(.title)
                    .foregroundColor(.yellow)
                    .padding()
                
                HStack {
                    Button("Retry") {
                        isPresented = false
                        onRetry()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()

                    Button("Exit") {
                        isPresented = false
                    }
                    .buttonStyle(.bordered)
                    .padding()
                }
            }
            .frame(width: 300, height: 250)
            .background(Color.black.opacity(0.8))
            .cornerRadius(20)
            .shadow(radius: 10)
            .transition(.scale)
        }
    }
}

// MARK: - Instructions View
struct InstructionssssView: View {
    @Binding var isPresented: Bool
    var onDismiss: () -> Void
    
    var body: some View {
        if isPresented {
            VStack {
                Text("How to Play")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Text("Drag the shape to the matching outline.")
                    .font(.title2)
                    .foregroundColor(.yellow)
                    .padding()

                Button("Start Game") {
                    onDismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .frame(width: 320, height: 250)
            .background(Color.black.opacity(0.85))
            .cornerRadius(20)
            .shadow(radius: 10)
            .transition(.opacity)
        }
    }
}

// MARK: - Shape Model & Types
struct ShapeModel: Identifiable {
    let id: UUID
    let type: ShapeType
    let color: Color
}

enum ShapeType {
    case circle, square, triangle
}

// MARK: - Triangle Shape
struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLines([
            CGPoint(x: rect.maxX, y: rect.maxY),
            CGPoint(x: rect.minX, y: rect.maxY),
            CGPoint(x: rect.midX, y: rect.minY)
        ])
        return path
    }
}

// MARK: - Shape Wrapper
struct AnyShape: Shape {
    private let path: (CGRect) -> Path

    init<S: Shape>(_ wrapped: S) {
        path = { wrapped.path(in: $0) }
    }

    func path(in rect: CGRect) -> Path {
        path(rect)
    }
}

#Preview {
    ColorMatchingGameView()
}

