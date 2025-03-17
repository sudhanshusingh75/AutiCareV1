//
//  ProgressViewModel.swift
//  Auticare
//
//  Created by sourav_singh on 20/02/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ProgressViewModel: ObservableObject {
    @Published var categories: [String] = [
        "Social Interaction", "Emotional Responsiveness", "Speech & Communication",
        "Behavior Patterns", "Sensory Aspects", "Cognitive Components"
    ]
    @Published var latestResult: AssessmentResult?
    @Published var allResults: [AssessmentResult] = []

    init() {
        fetchAssessmentResults()
    }

    func fetchAssessmentResults() {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("Users").document(userId).collection("assessmentResults")
            .order(by: "date", descending: true) // Fetch most recent first
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching assessment results: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self.allResults = documents.compactMap { document in
                    let data = document.data()

                    let timestamp = data["date"] as? Timestamp
                    let dateValue = timestamp?.dateValue() ?? Date()

                    let totalScore = data["totalAutismScore"] as? Int ?? 0
                    
                    let categoryDistributionsData = data["categoryDistributions"] as? [[String: Any]] ?? []
                    let categoryDistributions = categoryDistributionsData.compactMap { item -> [Double]? in
                        return item["distribution"] as? [Double]
                    }

                    return AssessmentResult(
                        id: document.documentID,
                        date: dateValue,
                        totalScore: totalScore,
                        severityLevels: categoryDistributions
                    )
                }

                // Set latest result if available
                self.latestResult = self.allResults.first
            }
    }
}

struct AssessmentResult: Identifiable {
    let id: String
    let date: Date
    let totalScore: Int
    let severityLevels: [[Double]] // Stacked bar chart data
}
