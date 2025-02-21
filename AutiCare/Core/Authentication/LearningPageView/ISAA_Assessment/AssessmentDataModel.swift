//
//  AssessmentDataModel.swift
//  Auticare
//
//  Created by sourav_singh on 20/02/25.
//

import Foundation

enum QuestionCategory: String, CaseIterable {
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
    var selectedAnswer: Int = 1
}

struct CategoryWiseQuestion {
    let category: QuestionCategory
    var questions: [Question]
}

let allQuestions: [CategoryWiseQuestion] = [
    CategoryWiseQuestion(category: .social, questions: [
        Question(text: "Your child has poor eye contact"),
        Question(text: "Your child lacks social smile"),
        Question(text: "Your child remains aloof"),
        Question(text: "Your child does not reach out to others"),
        Question(text: "Your child unable to relate to people"),
        Question(text: "Your child is unable to respond to social/environmental cues"),
        Question(text: "Your child engages in solitary and repetitive play activities"),
        Question(text: "Your child is unable to take turns in social interaction"),
        Question(text: "Your child does not maintain peer relationships")
    ]),
    CategoryWiseQuestion(category: .emotional, questions: [
        Question(text: "Your child shows inappropriate emotional response"),
        Question(text: "Your child lacks fear of danger"),
        Question(text: "Your child engages in self-stimulating emotions"),
        Question(text: "Your child lacks fear of danger"),
        Question(text: "Your child gets excited or agitated for no apparent reason")
    ]),
    CategoryWiseQuestion(category: .speech, questions: [
        Question(text: "Your child acquired speech and lost it"),
        Question(text: "Your child engages in echolalic speech"),
        Question(text: "Your child engages in stereotyped and repetitive use of language"),
        Question(text: "Your child engages in echolalic speech"),
        Question(text: "Your child produces infantile squeals/unusual noises"),
        Question(text: "Your child is unable to initiate or sustain conversation with others"),
        Question(text: "Your child uses jargon or meaningless words"),
        Question(text: "Your child uses pronoun reversals"),
        Question(text: "Your child is unable to grasp pragmatics of communication (real meaning)")
    ]),
    CategoryWiseQuestion(category: .behaviour, questions: [
        Question(text: "Your child engages in stereotyped and repetitive motor mannerisms"),
                                                Question(text: "Your child shows attachment to inanimate objects"),
                                                Question(text: "Your child shows hyperactivity/restlessness"),
                                                Question(text: "Your child exhibits aggressive behavior"),
                                                Question(text: "Your child throws temper tantrums"),
                                                Question(text: "Your child engages in self-injurious behavior"),
                                                Question(text: "Your child insists on sameness")
    ]),
    CategoryWiseQuestion(category: .sensory, questions: [
        Question(text: "Your child unusually sensitive to sensory stimuli"),
                                             Question(text: "Your child stares into space for long periods of time"),
                                             Question(text: "Your child has difficulty in tracking objects"),
                                             Question(text: "Your child has unusual vision"),
                                             Question(text: "Your child is insensitive to pain"),
                                             Question(text: "Your child responds to objects/people unusually by smelling, touching or tasting")
    ]),
    CategoryWiseQuestion(category: .cognitive, questions: [
        Question(text: "Your child is inconsistent attention and concentrationt"),
                                               Question(text: "Your child shows delay in responding"),
                                               Question(text: "Your child has unusual memory of some kind"),
                                               Question(text: "Your child has 'savant' ability")
    ])
]

