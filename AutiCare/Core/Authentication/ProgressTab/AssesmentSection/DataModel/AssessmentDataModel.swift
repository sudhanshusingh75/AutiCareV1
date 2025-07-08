//
//  AssessmentDataModel.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 29/06/25.
//

import Foundation
import SwiftUI

struct ChildDetails: Codable, Identifiable,Hashable {
    var id: String = UUID().uuidString
    var fullName: String
    var dateOfBirth: Date
    var gender: String
    var imageData: Data?
    var score: Int?
}


struct Question:Identifiable,Codable{
    var id = UUID()
    var text:String
    var selectedOption:QuestionOption? = nil
}

struct CategoryWiseQuestion {
    let questionCategory:QuestionCategory
    var questions:[Question]
}

enum QuestionCategory: String, CaseIterable, Codable {
    case social = "Social Skills"
    case emotional = "Emotional Response"
    case communication = "Communication"
    case behaviour = "Behaviour"
    case sensory = "Sensory"
    case cognitive = "Thinking Skills"
}

enum QuestionOption: String, CaseIterable, Codable, Identifiable {
    case rarely = "Rarely"
    case sometimes = "Sometimes"
    case frequently = "Frequently"
    case mostly = "Mostly"
    case always = "Always"
    
    var id: String { self.rawValue }
    
    var Score:Int {
        switch self {
        case .rarely: return 1
        case .sometimes: return 2
        case .frequently: return 3
        case .mostly: return 4
        case .always: return 5
        }
    }
    
    var buttonLabel:String {
        switch self {
        case .rarely: return "1"
        case .sometimes: return "2"
        case .frequently: return "3"
        case .mostly: return "4"
        case .always: return "5"
        }
    }
    var color:Color{
        switch self{
        case .rarely: return .green
        case .sometimes: return .mint
        case .frequently: return .yellow
        case .mostly: return .orange
        case .always: return .red
        }
    }
}

