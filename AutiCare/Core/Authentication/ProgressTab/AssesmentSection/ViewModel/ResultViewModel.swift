//
//  ResultViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 08/07/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ResultViewModel: ObservableObject {
    @Published var results: [AssessmentResult] = []
    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser?.uid ?? ""

    func fetchResults() {
        db.collection("Users")
            .document(userId)
            .collection("Assessment")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching results: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("⚠️ No assessment documents found.")
                    return
                }

                self.results = documents.compactMap { doc in
                    let data = doc.data()

                    guard
                        let childId = data["childId"] as? String,
                        let name = data["childName"] as? String,
                        let gender = data["childGender"] as? String,
                        let dob = data["childDob"] as? Timestamp,
                        let totalScore = data["totalScore"] as? Int,
                        let timestamp = data["timestamp"] as? Timestamp,
                        let categoryDict = data["categoryScores"] as? [String: Int]
                    else {
                        print("⚠️ Skipping invalid document: \(doc.documentID)")
                        return nil
                    }

                    let categoryScores = categoryDict.map {
                        CategoryPerformance(name: $0.key, score: $0.value, trend: 0, weeklyData: [])
                    }

                    return AssessmentResult(
                        id: UUID(),
                        childId: childId,
                        name: name,
                        dateOfBirth: dob.dateValue(),
                        gender: gender,
                        score: totalScore,
                        dateTaken: timestamp.dateValue(),
                        categoryScores: categoryScores
                    )
                }
            }
    }
}

