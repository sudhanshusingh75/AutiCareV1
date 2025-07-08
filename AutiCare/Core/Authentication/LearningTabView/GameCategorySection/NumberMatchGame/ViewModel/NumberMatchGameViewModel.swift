import Foundation
import SwiftUI

class NumberMatchGameViewModel: ObservableObject {
    @Published var numbers: [NumberMatchItem] = []
    @Published var dots: [NumberMatchItem] = []
    @Published var score: Int = 0
    @Published var totalAttempts: Int = 0
    @Published var isGameCompleted = false
    @Published var isBusy: Bool = false

    var onGameCompleted: (() -> Void)?

    init() {
        startGame()
    }

    func startGame() {
        let range = (1...6).shuffled().prefix(4)
        let items = range.map { NumberMatchItem(number: $0) }
        numbers = items.shuffled()
        dots = items.shuffled()
        score = 0
        totalAttempts = 0
        isGameCompleted = false
        isBusy = false
    }

    func checkMatch(number: NumberMatchItem, dot: NumberMatchItem) {
        guard !isBusy else { return }
        isBusy = true

        totalAttempts += 1

        if number.number == dot.number {
            AudioManager.shared.speak("Good job!")
            markAsMatched(number: number.number)
            score += 1
        } else {
            AudioManager.shared.speak("Try again.")
        }

        if numbers.allSatisfy({ $0.isMatched }) {
            isGameCompleted = true
            onGameCompleted?()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isBusy = false
        }
    }

    private func markAsMatched(number: Int) {
        for i in numbers.indices where numbers[i].number == number {
            numbers[i].isMatched = true
        }
        for i in dots.indices where dots[i].number == number {
            dots[i].isMatched = true
        }
    }
}
