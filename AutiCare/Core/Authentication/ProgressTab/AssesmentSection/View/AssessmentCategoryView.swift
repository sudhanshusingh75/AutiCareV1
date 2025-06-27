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
    let categoryIndex: Int
    let totalCategories: Int

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text(viewModel.currentCategory.category.rawValue)
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.top)

            Text("Category \(categoryIndex + 1) of \(totalCategories)")
                .font(.subheadline)
                .foregroundColor(.gray)

            ProgressView(value: Double(categoryIndex + 1), total: Double(totalCategories))
                .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0, green: 0.387, blue: 0.5)))
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
                                .foregroundColor(Color(red: 0, green: 0.387, blue: 0.5))

                            let sliderBinding = Binding<Double>(
                                get: {
                                    Double(viewModel.getSelectedScore(for: question.id)) * 20.0
                                },
                                set: { newValue in
                                    let normalized = Int(round(newValue / 20.0))
                                    viewModel.selectOption(questionID: question.id, score: normalized)
                                }
                            )

                            Slider(value: sliderBinding, in: 20...100, step: 20)
                        }
                        .padding()
                    }
                }
            }

            Button(action: {
                if viewModel.allQuestionsAnsweredInCurrentCategory() {
                    viewModel.goToNextCategory()
                    if viewModel.isLastCategory{
                        
                    }
                }
            }) {
                Text("Next Category")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.allQuestionsAnsweredInCurrentCategory() ? Color(red: 0, green: 0.387, blue: 0.5) : Color.gray)
                    .cornerRadius(16)
            }
            .disabled(!viewModel.allQuestionsAnsweredInCurrentCategory())
            .padding(.top, 24)
        }
        .padding()
    }
}

#Preview {
    AssessmentCategoryView(
        viewModel: AssessmentViewModel(),
        categoryIndex: 0,
        totalCategories: 6
    )
}
