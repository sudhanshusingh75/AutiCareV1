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
    
    var progressPercentage: Int {
        Int((Float(categoryIndex) / Float(allQuestions.count)) * 100)
    }
    
    var isCategoryCompleted: Bool {
        return !answers[categoryIndex].contains(0)
    }

    var body: some View {
        NavigationView {
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
                            NavigationLink(destination: ResultView(answers: answers)) {
                                Text("Submit")
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }.navigationBarBackButtonHidden(true)
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))
        }
    }
}
#Preview {
    QuestionView()
}
