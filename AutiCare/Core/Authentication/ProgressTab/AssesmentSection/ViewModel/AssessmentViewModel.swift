//
//  AssessmentViewModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 26/06/25.
//

//  AssessmentViewModel.swift
//  Auticare

import Foundation
import SwiftUI

enum QuestionCategory: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case social = "Social Relationship & Responsiveness"
    case emotional = "Emotional Responsiveness"
    case speech = "Speech & Communication"
    case behaviour = "Behavior Patterns"
    case sensory = "Sensory Aspects"
    case cognitive = "Cognitive Components"
}

struct Question: Identifiable {
    let id = UUID()
    let text: String
    var selectedAnswer: Int = 0 // 0 means unanswered
}

struct CategoryWiseQuestion: Identifiable {
    var id: String { category.rawValue }
    let category: QuestionCategory
    var questions: [Question]
}

@MainActor
class AssessmentViewModel: ObservableObject {
    @Published var categories: [CategoryWiseQuestion] = []
    @Published var currentCategoryIndex: Int = 0

    var currentCategory: CategoryWiseQuestion {
        categories[currentCategoryIndex]
    }
    var isLastCategory: Bool {
        currentCategoryIndex == categories.count - 1
    }
    var totalCategories: Int {
        categories.count
    }

    func questionsForCurrentCategory() -> [Question] {
        categories[currentCategoryIndex].questions
    }

    func labelForScore(questionID: UUID) -> String {
        let score = getSelectedScore(for: questionID)
        switch score {
        case 1: return "Rarely"
        case 2: return "Sometimes"
        case 3: return "Frequently"
        case 4: return "Mostly"
        case 5: return "Always"
        default: return "Select an option"
        }
    }

    func getSelectedScore(for questionID: UUID) -> Int {
        for category in categories {
            if let question = category.questions.first(where: { $0.id == questionID }) {
                return question.selectedAnswer
            }
        }
        return 0
    }

    func selectOption(questionID: UUID, score: Int) {
        for categoryIndex in categories.indices {
            for questionIndex in categories[categoryIndex].questions.indices {
                if categories[categoryIndex].questions[questionIndex].id == questionID {
                    categories[categoryIndex].questions[questionIndex].selectedAnswer = score
                }
            }
        }
    }

    func goToNextCategory() {
        if currentCategoryIndex < categories.count - 1 {
            currentCategoryIndex += 1
        }
    }

    func allQuestionsAnsweredInCurrentCategory() -> Bool {
        !categories[currentCategoryIndex].questions.contains(where: { $0.selectedAnswer == 0 })
    }

    init() {
        loadQuestions()
    }

    private func loadQuestions() {
        categories = [
            CategoryWiseQuestion(category: .social, questions: [
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

            CategoryWiseQuestion(category: .emotional, questions: [
                Question(text: "Does your child show emotions that don’t match the situation?"),
                Question(text: "Does your child not seem afraid in dangerous situations?"),
                Question(text: "Does your child show strong emotions for no clear reason?"),
                Question(text: "Does your child repeat emotional behaviors over and over?"),
                Question(text: "Does your child get very excited or upset suddenly?")
            ]),

            CategoryWiseQuestion(category: .speech, questions: [
                Question(text: "Did your child learn to speak but then lose that ability?"),
                Question(text: "Does your child repeat what others say (echoes words)?"),
                Question(text: "Does your child use language in a repetitive or unusual way?"),
                Question(text: "Does your child make strange or baby-like sounds often?"),
                Question(text: "Does your child find it hard to start or continue a conversation?"),
                Question(text: "Does your child use made-up or meaningless words?"),
                Question(text: "Does your child mix up ‘I’ and ‘you’ (pronoun confusion)?"),
                Question(text: "Does your child struggle to understand what others really mean when they talk?")
            ]),

            CategoryWiseQuestion(category: .behaviour, questions: [
                Question(text: "Does your child repeat body movements or actions (like hand flapping)?"),
                Question(text: "Is your child very attached to objects (like a toy or item)?"),
                Question(text: "Is your child often overly active or restless?"),
                Question(text: "Does your child sometimes act aggressively?"),
                Question(text: "Does your child have frequent temper tantrums?"),
                Question(text: "Does your child harm themselves (like head banging or biting)?"),
                Question(text: "Does your child dislike changes and want things to stay the same?")
            ]),

            CategoryWiseQuestion(category: .sensory, questions: [
                Question(text: "Is your child overly sensitive to sound, touch, light, or other senses?"),
                Question(text: "Does your child stare into space for long times?"),
                Question(text: "Does your child have trouble following moving objects?"),
                Question(text: "Does your child look at things in unusual ways?"),
                Question(text: "Does your child not react to pain like other children?"),
                Question(text: "Does your child often smell, touch, or taste things or people in odd ways?")
            ]),

            CategoryWiseQuestion(category: .cognitive, questions: [
                Question(text: "Does your child find it hard to focus or pay attention?"),
                Question(text: "Does your child take a long time to respond when spoken to?"),
                Question(text: "Does your child have a very strong memory for specific things?"),
                Question(text: "Does your child show special talents or unusual skills in certain areas?")
            ])
        ]
    }
}
