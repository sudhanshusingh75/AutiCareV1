import Foundation
import FirebaseFirestore
import FirebaseAuth

struct NormalizedCategoryScore: Identifiable {
    let id = UUID()
    let category: String
    let score: Int // Normalized 0-100
}
class AssessmentViewModel: ObservableObject {
    let currentUserID = Auth.auth().currentUser?.uid ?? ""

    @Published var question:[CategoryWiseQuestion] = [
        CategoryWiseQuestion(questionCategory: .social, questions:[
            Question(text: "Does your child avoid making eye contact?"),
            Question(text: "Does your child rarely smile at others?"),
            Question(text: "Does your child prefer to stay alone?"),
            Question(text: "Does your child not try to reach out or connect with people?"),
            Question(text: "Does your child find it hard to relate to others?"),
            Question(text: "Does your child struggle to respond to social cues (like gestures or tone)?"),
            Question(text: "Does your child mostly play alone and repeat the same activities?"),
            Question(text: "Does your child have trouble taking turns while interacting?"),
            Question(text: "Does your child have difficulty making or keeping friends?")
        ]),
        CategoryWiseQuestion(questionCategory: .emotional, questions:[
            Question(text: "Does your child show emotions that don’t match the situation?"),
            Question(text: "Does your child not seem afraid in dangerous situations?"),
            Question(text: "Does your child show strong emotions for no clear reason?"),
            Question(text: "Does your child repeat emotional behaviors over and over?"),
            Question(text: "Does your child get very excited or upset suddenly?")
        ]),
        CategoryWiseQuestion(questionCategory: .communication, questions: [
            Question(text: "Did your child learn to speak but then lose that ability?"),
            Question(text: "Does your child repeat what others say (echoes words)?"),
            Question(text: "Does your child use language in a repetitive or unusual way?"),
            Question(text: "Does your child make strange or baby-like sounds often?"),
            Question(text: "Does your child find it hard to start or continue a conversation?"),
            Question(text: "Does your child use made-up or meaningless words?"),
            Question(text: "Does your child mix up ‘I’ and ‘you’ (pronoun confusion)?"),
            Question(text: "Does your child struggle to understand what others really mean when they talk?")
        ]),
        CategoryWiseQuestion(questionCategory: .behaviour, questions: [
            Question(text: "Does your child repeat body movements or actions (like hand flapping)?"),
            Question(text: "Is your child very attached to objects (like a toy or item)?"),
            Question(text: "Is your child often overly active or restless?"),
            Question(text: "Does your child sometimes act aggressively?"),
            Question(text: "Does your child have frequent temper tantrums?"),
            Question(text: "Does your child harm themselves (like head banging or biting)?"),
            Question(text: "Does your child dislike changes and want things to stay the same?")
        ]),
        CategoryWiseQuestion(questionCategory: .sensory, questions: [
            Question(text: "Is your child overly sensitive to sound, touch, light, or other senses?"),
            Question(text: "Does your child stare into space for long times?"),
            Question(text: "Does your child have trouble following moving objects?"),
            Question(text: "Does your child look at things in unusual ways?"),
            Question(text: "Does your child not react to pain like other children?"),
            Question(text: "Does your child often smell, touch, or taste things or people in odd ways?")
        ]),
        CategoryWiseQuestion(questionCategory: .cognitive, questions: [
            Question(text: "Does your child find it hard to focus or pay attention?"),
            Question(text: "Does your child take a long time to respond when spoken to?"),
            Question(text: "Does your child have a very strong memory for specific things?"),
            Question(text: "Does your child show special talents or unusual skills in certain areas?")
        ])
    ]

    @Published var fetchedScore: Int = 0
    @Published var categoryScores: [CategoryScore] = []
    @Published var isLoading = true
    @Published var errorMessage: String? = nil

    func isAssessmentComplete() -> Bool {
        for categoryGroup in question {
            for question in categoryGroup.questions {
                if question.selectedOption == nil {
                    return false
                }
            }
        }
        return true
    }

    func totalScore() -> Int {
        var total = 0
        for categoryGroup in question {
            for question in categoryGroup.questions {
                if let selectedOption = question.selectedOption {
                    total += selectedOption.Score
                }
            }
        }
        return total
    }

    func scoreByCategory() -> [QuestionCategory: Int] {
        var scores: [QuestionCategory: Int] = [:]
        for categoryGroup in question {
            let category = categoryGroup.questionCategory
            let categoryScore = categoryGroup.questions.reduce(0) { sum, q in
                sum + (q.selectedOption?.Score ?? 0)
            }
            scores[category] = categoryScore
        }
        return scores
    }

    func normalizedCategoryScores() -> [NormalizedCategoryScore] {
        let maxScores: [String: Int] = [
            "Social Skills": 45,
            "Emotional Response": 25,
            "Communication": 40,
            "Behaviour": 35,
            "Sensory": 30,
            "Thinking Skills": 20
        ]

        return categoryScores.map { raw in
            let maxScore = maxScores[raw.category] ?? 100
            let percentage = Int((Double(raw.score) / Double(maxScore)) * 100)
            return NormalizedCategoryScore(category: raw.category, score: percentage)
        }
    }

    var normalizedTotalPercentage: Int {
        let maxTotal = 195.0
        return Int((Double(fetchedScore) / maxTotal) * 100)
    }

    func fetchResults(childId: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "User not logged in."
            isLoading = false
            return
        }

        Firestore.firestore().collection("Users")
            .document(userId)
            .collection("Assessment")
            .whereField("childId", isEqualTo: childId)
            .order(by: "timestamp", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to load data: \(error.localizedDescription)"
                    self.isLoading = false
                    return
                }

                guard let document = snapshot?.documents.first else {
                    self.errorMessage = "No assessment data found."
                    self.isLoading = false
                    return
                }

                let data = document.data()
                self.fetchedScore = data["totalScore"] as? Int ?? 0
                if let categoryDict = data["categoryScores"] as? [String: Int] {
                    self.categoryScores = categoryDict.map { key, value in
                        CategoryScore(category: key, score: value)
                    }
                }
                self.isLoading = false
            }
    }

    func submitAssessment(for child: ChildDetails) {
        if !isAssessmentComplete() {
            print("Please answer all questions before submitting.")
            return
        }

        let total = totalScore()
        let categoryScores = scoreByCategory()
        var formattedCategoryScores: [String: Int] = [:]

        for (category, score) in categoryScores {
            formattedCategoryScores[category.rawValue] = score
        }

        var answers: [[String: Any]] = []

        for categoryGroup in question {
            for question in categoryGroup.questions {
                var answer: [String: Any] = [:]
                answer["id"] = question.id.uuidString
                answer["text"] = question.text
                answer["category"] = categoryGroup.questionCategory.rawValue
                answer["selectedOption"] = question.selectedOption?.rawValue ?? ""
                answers.append(answer)
            }
        }

        let result: [String: Any] = [
            "childId": child.id,
            "childName": child.fullName,
            "childDob": child.dateOfBirth,
            "childGender": child.gender,
            "timestamp": Timestamp(date: Date()),
            "totalScore": total,
            "categoryScores": formattedCategoryScores,
            "answers": answers
        ]

        print("Uploading result: \(result)")

        Firestore.firestore().collection("Users")
            .document(currentUserID)
            .collection("Assessment")
            .addDocument(data: result) { error in
                if let error = error {
                    print("❌ Failed to submit assessment: \(error.localizedDescription)")
                } else {
                    print("✅ Assessment submitted successfully!")
                }
            }
    }
}
