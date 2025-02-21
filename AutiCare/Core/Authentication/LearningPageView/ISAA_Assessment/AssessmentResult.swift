//
//  AssessmentResult.swift
//  Auticare
//
//  Created by sourav_singh on 20/02/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct AssessmentResult: Identifiable, Codable {
    @DocumentID var id: String?
    var totalScore: Int
    var autismLevel: String
    var scoreBreakdown: [Int]
    @ServerTimestamp var date: Timestamp?
}
