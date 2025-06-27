//
//  NumberMatchViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 27/06/25.
//

import Foundation
import SwiftUI

class NumberMatchViewModel: ObservableObject {
    @Published var currentNumber: Int = 1
    @Published var options: [NumberMatchItem] = []
    @Published var showCorrect: Bool = false
    
    let allImages = ["apple", "star", "balloon", "car"] // Add these to Assets

    init() {
        generateNewRound()
    }

    func generateNewRound() {
        showCorrect = false
        currentNumber = Int.random(in: 1...5)
        
        var items: [NumberMatchItem] = []
        var usedCounts: Set<Int> = []

        while items.count < 4 {
            let count = Int.random(in: 1...5)
            guard !usedCounts.contains(count) else { continue }
            usedCounts.insert(count)
            
            let image = allImages.randomElement()!
            let item = NumberMatchItem(number: count, imageName: image)
            items.append(item)
        }
        
        options = items.shuffled()
    }

    func checkMatch(for item: NumberMatchItem) {
        if item.number == currentNumber {
            showCorrect = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.generateNewRound()
            }
        }
    }
}
