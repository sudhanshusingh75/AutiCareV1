//
//  MemoryCard.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 07/07/25.
//

import Foundation

struct MemoryCard: Identifiable {
    let id = UUID()
    let imageName: String
    var isFlipped: Bool = false
    var isMatched: Bool = false
}

