//
//  ColorMatchingDataModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 04/07/25.
//

import Foundation
import SwiftUI

struct ColorItem: Identifiable, Equatable {
    let id = UUID()
    let hex: String       // e.g., "#FF0000"
    let name: String      // e.g., "Red"
    
    var color: Color {
        Color(hex: hex)
    }
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255
        let b = Double(rgbValue & 0x0000FF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

struct GameLevel {
    let name: String
    let colorItems: [ColorItem]
    let numberOfOptions: Int
}

let basicLevel = GameLevel(
    name: "Basic",
    colorItems: [
        ColorItem(hex: "#FF9999", name: "Red"),        // Soft Red
        ColorItem(hex: "#9999FF", name: "Blue"),       // Soft Blue
        ColorItem(hex: "#99FF99", name: "Green"),      // Soft Green
        ColorItem(hex: "#FFFF99", name: "Yellow"),     // Soft Yellow
        ColorItem(hex: "#FFCC99", name: "Orange"),     // Soft Orange
        ColorItem(hex: "#D1B3FF", name: "Purple")      // Soft Purple
    ],
    numberOfOptions: 4
)

