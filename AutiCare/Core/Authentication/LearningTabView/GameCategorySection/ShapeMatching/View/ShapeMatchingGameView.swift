//
//  ShapeMatchingGameView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 08/07/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ShapeMatchingGameView: View {
    @StateObject private var viewModel = ShapeMatchingViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        if viewModel.isGameComplete {
            GameResultView(
                score: viewModel.score,
                total: viewModel.targetShapes.count,
                onRestart: {
                    viewModel.generateShapes()
                },
                onQuit: {
                    dismiss()
                }
            )
            .onAppear {
                AudioManager.shared.speak("You scored \(viewModel.score) out of \(viewModel.targetShapes.count). Well done!")
            }
        } else {
            ZStack {
                PastelBlobBackgroundView()
                VStack(spacing: 30) {
                    Text("Match the Shapes")
                        .font(.title.bold())
                    Text("Score: \(viewModel.score)")
                        .font(.headline)
                    
                    // Target shapes grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 30) {
                        ForEach(viewModel.targetShapes) { target in
                            ZStack {
                                target.shapeType.strokedShape()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                                
                                if viewModel.matchedShapes.contains(target.id) {
                                    target.shapeType.filledShape(color: target.color)
                                        .frame(width: 80, height: 80)
                                }
                            }
                            .frame(width: 80, height: 80)
                            .background(Color.white.opacity(0.001))
                            .onDrop(of: [UTType.plainText], isTargeted: nil) { providers in
                                guard let provider = providers.first else { return false }
                                
                                _ = provider.loadObject(ofClass: NSString.self) { item, error in
                                    guard let shapeTypeRaw = item as? String,
                                          let draggedType = ShapeType(rawValue: shapeTypeRaw) else { return }
                                    
                                    DispatchQueue.main.async {
                                        if draggedType == target.shapeType {
                                            if let index = viewModel.draggableShapes.firstIndex(where: { $0.shapeType == draggedType }) {
                                                _ = viewModel.draggableShapes[index]
                                                viewModel.matchedShapes.append(target.id)
                                                viewModel.draggableShapes.remove(at: index)
                                                viewModel.score += 1
                                                let shapeName = draggedType.rawValue.capitalized
                                                AudioManager.shared.speak("Good job! You matched the \(shapeName).")
                                                
                                                viewModel.checkIfGameComplete()
                                            }
                                        } else {
                                            AudioManager.shared.speak("Try again.")
                                        }
                                    }
                                }
                                return true
                            }
                        }
                    }
                    
                    // Draggable shapes grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 30) {
                        ForEach(viewModel.draggableShapes) { shape in
                            shape.shapeType.filledShape(color: shape.color)
                                .frame(width: 80, height: 80)
                                .onDrag {
                                    return NSItemProvider(object: shape.shapeType.rawValue as NSString)
                                }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ShapeMatchingGameView()
}
