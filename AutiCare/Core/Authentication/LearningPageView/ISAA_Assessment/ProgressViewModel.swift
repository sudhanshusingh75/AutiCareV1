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
    @Published var latestResult: AssessmentResult?
    @Published var allResults: [AssessmentResult] = []

    init() {
        fetchAssessmentResults()
    }

    func fetchAssessmentResults() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("❌ User not authenticated")
            return
        }

        let db = Firestore.firestore()
        db.collection("Users").document(userId).collection("assessmentResults")
            .order(by: "date", descending: false) 
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching results: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("⚠️ No results found")
                    return
                }

                DispatchQueue.main.async {
                    self.allResults = documents.compactMap { doc -> AssessmentResult? in
                        let data = doc.data()
                        let totalScore = data["totalScore"] as? Int ?? 0
                        let autismLevel = data["autismLevel"] as? String ?? "Unknown"
                        let scoreBreakdown = data["scoreBreakdown"] as? [Int] ?? []
                        let date = data["date"] as? Timestamp ?? Timestamp()

                        return AssessmentResult(totalScore: totalScore, autismLevel: autismLevel, scoreBreakdown: scoreBreakdown, date: date)
                    }

                    if let firstResult = self.allResults.last {
                        self.latestResult = firstResult
                    }
                    
                    print("✅ Total results fetched: \(self.allResults.count)")
                }
            }
    }
}
