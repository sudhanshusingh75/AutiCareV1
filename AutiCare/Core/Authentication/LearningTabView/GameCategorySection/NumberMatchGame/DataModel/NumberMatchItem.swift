//
//  NumberMatchItem.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 07/07/25.
//

import Foundation
struct NumberMatchItem: Identifiable {
    let id = UUID()
    let number: Int
    var isMatched: Bool = false
}
