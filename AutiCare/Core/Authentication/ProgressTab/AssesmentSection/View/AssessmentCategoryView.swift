//
//  AssessmentCategoryView.swift
//  Auticare
//
//  Created by Sudhanshu Singh Rajput on 26/06/25.
//

//  AssessmentCategoryView.swift
//  Auticare

import SwiftUI

struct AssessmentCategoryView: View {
    @ObservedObject var viewModel: AssessmentViewModel
    let categoryTitle: String
    let categoryIndex: Int
    let totalCategories: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: { /* Go Back */ }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
                Text(categoryTitle)
                    .font(.title2.bold())
                    .foregroundColor(.black)
                Spacer()
                Spacer() // balance layout
            }
            .padding(.top)

            Text("Category \(categoryIndex) of \(totalCategories)")
                .font(.subheadline)
                .foregroundColor(.gray)

            ProgressView(value: Double(categoryIndex), total: Double(totalCategories))
                .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
                .padding(.bottom, 16)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(viewModel.questionsForCurrentCategory()) { question in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(question.text)
                                .font(.headline)
                                .lineLimit(2)

                            Text(viewModel.labelForScore(questionID: question.id))
                                .font(.subheadline)
                                .foregroundColor(.blue)

                            Slider(value: Binding(
                                get: {
                                    Double(viewModel.selectedAnswers[question.id] ?? 1) * 20.0
                                },
                                set: { newValue in
                                    let normalized = Int(round(newValue / 20.0))
                                    viewModel.selectOption(questionID: question.id, score: normalized)
                                }
                            ), in: 20...100, step: 20)
                        }
                    }
                }
            }

            Button(action: {
                viewModel.goToNextCategory()
            }) {
                Text("Next Category")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(16)
            }
            .padding(.top, 24)
        }
        .padding()
    }
}


#Preview {
    AssessmentCategoryView()
}
