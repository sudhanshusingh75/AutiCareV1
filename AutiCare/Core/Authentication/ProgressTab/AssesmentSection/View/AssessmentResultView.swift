//
//  AssessmentResultView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 30/06/25.
//

import SwiftUI
import Charts
import FirebaseFirestore
import FirebaseAuth

struct CategoryScore: Identifiable {
    let id = UUID()
    let category: String
    let score: Int
}

struct AssessmentResultView: View {
    
    @EnvironmentObject var navManager: NavigationManager
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel =  AssessmentViewModel()
    let childId: String
    var showSaveButton: Bool = false
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Loading results...")
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text("\(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                VStack(spacing: 24) {
                    Text("Assessment Results")
                        .font(.largeTitle.bold())
                        .padding(.top)

                    VStack {
                        Text("Overall Score")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("\(viewModel.normalizedTotalPercentage)%")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.blue)
                        
                        Text(autismLabel.text)
                            .font(.headline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(autismLabel.color.opacity(0.2))
                            .foregroundColor(autismLabel.color)
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Category Breakdown")
                            .font(.headline)
                            .padding(.leading)
                        let scores = viewModel.normalizedCategoryScores()
                        Chart(scores) { score in
                            BarMark(
                                x: .value("Score", score.score),
                                y: .value("Category", score.category)
                            )
                            .foregroundStyle(gradient(for: score.score))
                        }
                        .chartXScale(domain: 0...100)
                        .frame(height: CGFloat(scores.count * 60))
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }

                    VStack(spacing: 12) {
                        Text("Preliminary Observation")
                            .font(.headline)
                        Text(scoreComment)
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(12)
                }
                .padding()
            }
            if showSaveButton{
                Button {
                    navManager.assessmentInProgress = false
                } label: {
                    Text("Save")
                        .font(.headline)
                        .padding()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color(red:0,green: 0.387,blue: 0.5))
                        .cornerRadius(16)
                        .padding(.horizontal)
                }
            }
        }
        .navigationBarBackButtonHidden(showSaveButton)
        .onAppear {
            viewModel.fetchResults(childId: childId)
        }
    }

    private func gradient(for score: Int) -> LinearGradient {
        switch score {
        case 0..<30:
            return .init(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing)
        case 30..<65:
            return .init(colors: [.yellow, .orange], startPoint: .leading, endPoint: .trailing)
        default:
            return .init(colors: [.red, .pink], startPoint: .leading, endPoint: .trailing)
        }
    }

    private var scoreComment: String {
        let percentage = viewModel.normalizedTotalPercentage

        switch percentage {
        case 0..<25:
            return "No significant autism traits detected. Your child’s responses suggest typical developmental behavior. If you still have concerns, consider consulting a professional."
        case 25..<50:
            return "Mild signs of autism traits observed. While not conclusive, a detailed evaluation by a professional could help clarify your child’s developmental profile."
        case 50..<75:
            return "Moderate indication of autism traits. It's advisable to seek a formal assessment from a qualified specialist for a deeper understanding."
        default:
            return "Strong indication of autism traits. A comprehensive evaluation by a specialist is strongly recommended for diagnosis and support planning."
        }
    }

    
    private var autismLabel: (text: String, color: Color) {
        let percentage = viewModel.normalizedTotalPercentage
        
        switch percentage {
        case 0..<25:
            return ("No Autism Traits", .green)
        case 25..<50:
            return ("Mild Autism Traits", .yellow)
        case 50..<75:
            return ("Moderate Autism Traits", .orange)
        default:
            return ("Severe Autism Traits", .red)
        }
    }


}

