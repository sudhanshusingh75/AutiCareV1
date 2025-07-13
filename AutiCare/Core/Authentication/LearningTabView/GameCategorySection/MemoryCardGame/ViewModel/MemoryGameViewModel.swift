//
//  MemoryGameViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 07/07/25.
//

import Foundation
import SwiftUI
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ message: String) {
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
}


class MemoryGameViewModel: ObservableObject {
    @Published var score: Int = 0  // matched pairs
    @Published var totalAttempts: Int = 0
    @Published var cards: [MemoryCard] = []
    @Published var isGameCompleted: Bool = false {
        didSet {
            if isGameCompleted {
                onGameCompleted?()
            }
        }
    }
    var onGameCompleted: (() -> Void)? = nil
    private var selectedIndices: [Int] = []
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        let images = ["star", "circle", "heart", "moon", "bolt", "leaf", "sun.max", "cloud"]
        let deck = (images + images).shuffled() // create 2 of each
        cards = deck.map { MemoryCard(imageName: $0) }
        selectedIndices = []
        isGameCompleted = false
    }
    
    func flipCard(_ card: MemoryCard) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }),
              !cards[index].isFlipped,
              !cards[index].isMatched,
              selectedIndices.count < 2 else { return }
        
        cards[index].isFlipped = true
        selectedIndices.append(index)
        
        if selectedIndices.count == 2 {
            checkForMatch()
        }
    }
    
    private func checkForMatch() {
        let first = selectedIndices[0]
        let second = selectedIndices[1]
        
        totalAttempts += 1
        
        if cards[first].imageName == cards[second].imageName {
            cards[first].isMatched = true
            cards[second].isMatched = true
            score += 1
            AudioManager.shared.speak("Nice match!")
        } else {
            AudioManager.shared.speak("Try again!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.cards[first].isFlipped = false
                self.cards[second].isFlipped = false
            }
        }

        selectedIndices = []

        if cards.allSatisfy({ $0.isMatched }) {
            isGameCompleted = true
            AudioManager.shared.speak("You completed the game!")
        }
    }


}
