//
//  MathQuizView.swift
//  Auticare
//
//  Created by sourav_singh on 20/02/25.
//

import SwiftUI

struct MathQuizView: View {
    struct MathQuestion {
        let question: String
        let answer: Int
    }
    
    let questions: [MathQuestion] = [
        MathQuestion(question: "5 + 3 = ?", answer: 8),
        MathQuestion(question: "10 - 4 = ?", answer: 6),
        MathQuestion(question: "6 × 2 = ?", answer: 12),
        MathQuestion(question: "15 ÷ 3 = ?", answer: 5),
        MathQuestion(question: "7 + 5 = ?", answer: 12),
        MathQuestion(question: "9 - 3 = ?", answer: 6),
        MathQuestion(question: "8 × 3 = ?", answer: 24),
        MathQuestion(question: "20 ÷ 4 = ?", answer: 5),
        MathQuestion(question: "12 + 6 = ?", answer: 18),
        MathQuestion(question: "14 - 7 = ?", answer: 7)
    ]
    
    @State private var currentQuestionIndex = 0
    @State private var userAnswer = ""
    @State private var correctAnswers = 0
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var quizCompleted = false
    @Environment(\.presentationMode) var presentationMode
    
    var progress: Double {
        return Double(currentQuestionIndex) / Double(questions.count)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                if quizCompleted {
                    VStack(spacing: 20) {
                        Text("🎉 Quiz Completed!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.purple)
                            .padding()
                            .transition(.scale)
                        
                        Text("Your Score: \(correctAnswers) / \(questions.count)")
                            .font(.title)
                            .foregroundColor(.black)
                            .padding()
                        
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Text("Return to Learning")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        .padding()
                        .shadow(radius: 5)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding()
                    .transition(.scale)
                } else {
                    VStack(spacing: 20) {
                        Text("Solve the Math Problem! 🧮")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.purple)
                            .padding()
                            .transition(.opacity)
                        
                        ProgressView(value: progress)
                            .progressViewStyle(LinearProgressViewStyle())
                            .padding()
                            .accentColor(.orange)
                        
                        Text(questions[currentQuestionIndex].question)
                            .font(.title)
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .padding()
                            .transition(.scale)
                        
                        TextField("Enter your answer", text: $userAnswer)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                        
                        Button(action: { checkAnswer() }) {
                            Text("Submit")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        .padding()
                        .shadow(radius: 5)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding()
                }
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Result"), message: Text(alertMessage), dismissButton: .default(Text("Next")) {
                nextQuestion()
            })
        }
    }
    
    func checkAnswer() {
        if let answer = Int(userAnswer), answer == questions[currentQuestionIndex].answer {
            alertMessage = "🎉 Correct! Well done."
            correctAnswers += 1
        } else {
            alertMessage = "❌ Oops! The correct answer was \(questions[currentQuestionIndex].answer)."
        }
        showAlert = true
    }
    
    func nextQuestion() {
        userAnswer = ""
        if currentQuestionIndex < questions.count - 1 {
            withAnimation {
                currentQuestionIndex += 1
            }
        } else {
            withAnimation {
                quizCompleted = true
            }
        }
    }
}

struct MathQuizView_Previews: PreviewProvider {
    static var previews: some View {
        MathQuizView()
    }
}
