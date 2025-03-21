//
//  QuestionView.swift
//  Auticare
//
//  Created by sourav_singh on 20/02/25.
//

import SwiftUI

struct QuestionView: View {
    @State private var categoryIndex = 0
    @State private var answers: [[Int]] = allQuestions.map { $0.questions.map { _ in 0 } }
    
    @State private var showResultView = false // State to control navigation to ResultView
    
    var progressPercentage: Int {
        Int((Float(categoryIndex) / Float(allQuestions.count)) * 100)
    }
    
    // Check if all questions in the current category are answered
    var isCategoryCompleted: Bool {
        return !answers[categoryIndex].contains(0)
    }
    
    // Check if all questions in all categories are answered
    var isAllCategoriesCompleted: Bool {
        return !answers.flatMap { $0 }.contains(0)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ProgressView(value: Float(categoryIndex), total: Float(allQuestions.count))
                        .padding()
                        .tint(.green)
                    
                    Text("Completion: \(progressPercentage)%")
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .padding(.bottom, 5)
                    
                    Text(allQuestions[categoryIndex].category.rawValue)
                        .font(.title)
                        .bold()
                        .padding()
                    
                    Text("Select the most appropriate response:")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("✅ 1 - Rarely (Up to 20%)")
                        Text("✅ 2 - Sometimes (21–40%)")
                        Text("✅ 3 - Frequently (41–60%)")
                        Text("✅ 4 - Mostly (61–80%)")
                        Text("✅ 5 - Always (81–100%)")
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.1)))
                    .padding()
                    
                    ForEach(allQuestions[categoryIndex].questions.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(allQuestions[categoryIndex].questions[index].text)
                                .font(.headline)
                                .padding(.bottom, 5)
                            
                            HStack(spacing: 10) {
                                ForEach(1...5, id: \.self) { value in
                                    Button(action: {
                                        answers[categoryIndex][index] = value
                                    }) {
                                        Text("\(value)")
                                            .frame(width: 50, height: 50)
                                            .background(answers[categoryIndex][index] == value ? Color.mint : Color.gray.opacity(0.2))
                                            .foregroundColor(.white)
                                            .clipShape(Circle())
                                    }
                                    .animation(.easeInOut, value: answers[categoryIndex][index])
                                }
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                        .padding(.horizontal)
                    }
                    
                    // Navigation Buttons
                    HStack {
                        if categoryIndex > 0 {
                            Button(action: { categoryIndex -= 1 }) {
                                HStack {
                                    Image(systemName: "arrow.left")
                                        .tint(.white)
                                    Text("Previous")
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.mint)
                                .cornerRadius(10)
                            }
                        }
                        
                        Spacer()
                        
                        if categoryIndex < allQuestions.count - 1 {
                            Button(action: {
                                if isCategoryCompleted {
                                    categoryIndex += 1
                                }
                            }) {
                                HStack {
                                    Text("Next")
                                        .foregroundColor(.white)
                                    Image(systemName: "arrow.right")
                                        .tint(.white)
                                }
                                .padding()
                                .background(isCategoryCompleted ? Color.mint : Color.gray.opacity(0.5))
                                .cornerRadius(10)
                            }
                            .disabled(!isCategoryCompleted)
                        } else {
                            // Show Submit button only if all categories are completed
                            if isAllCategoriesCompleted {
                                Button(action: {
                                    showResultView = true
                                }) {
                                    Text("Submit")
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true) // Hide the back button
            .navigationTitle("ISAA Assessment")
            .navigationDestination(isPresented: $showResultView) {
                ResultView(answers: answers)
                    .navigationBarBackButtonHidden(true) // Hide the back button on ResultView
            }
        }
    }
}

#Preview {
    QuestionView()
}
