//
//  AssessmentResult.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 26/06/25.
//

import Foundation
struct AssessmentResult: Identifiable {
    let id: UUID
    let name: String
    let score: Int
    let dateTaken: Date
    let imageURL: String?
    let categoryScores: [CategoryPerformance]
}

struct CategoryPerformance: Identifiable {
    let id = UUID()
    let name: String
    let score: Int
    let trend: Double
    let weeklyData: [Double]
}
