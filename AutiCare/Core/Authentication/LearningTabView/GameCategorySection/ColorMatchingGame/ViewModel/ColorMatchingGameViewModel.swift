//
//  ColorMatchingGameViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 04/07/25.
//

import Foundation
import SwiftUI
import AVFoundation

class ColorMatchingGameViewModel: ObservableObject {

    private let speechSynthesizer = AVSpeechSynthesizer()

    let level: GameLevel
    @Published var isGameOver = false
    @Published var feedbackMessage: String? = nil
    @Published var targetColor: ColorItem = ColorItem(hex: "#FFFFFF", name: "Default")
    @Published var options: [ColorItem] = []
    @Published var score: Int = 0
    @Published var questionCount: Int = 0
    @Published var isAnswerCorrect: Bool? = nil

    let totalQuestions = 10
    private var attemptedWrongAnswer = false

    // Track unused colors for unique questions
    private var unusedColorPool: [ColorItem] = []

    init(level: GameLevel) {
        self.level = level
        self.unusedColorPool = level.colorItems.shuffled()
        generateNewQuestion()
    }
    func generateNewQuestion() {
        isAnswerCorrect = nil
        questionCount += 1

        // Refill unused pool if empty
        if unusedColorPool.isEmpty {
            unusedColorPool = level.colorItems.shuffled()
        }

        // Pick target from unused pool
        targetColor = unusedColorPool.removeFirst()

        // Generate options including the correct one
        var optionsPool = level.colorItems.filter { $0 != targetColor }.shuffled()
        optionsPool = Array(optionsPool.prefix(level.numberOfOptions - 1))
        options = (optionsPool + [targetColor]).shuffled()

        AudioManager.shared.speak("Find the color \(targetColor.name)")
    }

    func selectColor(_ selected: ColorItem) {
        guard !isGameOver else { return }

        if selected == targetColor {
            isAnswerCorrect = true
            let message = ["Well Done", "Awesome", "Keep it up", "Correct"].shuffled().first!
            feedbackMessage = message
            AudioManager.shared.speak(message)

            if !attemptedWrongAnswer {
                score += 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.feedbackMessage = nil
                self.attemptedWrongAnswer = false

                if self.questionCount < self.totalQuestions {
                    self.generateNewQuestion()
                } else {
                    self.isGameOver = true
                }
            }

        } else {
            isAnswerCorrect = false
            attemptedWrongAnswer = true
            feedbackMessage = "Try again"
            AudioManager.shared.speak("Try again")

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                self.feedbackMessage = nil
            }
        }
    }

    func restartGame() {
        score = 0
        questionCount = 0
        isAnswerCorrect = nil
        isGameOver = false
        attemptedWrongAnswer = false
        unusedColorPool = level.colorItems.shuffled()
        generateNewQuestion()
    }
}
